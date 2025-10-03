import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationShow extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final ValueChanged<LatLng>? onLocationChanged;
  final String? markerTitle;
  final bool allowUpdate;

  const LocationShow({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    this.onLocationChanged,
    this.markerTitle,
    this.allowUpdate = false,
  });

  @override
  State<LocationShow> createState() => _LocationShowState();
}

class _LocationShowState extends State<LocationShow> {
  late MapController _mapController;
  late LatLng _currentPosition;
  late List<Marker> _markers;
  int _currentTileLayer = 0;
  bool _isGettingLocation = false;

  // قائمة بخوادم الخرائط البديلة
  final List<Map<String, String>> _tileLayers = [
    {
      'name': 'OSM Hot',
      'url': 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
      'attribution': '© OpenStreetMap contributors',
    },
    {
      'name': 'OSM DE',
      'url': 'https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png',
      'attribution': '© OpenStreetMap contributors',
    },
    {
      'name': 'CartoDB',
      'url':
          'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
      'attribution': '© OpenStreetMap, © CartoDB',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(widget.initialLatitude, widget.initialLongitude);
    _mapController = MapController();
    _createMarker();
  }

  void _createMarker() {
    _markers = [
      Marker(
        width: 60.0,
        height: 60.0,
        point: _currentPosition,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  widget.allowUpdate
                      ? [Colors.blue.shade400, Colors.blue.shade600]
                      : [Colors.orange.shade400, Colors.orange.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.white, width: 3.0),
          ),
          child: Icon(
            widget.allowUpdate ? Icons.edit_location_alt : Icons.location_pin,
            color: Colors.white,
            size: 28.0,
          ),
        ),
      ),
    ];
  }

  void _onMapTap(TapPosition tapPosition, LatLng position) {
    if (!widget.allowUpdate) return;

    setState(() {
      _currentPosition = position;
      _createMarker();
    });
    widget.onLocationChanged?.call(position);
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_currentPosition, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_currentPosition, currentZoom - 1);
  }

  void _resetToCurrent() {
    _mapController.move(_currentPosition, 15.0);
  }

  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) return;

    setState(() {
      _isGettingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('خدمة تحديد الموقع مطفأة');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('تم رفض الإذن للوصول إلى الموقع');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('صلاحيات الموقع مرفوضة نهائياً');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final newPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = newPosition;
        _createMarker();
      });

      _mapController.move(newPosition, 15.0);
      widget.onLocationChanged?.call(newPosition);
    } catch (e) {
      _showSnackBar('خطأ في الحصول على الموقع: $e');
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _switchTileLayer() {
    setState(() {
      _currentTileLayer = (_currentTileLayer + 1) % _tileLayers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLayer = _tileLayers[_currentTileLayer];
    final theme = Theme.of(context);

    return Container(
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // الخريطة
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: 15.0,
                onTap: _onMapTap,
                interactionOptions: const InteractionOptions(
                  flags:
                      InteractiveFlag.drag |
                      InteractiveFlag.flingAnimation |
                      InteractiveFlag.pinchMove |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: currentLayer['url']!,
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: _markers),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _currentPosition,
                      color:
                          widget.allowUpdate
                              ? Colors.blue.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                      borderColor:
                          widget.allowUpdate
                              ? Colors.blue.shade300
                              : Colors.orange.shade300,
                      borderStrokeWidth: 2.0,
                      radius: 30,
                    ),
                  ],
                ),
              ],
            ),

            // طبقة تدرج علوية
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // شريط المعلومات المدمج (أصغر حجماً)
            Positioned(
              top: 8, // تقليل المسافة من الأعلى
              left: 8, // تقليل المسافة من الجوانب
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, // تقليل الحشو
                  vertical: 8, // تقليل الحشو
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12), // زوايا أصغر
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8, // ظل أخف
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // معلومات الموقع - مضغوط أكثر
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4), // أصغر
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors:
                                    widget.allowUpdate
                                        ? [
                                          Colors.blue.shade500,
                                          Colors.blue.shade700,
                                        ]
                                        : [
                                          Colors.orange.shade500,
                                          Colors.orange.shade700,
                                        ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.allowUpdate
                                  ? Icons.edit_location_alt
                                  : Icons.location_on,
                              color: Colors.white,
                              size: 14, // أيقونة أصغر
                            ),
                          ),
                          const SizedBox(width: 6), // مسافة أصغر
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.allowUpdate
                                      ? 'تحديد الموقع'
                                      : 'عرض الموقع',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    // خط أصغر
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  '${_currentPosition.latitude.toStringAsFixed(5)}, ${_currentPosition.longitude.toStringAsFixed(5)}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    // خط أصغر
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // زر تبديل الخرائط - أصغر
                    _buildSmallControlButton(
                      Icons.layers_outlined,
                      _switchTileLayer,
                      theme.colorScheme.primary,
                      Colors.white,
                      30, // حجم أصغر
                      14, // أيقونة أصغر
                    ),
                  ],
                ),
              ),
            ),

            // أزرار التحكم المدمجة (أصغر حجماً)
            Positioned(
              right: 8, // تقليل المسافة
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.all(6), // حشو أصغر
                decoration: BoxDecoration(
                  color: theme.cardColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12), // زوايا أصغر
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6, // ظل أخف
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSmallControlButton(
                      Icons.add,
                      _zoomIn,
                      theme.colorScheme.primary,
                      Colors.white,
                      32, // حجم أصغر
                      14, // أيقونة أصغر
                    ),
                    const SizedBox(height: 4), // مسافة أصغر
                    _buildSmallControlButton(
                      Icons.remove,
                      _zoomOut,
                      theme.colorScheme.surface,
                      theme.colorScheme.onSurface,
                      32,
                      14,
                    ),
                    const SizedBox(height: 4),
                    // زر الحصول على الموقع الحالي
                    _isGettingLocation
                        ? Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        )
                        : _buildSmallControlButton(
                          Icons.my_location,
                          _getCurrentLocation,
                          Colors.green,
                          Colors.white,
                          32,
                          14,
                        ),
                  ],
                ),
              ),
            ),

            // اسم الخريطة الحالية (أصغر)
            Positioned(
              bottom: 8, // تقليل المسافة
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8, // أصغر
                  vertical: 4, // أصغر
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(6), // زوايا أصغر
                ),
                child: Text(
                  currentLayer['name']!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 9, // خط أصغر
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallControlButton(
    IconData icon,
    VoidCallback onPressed,
    Color backgroundColor,
    Color iconColor,
    double size,
    double iconSize,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 2, // ظل أخف
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: iconSize),
        color: iconColor,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        splashRadius: 16, // أصغر
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
