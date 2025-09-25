import 'package:a_to_z_api_connect/Connections/CustomerBalance/customer_balance_connect.dart';
import 'package:a_to_z_dto/CustomerBalanceDTO/customer_balance_payment_history_dto.dart';
import 'package:a_to_z_dto/CustomerBalanceDTO/customer_balance_payments_history_and_customer_balance_dto.dart';
import 'package:a_to_z_dto/FilterDTO/customer_balance_payments_history_filter_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/widgets.dart';

class PVCustomerBalancePaymentsHistoryAndCustomerBalance
    extends ChangeNotifier {
  ClsCustomerBalancePaymentsHistoryAndCustomerBalanceDTO? customerBalanceData;
  List<ClsCustomerBalancePaymentHistoryDTO>? get paymentHistory =>
      customerBalanceData?.customerBalancePaymentHistoryDTOs;
  double? get customerBalance => customerBalanceData?.customerBalance;

  void clearBalanceData() {
    _isFinished = _isLoaded = _isLoading = false;
    customerBalanceData = null;
    _pageNumber = 0;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFinished = false;
  bool get isFinished => _isFinished;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _pageNumber = 0;

  Future<void> getCustomerBalancePaymentsHistory(
    ClsCustomerBalancePaymentsHistoryFilterDTO balanceFilterDTO,
  ) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;

    _pageNumber++;
    balanceFilterDTO.pageNumber = _pageNumber;

    _isLoading = true;
    notifyListeners();

    final result =
        await CustomerBalanceConnection.getCustomerBalancePaymentsHistoryAndBalance(
          balanceFilterDTO,
        );

    _isLoading = false;
    _isLoaded = true;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        notifyListeners();
        return;
      },
      (right) {
        if (customerBalanceData != null &&
            right.customerBalancePaymentHistoryDTOs != null) {
          // Append new payment history items to existing list
          customerBalanceData!.customerBalancePaymentHistoryDTOs!.addAll(
            right.customerBalancePaymentHistoryDTOs!,
          );

          // Update finished state based on pagination
          _isFinished =
              right.customerBalancePaymentHistoryDTOs!.length <
              balanceFilterDTO.pageSize!;

          // Always update the customer balance with the latest value
          customerBalanceData!.customerBalance = right.customerBalance;
        } else {
          // First load - set the entire data object
          customerBalanceData = right;

          if (customerBalanceData != null &&
              customerBalanceData!.customerBalancePaymentHistoryDTOs != null) {
            _isFinished =
                customerBalanceData!.customerBalancePaymentHistoryDTOs!.length <
                balanceFilterDTO.pageSize!;
          }
        }

        notifyListeners();
        return;
      },
    );
  }
}
