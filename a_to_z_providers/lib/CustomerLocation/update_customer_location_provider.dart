import 'package:a_to_z_api_connect/Connections/Location/CustomerLocation/customer_location_connect.dart';
import 'package:a_to_z_dto/LocationDTO/CustomerLocationDTO/customer_location_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';

class PvUpdateCustomerLocation extends ChangeNotifier {
  bool _isLoading = false;
  bool _isUpdated = false;

  bool get isLoading {
    return _isLoading;
  }

  bool get isUpdated {
    return _isUpdated;
  }

  Future<void> updateCustomerLocation(
    ClsCustomerLocationDTO customerLocationDTO,
  ) async {
    if (_isLoading) return;

    _isLoading = true;
    _isUpdated = false;
    Errors.errorMessage = null;

    notifyListeners();

    final result = await CustomerLocationConnect.updateCustomerLocation(
      customerLocationDTO,
    );

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        _isUpdated = false;
      },
      (right) {
        _isUpdated = right;
      },
    );

    notifyListeners();
  }
}
