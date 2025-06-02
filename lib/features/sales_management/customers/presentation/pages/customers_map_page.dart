import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/pages/full_customer_data_page.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_brief_view_model.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_view_model.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:latlong2/latlong.dart';

class CustomersMapPage extends StatefulWidget {
  const CustomersMapPage({super.key});

  @override
  State<CustomersMapPage> createState() => _CustomersMapPageState();
}

class _CustomersMapPageState extends State<CustomersMapPage> {
  List<CustomerBriefViewModel> customers = [];
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _startTrackingLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _startTrackingLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar(
        context: context,
        content: 'خدمة الموقع غير مفعلة. يرجى تفعيلها',
        failure: true,
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBar(
          context: context,
          content: 'تم رفض إذن الوصول إلى الموقع',
          failure: true,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackBar(
        context: context,
        content: 'يجب منح إذن الوصول إلى الموقع من إعدادات التطبيق',
        failure: true,
      );
      return;
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentLocation!, 15);
    });
  }

  Future<void> _getCurrentLocationOnce() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentLocation!, 15);
    } catch (e) {
      showSnackBar(
        context: context,
        content: 'فشل في الحصول على الموقع: ${e.toString()}',
        failure: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: 'backButton',
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            mini: true,
            heroTag: 'locationButton',
            onPressed: _getCurrentLocationOnce,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => getIt<SalesBloc>()
          ..add(SalesGetAllPaginated<CustomerBriefViewModel>(
              page: 1, hasCood: 1, pageSize: 100000000)),
        child: BlocConsumer<SalesBloc, SalesState>(
          listener: (context, state) {
            if (state is SalesOpSuccess<List<CustomerBriefViewModel>>) {
              setState(() {
                customers = state.opResult;
              });
            } else if (state is SalesOpFailure) {
              showSnackBar(
                context: context,
                content: 'حدث خطأ ما',
                failure: true,
              );
            }

            if (state is SalesOpSuccess<CustomerViewModel>) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return FullCustomerDataPage(
                      customerViewModel: state.opResult,
                    );
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is SalesOpLoading) {
              return const Loader();
            }

            return FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(33.5130556, 36.2919444),
                initialZoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    ..._buildCustomerMarkers(context),
                    if (_currentLocation != null)
                      Marker(
                        width: 40,
                        height: 40,
                        point: _currentLocation!,
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Marker> _buildCustomerMarkers(BuildContext context) {
    return customers
        .map((customer) {
          if (customer.shopCoordinates == null) return null;
          List<String> coords = customer.shopCoordinates!.split(',');
          if (coords.length != 2) return null;

          double? latitude = double.tryParse(coords[0]);
          double? longitude = double.tryParse(coords[1]);
          if (latitude == null || longitude == null) return null;

          return Marker(
            width: 30,
            height: 30,
            point: LatLng(latitude, longitude),
            child: InkWell(
              onTap: () => _showLocationDialog(
                context: context,
                customerName: customer.customerName ?? '',
                shopName: customer.shopName ?? '',
                address: customer.address ?? '',
                onFullDetailsPressed: () {
                  context.read<SalesBloc>().add(
                        SalesGetById<CustomerViewModel>(id: customer.id),
                      );
                },
              ),
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 30,
              ),
            ),
          );
        })
        .whereType<Marker>()
        .toList();
  }

  void _showLocationDialog({
    required BuildContext context,
    required String customerName,
    required String shopName,
    required String address,
    required VoidCallback onFullDetailsPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'بيانات الزبون',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogRow('اسم الزبون:', customerName),
                const SizedBox(height: 8),
                _buildDialogRow('اسم المحل:', shopName),
                const SizedBox(height: 8),
                _buildDialogRow('العنوان:', address),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('رجوع'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onFullDetailsPressed();
                },
                child: const Text('كافة البيانات'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}
