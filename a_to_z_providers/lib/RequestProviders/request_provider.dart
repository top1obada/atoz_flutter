import 'package:a_to_z_api_connect/Connections/Request/request_connect.dart';
import 'package:a_to_z_dto/ItemDTO/store_sub_category_item_item_dto.dart';
import 'package:a_to_z_dto/RequestDTO/RequestItem/request_item_dto.dart';
import 'package:a_to_z_dto/RequestDTO/RequestTotalPayment/request_total_payment_dto.dart';
import 'package:a_to_z_dto/RequestDTO/completed_request_dto.dart';
import 'package:a_to_z_dto/RequestDTO/request_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';

class PVRequest extends ChangeNotifier {
  ClsCompletedRequestDto? completedRequestDto;
  PVRequest() {
    completedRequestDto = ClsCompletedRequestDto(
      requestDTO: ClsRequestDto(),
      requestTotalPaymentDTO: ClsRequestTotalPaymentDto(),
      requestItems: [],
    );
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  int? _requestID;

  int? get requestID {
    return _requestID;
  }

  bool _isLoaded = false;

  bool get isLoaded {
    return _isLoaded;
  }

  ClsRequestItemDto _convertToRequestItemDTO(
    ClsStoreSubCategoryItemItemDTO storeSubCategoryItemItemDTO,
  ) {
    return ClsRequestItemDto(
      storeItemID: storeSubCategoryItemItemDTO.storeItemID,
      count: storeSubCategoryItemItemDTO.count,
    );
  }

  void putItems(List<ClsStoreSubCategoryItemItemDTO> items) {
    completedRequestDto!.requestItems = [];
    for (int i = 0; i < items.length; i++) {
      completedRequestDto!.requestItems!.add(
        _convertToRequestItemDTO(items[i]),
      );
    }
  }

  Future<void> request() async {
    if (_isLoading) return;

    Errors.errorMessage = null;

    completedRequestDto!.requestDTO!.completedDate = DateTime.now();
    completedRequestDto!.requestDTO!.requestStatus = EnRequestStatus.ePending;
    _isLoading = true;
    notifyListeners();

    final result = await RequestConnect.insertCompletedRequest(
      completedRequestDto!,
    );
    _isLoaded = true;
    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
      },
      (right) {
        _requestID =
            completedRequestDto!.requestDTO!.requestID =
                completedRequestDto!.requestTotalPaymentDTO!.requestID = right;

        for (int i = 0; i < completedRequestDto!.requestItems!.length; i++) {
          completedRequestDto!.requestItems![i].requestID = right;
        }
      },
    );
    notifyListeners();
  }
}
