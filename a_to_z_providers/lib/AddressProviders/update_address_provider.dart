import 'package:a_to_z_api_connect/Connections/Address/address_connect.dart';
import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';

class PVUpdateAddress extends ChangeNotifier {
  bool _isUpdated = false;

  bool get isUpdated {
    return _isUpdated;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  Future<void> updateAddress(ClsAddressDTO addressDTO) async {
    if (_isLoading) return;

    Errors.errorMessage = null;
    _isLoading = true;
    _isUpdated = false;
    notifyListeners();

    final result = await AddressConnect.updateAddress(addressDTO);

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
      },
      (right) {
        _isUpdated = right;
      },
    );

    notifyListeners();
  }
}
