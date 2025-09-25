import 'package:a_to_z_api_connect/Connections/AminInfo/admin_info_connect.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';

class PVAdminInfoPhoneNumber extends ChangeNotifier {
  String? phoneNumber;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  Future<void> getAdminInfoPhoneNumber(int adminID) async {
    if (_isLoading) return;

    Errors.errorMessage = null;
    _isLoading = true;
    phoneNumber = null;
    notifyListeners();
    final result = await AdminInfoConnect.getAdminPhoneNumber(adminID);

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
      },
      (right) {
        phoneNumber = right;
      },
    );

    notifyListeners();
  }
}
