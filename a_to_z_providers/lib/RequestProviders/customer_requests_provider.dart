import 'package:a_to_z_api_connect/Connections/Request/request_connect.dart';
import 'package:a_to_z_dto/RequestDTO/customer_request_dto.dart';
import 'package:a_to_z_dto/FilterDTO/customer_requests_filter_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/widgets.dart';

class PVCustomerRequests extends ChangeNotifier {
  List<ClsCustomerRequestDto>? customerRequests;

  void clearRequests() {
    _isFinished = _isLoaded = _isLoading = false;
    customerRequests = null;
    _pageNumber = 0;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFinished = false;
  bool get isFinished => _isFinished;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _pageNumber = 0;

  Future<void> getCustomerRequests(
    ClsCustomerRequestsFilterDTO customerRequestsFilterDTO,
  ) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;

    _pageNumber++;

    customerRequestsFilterDTO.pageNumber = _pageNumber;

    _isLoading = true;
    notifyListeners();

    final result = await RequestConnect.getCustomerRequests(
      customerRequestsFilterDTO,
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
        if (customerRequests != null) {
          _isFinished = right.length < customerRequestsFilterDTO.pageSize!;
          customerRequests!.addAll(right);
          notifyListeners();
          return;
        }

        customerRequests = right;

        if (customerRequests != null) {
          _isFinished =
              customerRequests!.length < customerRequestsFilterDTO.pageSize!;
        }

        notifyListeners();
        return;
      },
    );
  }
}
