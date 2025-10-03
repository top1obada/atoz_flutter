import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  late GoogleMapController _mapController;
  late LatLng _currentPosition;
  late CameraPosition _initialCameraPosition;
  Marker? _marker;

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(widget.initialLatitude, widget.initialLongitude);
    _initialCameraPosition = CameraPosition(
      target: _currentPosition,
      zoom: 15.0,
    );
    _createMarker();
  }

  void _createMarker() {
    _marker = Marker(
      markerId: const MarkerId('location_point'),
      position: _currentPosition,
      draggable: widget.allowUpdate, // يمكن السحب فقط إذا كان التحديث مسموحاً
      infoWindow: InfoWindow(
        title: widget.markerTitle ?? 'الموقع',
        snippet:
            '${_currentPosition.latitude.toStringAsFixed(6)}, ${_currentPosition.longitude.toStringAsFixed(6)}',
      ),
      onDragEnd:
          widget.allowUpdate
              ? (newPosition) {
                setState(() {
                  _currentPosition = newPosition;
                  _createMarker();
                });
                widget.onLocationChanged?.call(newPosition);
              }
              : null,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        widget.allowUpdate
            ? BitmapDescriptor.hueBlue
            : BitmapDescriptor.hueOrange,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng position) {
    if (!widget.allowUpdate) return;

    setState(() {
      _currentPosition = position;
      _createMarker();
    });
    widget.onLocationChanged?.call(position);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialCameraPosition,
              markers: _marker != null ? {_marker!} : {},
              onTap: _onMapTap,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: widget.allowUpdate,
              compassEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: false,
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.allowUpdate
                              ? Icons.edit_location
                              : Icons.location_on,
                          color:
                              widget.allowUpdate ? Colors.blue : Colors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.allowUpdate ? 'تحديد الموقع' : 'عرض الموقع',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                widget.allowUpdate
                                    ? Colors.blue[800]
                                    : Colors.orange[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الإحداثيات: ${_currentPosition.latitude.toStringAsFixed(6)}, ${_currentPosition.longitude.toStringAsFixed(6)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                    ),
                    if (widget.allowUpdate) ...[
                      const SizedBox(height: 4),
                      Text(
                        'انقر على الخريطة أو اسحب العلامة لتغيير الموقع',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue[700],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
