import 'package:a_to_z_dto/LocationDTO/user_point_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class PVCurrentLocation extends ChangeNotifier {
  Future<ClsUserPointDTO?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Errors.errorMessage = 'خدمة تحديد الموقع مطفأة';
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Errors.errorMessage = 'تم رفض الإذن للوصول إلى الموقع';
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Errors.errorMessage = 'صلاحيات الموقع مرفوضة نهائياً';
      return null;
    }

    final result = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    return ClsUserPointDTO(
      latitude: result.latitude,
      longitude: result.longitude,
    );
  }
}
