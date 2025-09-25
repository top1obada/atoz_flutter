import 'package:a_to_z_dto/ItemDTO/store_sub_category_item_item_dto.dart';
import 'package:flutter/widgets.dart';

class ClsRequestShow {
  String? storeName;
  List<ClsStoreSubCategoryItemItemDTO>? storeSubCategoryItemItems;
  double? balanceUsedVaue;
  int? storeID;
}

class PVShowRequest extends ChangeNotifier {
  ClsRequestShow? requestShow;

  PVShowRequest() {
    requestShow = ClsRequestShow();
  }

  int get itemsCount {
    return requestShow == null
        ? 0
        : requestShow!.storeSubCategoryItemItems == null
        ? 0
        : requestShow!.storeSubCategoryItemItems!.length;
  }

  double totalDue = 0;

  double discount = 0;

  void addItem(ClsStoreSubCategoryItemItemDTO storeSubCategoryItemItemDTO) {
    if (requestShow == null) return;

    if (requestShow!.storeSubCategoryItemItems == null) {
      requestShow!.storeSubCategoryItemItems = [];
    }

    ClsStoreSubCategoryItemItemDTO? currentStoreSubCategoryItemItemDTO =
        requestShow!.storeSubCategoryItemItems!.firstWhere((item) {
          return item.storeItemID == storeSubCategoryItemItemDTO.storeItemID;
        }, orElse: () => ClsStoreSubCategoryItemItemDTO(storeItemID: -1));

    if (currentStoreSubCategoryItemItemDTO.storeItemID != -1) {
      int sum = currentStoreSubCategoryItemItemDTO.count!;
      sum = sum + storeSubCategoryItemItemDTO.count!;
      currentStoreSubCategoryItemItemDTO.count = sum;
    } else {
      requestShow!.storeSubCategoryItemItems!.add(storeSubCategoryItemItemDTO);
    }

    totalDue +=
        storeSubCategoryItemItemDTO.count! * storeSubCategoryItemItemDTO.price!;

    if (storeSubCategoryItemItemDTO.priceAfterDiscount != null) {
      discount +=
          storeSubCategoryItemItemDTO.count! *
          (storeSubCategoryItemItemDTO.price! -
              storeSubCategoryItemItemDTO.priceAfterDiscount!);
    }
    notifyListeners();
  }

  void removeItem(ClsStoreSubCategoryItemItemDTO storeSubCategoryItemItemDTO) {
    if (requestShow == null) return;

    if (requestShow!.storeSubCategoryItemItems == null) return;

    ClsStoreSubCategoryItemItemDTO? currentStoreSubCategoryItemItemDTO =
        requestShow!.storeSubCategoryItemItems!.firstWhere((item) {
          return item.storeItemID == storeSubCategoryItemItemDTO.storeItemID;
        }, orElse: () => ClsStoreSubCategoryItemItemDTO(storeItemID: -1));

    if (currentStoreSubCategoryItemItemDTO.storeItemID == -1) return;

    if (currentStoreSubCategoryItemItemDTO.count! >
        storeSubCategoryItemItemDTO.count!) {
      currentStoreSubCategoryItemItemDTO.count =
          currentStoreSubCategoryItemItemDTO.count! -
          storeSubCategoryItemItemDTO.count!;

      totalDue -=
          storeSubCategoryItemItemDTO.count! *
          storeSubCategoryItemItemDTO.price!;
      if (storeSubCategoryItemItemDTO.priceAfterDiscount != null) {
        discount -=
            storeSubCategoryItemItemDTO.count! *
            (storeSubCategoryItemItemDTO.price! -
                storeSubCategoryItemItemDTO.priceAfterDiscount!);
      }
    } else {
      requestShow!.storeSubCategoryItemItems!.remove(
        currentStoreSubCategoryItemItemDTO,
      );
      totalDue -=
          currentStoreSubCategoryItemItemDTO.count! *
          currentStoreSubCategoryItemItemDTO.price!;

      if (currentStoreSubCategoryItemItemDTO.priceAfterDiscount != null) {
        discount -=
            currentStoreSubCategoryItemItemDTO.count! *
            (currentStoreSubCategoryItemItemDTO.price! -
                currentStoreSubCategoryItemItemDTO.priceAfterDiscount!);
      }
    }

    notifyListeners();

    return;
  }

  void clearRequest() {
    requestShow!.storeName = null;
    requestShow!.storeSubCategoryItemItems = null;
    requestShow!.storeID = null;
    requestShow!.balanceUsedVaue = null;
    totalDue = discount = 0;
    notifyListeners();
  }

  void changeBalanceUsedValue(double balanceUsedValue) {
    if (requestShow == null) return;

    requestShow!.balanceUsedVaue = balanceUsedValue;

    notifyListeners();
  }
}
