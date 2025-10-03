import 'package:a_to_z_api_connect/Connections/Location/CustomerLocation/customer_location_connect.dart';
import 'package:a_to_z_dto/LocationDTO/CustomerLocationDTO/customer_location_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';

class PvGetCustomerLocation extends ChangeNotifier {
  bool _isLoading = false;
  ClsCustomerLocationDTO? _customerLocation;
  bool? _isFound;

  bool get isLoading {
    return _isLoading;
  }

  ClsCustomerLocationDTO? get customerLocation {
    return _customerLocation;
  }

  bool? get isFound {
    return _isFound;
  }

  Future<void> getCustomerLocation(int customerID) async {
    if (_isLoading) return;

    _isLoading = true;
    _customerLocation = null;
    _isFound = false;
    Errors.errorMessage = null;

    notifyListeners();

    final result = await CustomerLocationConnect.getCustomerLocation(
      customerID,
    );

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        _customerLocation = null;
        _isFound = false;
      },
      (right) {
        _customerLocation = right;
        _isFound = right != null;
      },
    );

    notifyListeners();
  }

  void clearCustomerLocation() {
    _customerLocation = null;
    _isFound = false;
    Errors.errorMessage = null;
    notifyListeners();
  }
}
