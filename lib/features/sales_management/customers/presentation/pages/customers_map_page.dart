import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
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
import 'package:url_launcher/url_launcher.dart';

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

// New class for Route Data
class VehicleRoute {
  final String vehicleId;
  final String vehicleName;
  final List<RoutePoint> points;
  final List<RouteStop> stops;
  final List<RouteDrive> drives;
  final double routeLength;
  final double topSpeed;
  final double avgSpeed;

  VehicleRoute({
    required this.vehicleId,
    required this.vehicleName,
    required this.points,
    required this.stops,
    required this.drives,
    required this.routeLength,
    required this.topSpeed,
    required this.avgSpeed,
  });
}

class RoutePoint {
  final DateTime timestamp;
  final LatLng position;
  final double speed;
  final Map<dynamic, dynamic> params;

  RoutePoint({
    required this.timestamp,
    required this.position,
    required this.speed,
    required this.params,
  });
}

class RouteStop {
  final DateTime startTime;
  final DateTime endTime;
  final LatLng position;
  final String duration;
  final double speed;

  RouteStop({
    required this.startTime,
    required this.endTime,
    required this.position,
    required this.duration,
    required this.speed,
  });
}

class RouteDrive {
  final DateTime startTime;
  final DateTime endTime;
  final String duration;
  final double routeLength;
  final double topSpeed;
  final double avgSpeed;

  RouteDrive({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.routeLength,
    required this.topSpeed,
    required this.avgSpeed,
  });
}

class VehicleMarkerWidget extends StatelessWidget {
  final String arabicName;
  final double speed;
  final bool isValid;

  const VehicleMarkerWidget({
    super.key,
    required this.arabicName,
    required this.speed,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    Color pinColor;
    if (!isValid) {
      pinColor = Colors.orange.shade800;
    } else if (speed > 5) {
      pinColor = Colors.green.shade700;
    } else {
      pinColor = Colors.red.shade700;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: pinColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            arabicName,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: pinColor,
            ),
            textDirection: TextDirection.rtl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        FaIcon(
          FontAwesomeIcons.car,
          color: pinColor,
          size: 25,
        ),
      ],
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
  bool _isFetchingRoute = false;
  bool _isRouteMode = false; // New flag for route mode
  bool _showMyLocation = true; // New flag to show/hide my location
  List<CustomerBriefViewModel> customers = [];
  List<VehicleLocation> vehicles = [];
  Map<String, List<LatLng>> vehicleRoutes = {};
  Map<String, VehicleRoute> vehicleRouteHistory = {};

  // Available vehicles for selection
  final Map<String, String> availableVehicles = {
    '354778341875857': '344742 - فان فوتون',
    '354778341875436': '963825 - دايو كالوس',
    '354778341874934': '105194 - سيلو',
    "354778341876368": "761884 -KIA عامر",
    "354778341876285": "247527 -KIA عويد",
    "354778341878273": "765314 - KIA غنيم",
    "354778341875998": "766156 - KIA دياب",
    "354778341875014": "788813 - KIA هيثم",
    "354778341875121": "5177807 - هونداي H1",
  };

  // Route tracking variables
  String? _selectedVehicleId;
  DateTime? _selectedDate;
  VehicleRoute? _currentRoute;

  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _vehicleLocationTimer;

  final List<MapStyleOption> _mapStyles = const [
    MapStyleOption(
      name: 'Google Maps Roadmap',
      url: 'http://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}',
      attribution: '© Google',
      icon: Icons.landscape,
    ),
    MapStyleOption(
      name: 'Google Maps Hybrid',
      url: 'http://mt0.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}',
      attribution: '© Google',
      icon: Icons.satellite,
    ),
    MapStyleOption(
      name: 'Carto Light',
      url:
          'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
      attribution: '© CartoDB',
      icon: Icons.light_mode,
    ),
    MapStyleOption(
      name: 'Carto Dark',
      url:
          'https://cartodb-basemaps-a.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png',
      attribution: '© CartoDB',
      icon: Icons.dark_mode,
    ),
  ];

  late MapStyleOption _selectedMapStyle;

  @override
  void initState() {
    super.initState();
    _selectedMapStyle = _mapStyles.first;
    _startLocationStream();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _vehicleLocationTimer?.cancel();
    super.dispose();
  }

  bool _hasVehiclePermission(List<String>? groups) {
    return groups != null &&
        (groups.contains('admins') ||
            groups.contains('managers') ||
            groups.contains('GPS_users'));
  }

  bool _hasCustomerPermission(List<String>? groups) {
    return groups != null &&
        (groups.contains('admins') ||
            groups.contains('managers') ||
            groups.contains('Sales'));
  }

  String _getAppBarTitle(List<String>? groups) {
    // Show route information if in route mode
    if (_isRouteMode && _currentRoute != null) {
      return 'مسار ${_currentRoute!.vehicleName} - ${_selectedDate?.toLocal().toString().split(' ')[0] ?? ''}';
    }

    final hasVehiclePermission = _hasVehiclePermission(groups);
    final hasCustomerPermission = _hasCustomerPermission(groups);

    if (hasVehiclePermission && hasCustomerPermission) {
      return 'خريطة العملاء والمركبات';
    } else if (hasVehiclePermission) {
      return 'خريطة المركبات';
    } else if (hasCustomerPermission) {
      return 'خريطة العملاء';
    } else {
      return 'الخريطة';
    }
  }

  void _startLocationStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
      }
    });
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        showSnackBar(
            context: context, content: 'خدمة الموقع معطلة', failure: true);
      }
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        if (mounted) {
          showSnackBar(
              context: context, content: 'تم رفض أذونات الموقع', failure: true);
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        showSnackBar(
            context: context,
            content: 'أذونات الموقع مرفوضة بشكل دائم. لا يمكن طلب الأذونات.',
            failure: true);
      }
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (mounted) {
        showSnackBar(
            context: context,
            content: 'فشل الحصول على موقعك الحالي',
            failure: true);
      }
      return null;
    }
  }

  Future<void> _launchNavigation(LatLng destination) async {
    final position = await _determinePosition();
    if (position == null) return;

    final startLat = position.latitude;
    final startLng = position.longitude;
    final endLat = destination.latitude;
    final endLng = destination.longitude;

    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng&travelmode=driving';

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        showSnackBar(
            context: context,
            content: 'تعذر تشغيل تطبيق الخريطة',
            failure: true);
      }
    }
  }

  Future<void> _centerMapOnCurrentLocation() async {
    final position = await _determinePosition();
    if (position != null) {
      final newCenter = LatLng(position.latitude, position.longitude);
      _mapController.move(newCenter, 15);

      if (mounted) {
        setState(() {
          _currentLocation = newCenter;
        });
      }
    }
  }

  // New function to fetch vehicle route
  Future<void> _fetchVehicleRoute() async {
    if (_selectedVehicleId == null || _selectedDate == null) {
      showSnackBar(
        context: context,
        content: 'الرجاء اختيار المركبة والتاريخ',
        failure: true,
      );
      return;
    }

    setState(() {
      _isFetchingRoute = true;
    });

    try {
      final startDate = _selectedDate!;
      final endDate = startDate.add(const Duration(days: 1));

      final startStr = startDate.toIso8601String().split('T').first;
      final endStr = endDate.toIso8601String().split('T').first;

      final url =
          'https://admin.alather.net/api/api.php?api=user&ver=1.0&key=01B38F9954111726C2994BD242A4BB37&cmd=OBJECT_GET_ROUTE,$_selectedVehicleId,$startStr 00:00:00,$endStr 00:00:00,1';

      debugPrint('Fetching route from: $url');

      final httpClient = HttpClient()
        ..badCertificateCallback =
            (cert, host, port) => host == 'admin.alather.net';

      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);

        debugPrint('Route response received');
        _processRouteData(data);
      } else {
        debugPrint('Failed to fetch route: ${response.statusCode}');
        showSnackBar(
          context: context,
          content: 'فشل في جلب المسار',
          failure: true,
        );
      }
    } catch (e) {
      debugPrint('Error fetching route: $e');
      showSnackBar(
        context: context,
        content: 'خطأ في جلب المسار: $e',
        failure: true,
      );
    } finally {
      setState(() {
        _isFetchingRoute = false;
      });
    }
  }

  void _processRouteData(Map<String, dynamic> data) {
    try {
      final routePoints = <RoutePoint>[];
      final stops = <RouteStop>[];
      final drives = <RouteDrive>[];

      // Process route points
      if (data['route'] != null && data['route'] is List) {
        for (var point in data['route'] as List) {
          if (point is List && point.length >= 7) {
            final timestamp = DateTime.parse(point[0] as String);
            final lat = double.tryParse(point[1] as String) ?? 0;
            final lng = double.tryParse(point[2] as String) ?? 0;
            final speed =
                (point[5] is int) ? (point[5] as int).toDouble() : 0.0;
            final params = point[6] is Map<String, dynamic>
                ? point[6] as Map<String, dynamic>
                : {};

            routePoints.add(RoutePoint(
              timestamp: timestamp,
              position: LatLng(lat, lng),
              speed: speed,
              params: params,
            ));
          }
        }
      }

      // Process stops
      if (data['stops'] != null && data['stops'] is List) {
        for (var stop in data['stops'] as List) {
          final startTime = DateTime.parse(stop['dt_start'] as String);
          final endTime = DateTime.parse(stop['dt_end'] as String);
          final lat = double.tryParse(stop['lat'] as String) ?? 0;
          final lng = double.tryParse(stop['lng'] as String) ?? 0;
          final speed =
              stop['speed'] is int ? (stop['speed'] as int).toDouble() : 0.0;

          stops.add(RouteStop(
            startTime: startTime,
            endTime: endTime,
            position: LatLng(lat, lng),
            duration: stop['duration'] as String? ?? '',
            speed: speed,
          ));
        }
      }

      // Process drives
      if (data['drives'] != null && data['drives'] is List) {
        for (var drive in data['drives'] as List) {
          final startTime = DateTime.parse(drive['dt_start'] as String);
          final endTime = DateTime.parse(drive['dt_end'] as String);

          drives.add(RouteDrive(
            startTime: startTime,
            endTime: endTime,
            duration: drive['duration'] as String? ?? '',
            routeLength: drive['route_length'] is num
                ? (drive['route_length'] as num).toDouble()
                : 0.0,
            topSpeed: drive['top_speed'] is int
                ? (drive['top_speed'] as int).toDouble()
                : 0.0,
            avgSpeed: drive['avg_speed'] is int
                ? (drive['avg_speed'] as int).toDouble()
                : 0.0,
          ));
        }
      }

      final vehicleRoute = VehicleRoute(
        vehicleId: _selectedVehicleId!,
        vehicleName: availableVehicles[_selectedVehicleId] ?? 'Unknown',
        points: routePoints,
        stops: stops,
        drives: drives,
        routeLength: data['route_length'] is num
            ? (data['route_length'] as num).toDouble()
            : 0.0,
        topSpeed: data['top_speed'] is int
            ? (data['top_speed'] as int).toDouble()
            : 0.0,
        avgSpeed: data['avg_speed'] is int
            ? (data['avg_speed'] as int).toDouble()
            : 0.0,
      );

      setState(() {
        _currentRoute = vehicleRoute;
        _isRouteMode = true; // Enter route mode
        vehicleRouteHistory[_selectedVehicleId!] = vehicleRoute;

        // Hide customers and vehicles in route mode
        _showCustomers = false;
        _showVehicles = false;

        // Center map on route if there are points
        if (routePoints.isNotEmpty) {
          final firstPoint = routePoints.first.position;
          _mapController.move(firstPoint, 13);
        }
      });

      showSnackBar(
        context: context,
        content: 'تم جلب مسار المركبة بنجاح',
        failure: false,
      );
    } catch (e) {
      debugPrint('Error processing route data: $e');
      showSnackBar(
        context: context,
        content: 'خطأ في معالجة بيانات المسار',
        failure: true,
      );
    }
  }

  // Function to clear route and return to normal mode
  void _clearRoute() {
    setState(() {
      _currentRoute = null;
      _isRouteMode = false;
      _selectedVehicleId = null;

      // Restore previous visibility settings
      _showCustomers = true;
      _showVehicles = true;
    });

    showSnackBar(
      context: context,
      content: 'تم مسح المسار والعودة للوضع الطبيعي',
      failure: false,
    );
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
        final newRoutes = Map<String, List<LatLng>>.from(vehicleRoutes);

        (data as Map<String, dynamic>).forEach((key, value) {
          try {
            final vehicle = VehicleLocation.fromJson(key, value);
            newVehicles.add(vehicle);
            if (!newRoutes.containsKey(key)) {
              newRoutes[key] = [];
            }
            final lastPoint =
                newRoutes[key]!.isEmpty ? null : newRoutes[key]!.last;
            if (lastPoint == null ||
                (const Distance()).distance(lastPoint, vehicle.position) > 10) {
              newRoutes[key]!.add(vehicle.position);
            }
          } catch (e) {
            debugPrint('Error parsing vehicle $key: $e');
          }
        });

        if (mounted) {
          setState(() {
            vehicles = newVehicles;
            vehicleRoutes = newRoutes;
          });
        }
      } else {
        debugPrint('Failed to fetch vehicle locations: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching vehicle locations: $e');
    }
  }

  void _showMapStyleDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('اختر نمط الخريطة',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const Divider(height: 1),
              ..._mapStyles.map((style) {
                return ListTile(
                  leading: Icon(
                    style.icon,
                  ),
                  title: Text(style.name, textDirection: TextDirection.rtl),
                  onTap: () {
                    setState(() {
                      _selectedMapStyle = style;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  // New function to show route selection dialog
  void _showRouteSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تتبع مسار المركبة'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Vehicle selection dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedVehicleId,
                    decoration: const InputDecoration(
                      labelText: 'اختر المركبة',
                      border: OutlineInputBorder(),
                    ),
                    items: availableVehicles.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVehicleId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date selection
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? 'التاريخ: ${_selectedDate!.toLocal().toString().split(' ')[0]}'
                              : 'اختر التاريخ',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(dialogContext),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: _isFetchingRoute
                    ? null
                    : () {
                        Navigator.of(dialogContext).pop();
                        _fetchVehicleRoute();
                      },
                child: _isFetchingRoute
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('جلب المسار'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  List<Marker> _buildVehicleMarkers(List<String>? groups) {
    // Don't show vehicles in route mode
    if (_isRouteMode) return [];
    if (!_showVehicles) return [];
    if (!_hasVehiclePermission(groups)) return [];

    return vehicles.map((vehicle) {
      String arabicName = vehicle.name.split('-').last.trim();
      final destination = vehicle.position;

      return Marker(
        width: 100,
        height: 60,
        point: destination,
        child: InkWell(
          onTap: () => _showVehicleDialog(
            context: context,
            vehicleName: vehicle.name,
            speed: vehicle.speed,
            destination: destination,
            vehicleId: vehicle.id,
          ),
          child: VehicleMarkerWidget(
            arabicName: arabicName,
            speed: vehicle.speed,
            isValid: vehicle.isValid,
          ),
        ),
      );
    }).toList();
  }

  List<Marker> _buildCustomerMarkers(
      BuildContext context, List<String>? groups) {
    // Don't show customers in route mode
    if (_isRouteMode) return [];
    if (!_showCustomers) return [];
    if (!_hasCustomerPermission(groups)) return [];

    return customers
        .map((customer) {
          if (customer.shopCoordinates == null) return null;
          List<String> coords = customer.shopCoordinates!.split(',');
          if (coords.length != 2) return null;

          double? latitude = double.tryParse(coords[0]);
          double? longitude = double.tryParse(coords[1]);
          if (latitude == null || longitude == null) return null;
          final destination = LatLng(latitude, longitude);
          return Marker(
            width: 30,
            height: 30,
            point: destination,
            child: InkWell(
              onTap: () => _showLocationDialog(
                context: context,
                customerName: customer.customerName ?? '',
                shopName: customer.shopName ?? '',
                address: customer.address ?? '',
                destination: destination,
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

  // Build my location marker
  Marker? _buildMyLocationMarker() {
    // Don't show my location if disabled or not available
    if (!_showMyLocation || _currentLocation == null) return null;

    return Marker(
      width: 40,
      height: 40,
      point: _currentLocation!,
      child: const Icon(
        Icons.person_pin_circle,
        color: Colors.blue,
        size: 40,
      ),
    );
  }

  // Build route polylines
  List<Polyline> _buildRoutePolylines() {
    final polylines = <Polyline>[];

    // Add current route if available
    if (_currentRoute != null && _currentRoute!.points.length >= 2) {
      final routePoints = _currentRoute!.points.map((p) => p.position).toList();
      polylines.add(Polyline(
        points: routePoints,
        strokeWidth: 4.0,
        color: Colors.blue.withOpacity(0.8),
        borderStrokeWidth: 1.0,
        borderColor: Colors.white,
      ));
    }

    // Add stop markers
    if (_currentRoute != null && _currentRoute!.stops.isNotEmpty) {
      for (var stop in _currentRoute!.stops) {
        polylines.add(Polyline(
          points: [stop.position, stop.position],
          strokeWidth: 20.0,
          color: Colors.red.withOpacity(0.5),
        ));
      }
    }

    return polylines;
  }

  void _showLocationDialog({
    required BuildContext context,
    required String customerName,
    required String shopName,
    required String address,
    required LatLng destination,
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
              IconButton(
                icon: const Icon(Icons.directions, color: Colors.blue),
                tooltip: 'توجيه',
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _launchNavigation(destination);
                },
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
    required LatLng destination,
    required String vehicleId,
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
                if (_currentRoute != null &&
                    _currentRoute!.vehicleId == vehicleId) ...[
                  const SizedBox(height: 8),
                  _buildDialogRow('طول المسار:',
                      '${_currentRoute!.routeLength.toStringAsFixed(2)} كم'),
                  _buildDialogRow('أقصى سرعة:',
                      '${_currentRoute!.topSpeed.toStringAsFixed(0)} كم/ساعة'),
                  _buildDialogRow('متوسط السرعة:',
                      '${_currentRoute!.avgSpeed.toStringAsFixed(0)} كم/ساعة'),
                ],
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.directions, color: Colors.blue),
                tooltip: 'توجيه',
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _launchNavigation(destination);
                },
              ),
              IconButton(
                icon: const Icon(Icons.route, color: Colors.green),
                tooltip: 'تتبع المسار',
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  setState(() {
                    _selectedVehicleId = vehicleId;
                  });
                  _showRouteSelectionDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Row(
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

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppUserCubit>().state;
    final groups = state is AppUserLoggedIn ? state.userEntity.groups : null;

    final hasVehiclePermission = _hasVehiclePermission(groups);
    final hasCustomerPermission = _hasCustomerPermission(groups);

    // Start/stop vehicle location updates based on permission
    if (hasVehiclePermission &&
        _vehicleLocationTimer == null &&
        !_isRouteMode) {
      _fetchVehicleLocations();
      _vehicleLocationTimer =
          Timer.periodic(const Duration(seconds: 10), (timer) {
        _fetchVehicleLocations();
      });
    } else if ((!hasVehiclePermission || _isRouteMode) &&
        _vehicleLocationTimer != null) {
      _vehicleLocationTimer?.cancel();
      _vehicleLocationTimer = null;
      if (!_isRouteMode) {
        setState(() {
          vehicles.clear();
          vehicleRoutes.clear();
        });
      }
    }
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: AppBar(
                title: Text(_getAppBarTitle(groups)),
                backgroundColor: isDark
                    ? Colors.black.withOpacity(0.4)
                    : Colors.white.withOpacity(0.3),
                elevation: 0,
                // Add clear route button when in route mode
                actions: _isRouteMode
                    ? [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _clearRoute,
                          tooltip: 'مسح المسار والعودة للخريطة',
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
        body: hasCustomerPermission
            ? BlocProvider(
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
                        content: 'حدث خطأ ما في جلب العملاء',
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
                    if (state is SalesOpLoading && customers.isEmpty) {
                      return const Loader();
                    }
                    return _buildMapContent(
                        hasVehiclePermission, hasCustomerPermission, groups);
                  },
                ),
              )
            : _buildMapContent(
                hasVehiclePermission, hasCustomerPermission, groups),
      ),
    );
  }

  Widget _buildMapContent(bool hasVehiclePermission, bool hasCustomerPermission,
      List<String>? groups) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: LatLng(33.5130556, 36.2919444),
            initialZoom: 10,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
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
            // Route polylines
            PolylineLayer(
              polylines: _buildRoutePolylines(),
            ),
            // Live vehicle routes (only show in normal mode)
            PolylineLayer<Object>(
              polylines: _showVehicles && hasVehiclePermission && !_isRouteMode
                  ? vehicleRoutes.entries
                      .map((entry) {
                        if (entry.value.length < 2) return null;

                        return Polyline(
                          points: entry.value,
                          strokeWidth: 4.0,
                          color: Colors.green,
                        );
                      })
                      .whereType<Polyline>()
                      .toList()
                  : [],
            ),
            MarkerLayer(
              markers: [
                ..._buildCustomerMarkers(context, groups),
                ..._buildVehicleMarkers(groups),
                if (_buildMyLocationMarker() != null) _buildMyLocationMarker()!,
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Clear route button (visible only in route mode)
              if (_isRouteMode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FloatingActionButton(
                    heroTag: 'clear_route',
                    onPressed: _clearRoute,
                    backgroundColor: Colors.red.shade600,
                    mini: true,
                    tooltip: 'مسح المسار والعودة للخريطة',
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              // Route tracking button
              if (hasVehiclePermission && !_isRouteMode)
                if (hasVehiclePermission && !_isRouteMode)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FloatingActionButton(
                      heroTag: 'route_tracking',
                      onPressed: _isFetchingRoute
                          ? null
                          : () => _showRouteSelectionDialog(context),
                      backgroundColor: Colors.orange.shade600,
                      mini: true,
                      tooltip: 'تتبع مسار المركبة',
                      child: _isFetchingRoute
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(
                              Icons.route,
                              color: Colors.white,
                            ),
                    ),
                  ),
              // Map Style Button
              if (!_isRouteMode) // Hide in route mode to reduce clutter
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FloatingActionButton(
                    heroTag: 'map_style',
                    onPressed: () => _showMapStyleDialog(context),
                    backgroundColor: Colors.purple.shade600,
                    mini: true,
                    tooltip: 'تغيير نمط الخريطة',
                    child: Icon(
                      _selectedMapStyle.icon,
                      color: Colors.white,
                    ),
                  ),
                ),
              // Show/Hide My Location button
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FloatingActionButton(
                  heroTag: 'toggle_my_location',
                  onPressed: () {
                    setState(() {
                      _showMyLocation = !_showMyLocation;
                    });
                  },
                  backgroundColor: _showMyLocation
                      ? Colors.blue.shade600
                      : Colors.grey.shade600,
                  mini: true,
                  tooltip: _showMyLocation ? 'إخفاء موقعي' : 'إظهار موقعي',
                  child: Icon(
                    _showMyLocation
                        ? Icons.person_pin_circle
                        : Icons.person_pin_circle_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              // Center on my location button
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FloatingActionButton(
                  heroTag: 'my_location',
                  onPressed: _centerMapOnCurrentLocation,
                  backgroundColor: Colors.blue.shade600,
                  mini: true,
                  tooltip: 'الذهاب إلى موقعي',
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
              ),
              if (hasVehiclePermission && !_isRouteMode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FloatingActionButton(
                    heroTag: 'vehicle_toggle',
                    onPressed: () {
                      setState(() => _showVehicles = !_showVehicles);
                    },
                    backgroundColor:
                        _showVehicles ? Colors.green : Colors.grey.shade300,
                    mini: true,
                    tooltip: 'إخفاء / إظهار المركبات',
                    child: Icon(
                      FontAwesomeIcons.car,
                      color: _showVehicles ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              if (hasCustomerPermission && !_isRouteMode)
                FloatingActionButton(
                  heroTag: 'customer_toggle',
                  onPressed: () {
                    setState(() => _showCustomers = !_showCustomers);
                  },
                  backgroundColor:
                      _showCustomers ? Colors.red : Colors.grey.shade300,
                  mini: true,
                  tooltip: 'إخفاء / إظهار العملاء',
                  child: Icon(
                    Icons.location_on,
                    color: _showCustomers ? Colors.white : Colors.black,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
