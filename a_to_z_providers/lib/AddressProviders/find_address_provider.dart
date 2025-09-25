import 'package:a_to_z_api_connect/Connections/Address/address_connect.dart';
import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';

class PVFindAddress extends ChangeNotifier {
  ClsAddressDTO? address;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  bool _isLoaded = false;

  bool get isLoaded {
    return _isLoaded;
  }

  Future<void> findAddress(int addressID) async {
    if (_isLoading) return;

    Errors.errorMessage = null;
    _isLoading = true;
    address = null;
    _isLoaded = false;
    notifyListeners();

    final result = await AddressConnect.findAddress(addressID);

    _isLoading = false;

    _isLoaded = true;

    result.fold(
      (left) {
        Errors.errorMessage = left;
      },
      (right) {
        address = right;
      },
    );

    notifyListeners();
  }
}
