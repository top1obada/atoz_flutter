import 'package:a_to_z_api_connect/Connections/Store/store_connection.dart';
import 'package:a_to_z_dto/FilterDTO/customer_store_filter_dto.dart';
import 'package:a_to_z_dto/StoreDTO/customer_store_suggestion_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/widgets.dart';

class PVCustomerStoresSuggestions extends ChangeNotifier {
  List<ClsCustomerStoreSuggestionDTO>? customerStoresSuggestions;

  void clearStores() {
    _isFinished = _isLoaded = _isLoading = false;
    customerStoresSuggestions = null;
    _pageNumber = 0;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  bool _isFinished = false;

  bool get isFinished {
    return _isFinished;
  }

  bool _isLoaded = false;

  bool get isLoaded {
    return _isLoaded;
  }

  int _pageNumber = 0;

  Future<void> getCustomerStoreSuggestion(
    ClsCustomerStoresFilterDTO customerStoreFilterDTO,
  ) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;

    _pageNumber++;

    customerStoreFilterDTO.pageNumber = _pageNumber;

    _isLoading = true;
    notifyListeners();
    final result = await StoreConnection.getCustomerStoreSuggestions(
      customerStoreFilterDTO,
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
        if (customerStoresSuggestions != null) {
          _isFinished = right.length < customerStoreFilterDTO.pageSize!;
          customerStoresSuggestions!.addAll(right);
          notifyListeners();
          return;
        }

        customerStoresSuggestions = right;

        if (customerStoresSuggestions != null) {
          _isFinished =
              customerStoresSuggestions!.length <
              customerStoreFilterDTO.pageSize!;
        }

        notifyListeners();
        return;
      },
    );
  }
}
