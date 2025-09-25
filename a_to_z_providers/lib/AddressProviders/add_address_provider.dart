import 'package:a_to_z_api_connect/Connections/Address/address_connect.dart';
import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';

class PVAddAddress extends ChangeNotifier {
  int? addressID;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  Future<void> addAddress(ClsAddressDTO addressDTO) async {
    if (_isLoading) return;

    Errors.errorMessage = null;
    _isLoading = true;
    addressID = null;
    notifyListeners();

    final result = await AddressConnect.addAddress(addressDTO);

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
      },
      (right) {
        addressID = right;
      },
    );

    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
