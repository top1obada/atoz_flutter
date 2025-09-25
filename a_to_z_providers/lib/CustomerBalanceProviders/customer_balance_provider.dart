import 'package:a_to_z_api_connect/Connections/CustomerBalance/customer_balance_connect.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';

class PVCustomerBalance extends ChangeNotifier {
  double? customerBalance;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  Future<void> getCustomerBalance(int? customerID) async {
    if (_isLoading || customerID == null) return;
    Errors.errorMessage = null;
    customerBalance = null;
    _isLoading = true;

    notifyListeners();

    final result = await CustomerBalanceConnection.getCustomerBalance(
      customerID,
    );

    result.fold(
      (left) {
        Errors.errorMessage = left;
      },
      (right) {
        customerBalance = right;
      },
    );

    _isLoading = false;

    notifyListeners();
  }
}
