import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:http/http.dart' as http;
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

class MapStyleOption {
  final String name;
  final String url;
  final String attribution;
  final IconData icon;

  const MapStyleOption({
    required this.name,
    required this.url,
    required this.attribution,
    required this.icon,
  });
}

class VehicleLocation {
  final String id;
  final String name;
  final LatLng position;
  final DateTime serverTime;
  final DateTime trackerTime;
  final double speed;
  final bool isValid;

  VehicleLocation({
    required this.id,
    required this.name,
    required this.position,
    required this.serverTime,
    required this.trackerTime,
    required this.speed,
    required this.isValid,
  });

  factory VehicleLocation.fromJson(String id, Map<String, dynamic> json) {
    return VehicleLocation(
      id: id,
      name: json['name'] ?? 'Unknown',
      position: LatLng(
        double.tryParse(json['lat'] ?? '0') ?? 0,
        double.tryParse(json['lng'] ?? '0') ?? 0,
      ),
      serverTime: DateTime.parse(json['dt_server']),
      trackerTime: DateTime.parse(json['dt_tracker']),
      speed: double.tryParse(json['speed'] ?? '0') ?? 0,
      isValid: json['loc_valid'] == "1",
    );
  }
}

class CustomersMapPage extends StatefulWidget {
  const CustomersMapPage({super.key});

  @override
  State<CustomersMapPage> createState() => _CustomersMapPageState();
}

class _CustomersMapPageState extends State<CustomersMapPage> {
  bool _showVehicles = true;
  bool _showCustomers = true;
  List<CustomerBriefViewModel> customers = [];
  List<VehicleLocation> vehicles = [];
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _vehicleLocationTimer;

  final List<MapStyleOption> _mapStyles = const [
    MapStyleOption(
      name: 'Street View',
      url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: '© OpenStreetMap contributors',
      icon: Icons.map,
    ),
    MapStyleOption(
      name: 'Satellite View',
      url:
          'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
      attribution: 'Tiles © Esri',
      icon: Icons.satellite,
    ),
    MapStyleOption(
      name: 'Terrain View',
      url:
          'https://server.arcgisonline.com/ArcGIS/rest/services/World_Terrain_Base/MapServer/tile/{z}/{y}/{x}',
      attribution: 'Tiles © Esri',
      icon: Icons.terrain,
    ),
    MapStyleOption(
      name: 'Humanitarian',
      url: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
      attribution: '© OpenStreetMap contributors, HOT',
      icon: Icons.emergency,
    ),
  ];

  MapStyleOption _selectedMapStyle = const MapStyleOption(
    name: 'Humanitarian',
    url: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
    attribution: '© OpenStreetMap contributors, HOT',
    icon: Icons.emergency,
  );

  @override
  void initState() {
    super.initState();
    _fetchVehicleLocations();
    _vehicleLocationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchVehicleLocations();
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _vehicleLocationTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchVehicleLocations() async {
    try {
      const url =
          'https://admin.alather.net/api/api.php?api=user&ver=1.0&key=01B38F9954111726C2994BD242A4BB37&cmd=OBJECT_GET_LOCATIONS,354778341874934;354778341876285;354778341876368;354778341878273;354778341875998;354778341875014;354778341875436;354778341875857;354778341875121';

      final httpClient = HttpClient()
        ..badCertificateCallback =
            (cert, host, port) => host == 'admin.alather.net';

      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);
        final newVehicles = <VehicleLocation>[];

        data.forEach((key, value) {
          try {
            newVehicles.add(VehicleLocation.fromJson(key, value));
          } catch (e) {
            debugPrint('Error parsing vehicle $key: $e');
          }
        });

        setState(() {
          vehicles = newVehicles;
        });
      } else {
        debugPrint('Failed to fetch vehicle locations: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching vehicle locations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppUserCubit>().state;
    final groups = state is AppUserLoggedIn ? state.userEntity.groups : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                _showCustomers ? Icons.location_on : Icons.location_off,
                color: _showCustomers ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _showCustomers = !_showCustomers;
                });
              },
              tooltip: 'إظهار/إخفاء العملاء',
            ),
            if (groups != null &&
                (groups.contains('admins') || groups.contains('GPS_users')))
              IconButton(
                icon: Icon(
                  _showVehicles
                      ? FontAwesomeIcons.car
                      : FontAwesomeIcons.carSide,
                  color: _showVehicles ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _showVehicles = !_showVehicles;
                  });
                },
                tooltip: 'إظهار/إخفاء المركبات',
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButton<MapStyleOption>(
                value: _selectedMapStyle,
                icon: const Icon(Icons.arrow_drop_down),
                underline: const SizedBox(),
                onChanged: (MapStyleOption? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedMapStyle = newValue;
                    });
                  }
                },
                items:
                    _mapStyles.map<DropdownMenuItem<MapStyleOption>>((style) {
                  return DropdownMenuItem<MapStyleOption>(
                    value: style,
                    child: Row(
                      children: [
                        Icon(style.icon, size: 20),
                        const SizedBox(width: 8),
                        Text(style.name),
                      ],
                    ),
                  );
                }).toList(),
              ),
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
                    urlTemplate: _selectedMapStyle.url,
                    userAgentPackageName: 'com.example.app',
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        _selectedMapStyle.attribution,
                        prependCopyright: false,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      ..._buildCustomerMarkers(context),
                      ..._buildVehicleMarkers(groups),
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
      ),
    );
  }

  List<Marker> _buildVehicleMarkers(List<String>? groups) {
    if (!_showVehicles) return [];
    if (groups != null &&
        (groups.contains('admins') || groups.contains('GPS_users'))) {
      return vehicles.map((vehicle) {
        String arabicName = vehicle.name.split('-').last.trim();

        return Marker(
          width: 80,
          height: 80,
          point: vehicle.position,
          child: InkWell(
            onTap: () => _showVehicleDialog(
              context: context,
              vehicleName: vehicle.name,
              speed: vehicle.speed,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    arabicName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                FaIcon(
                  FontAwesomeIcons.car,
                  color: vehicle.isValid
                      ? Colors.green.shade800
                      : Colors.orange.shade800,
                  size: 25,
                ),
              ],
            ),
          ),
        );
      }).toList();
    }
    return [];
  }

  List<Marker> _buildCustomerMarkers(BuildContext context) {
    if (!_showCustomers) return [];
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

  void _showVehicleDialog({
    required BuildContext context,
    required String vehicleName,
    required double speed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'بيانات المركبة',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogRow('اسم المركبة:', vehicleName),
                const SizedBox(height: 8),
                _buildDialogRow(
                    'السرعة:', '${speed.toStringAsFixed(1)} كم/ساعة'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('رجوع'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Row(
      // Changed to Row for better alignment of label and value
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    );
  }
}
