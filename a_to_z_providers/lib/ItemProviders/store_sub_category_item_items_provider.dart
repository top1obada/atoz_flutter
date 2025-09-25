import 'package:a_to_z_api_connect/Connections/Item/item_connect.dart';
import 'package:a_to_z_dto/FilterDTO/store_sub_category_item_items_filter_dto.dart';
import 'package:a_to_z_dto/ItemDTO/store_sub_category_item_item_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/widgets.dart';

class PVStoreSubCategoryItemItems extends ChangeNotifier {
  List<ClsStoreSubCategoryItemItemDTO>? storeSubCategoryItemItems;

  void initToLoad() {
    _isFinished = false;
  }

  void clearSubCategoryItemItems() {
    _isFinished = _isLoaded = _isLoading = false;
    storeSubCategoryItemItems = null;
    _pageNumber = 0;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFinished = false;
  bool get isFinished => _isFinished;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _pageNumber = 0;

  Future<void> getStoreSubCategoryItemItems(
    ClsStoreSubCategoryItemItemsFilterDTO storeSubCategoryItemItemsFilterDTO,
  ) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;
    if (storeSubCategoryItemItems == null) {
      _pageNumber = 1;
    } else {
      _pageNumber =
          (storeSubCategoryItemItems!
                      .where(
                        (c) =>
                            c.subCategoryItemID ==
                            storeSubCategoryItemItemsFilterDTO
                                .subCategoryItemID,
                      )
                      .length /
                  storeSubCategoryItemItemsFilterDTO.pageSize!)
              .ceil();
      if (_pageNumber == 0) _pageNumber = 1;
    }

    storeSubCategoryItemItemsFilterDTO.pageNumber = _pageNumber;

    _isLoading = true;
    notifyListeners();

    final result =
        await StoreSubCategoryItemItemConnect.getStoreSubCategoryItemItems(
          storeSubCategoryItemItemsFilterDTO,
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
        if (storeSubCategoryItemItems != null) {
          _isFinished =
              right.length < storeSubCategoryItemItemsFilterDTO.pageSize!;
          int i = 0;
          for (i; i < right.length; i++) {
            if (!storeSubCategoryItemItems!.any(
              (c) => c.storeItemID == right[i].storeItemID,
            )) {
              storeSubCategoryItemItems!.add(right[i]);
            }
          }

          notifyListeners();
          return;
        }

        storeSubCategoryItemItems = right;

        if (storeSubCategoryItemItems != null) {
          _isFinished =
              storeSubCategoryItemItems!.length <
              storeSubCategoryItemItemsFilterDTO.pageSize!;
        }

        notifyListeners();
        return;
      },
    );
  }

  void decreaseCountOneItem(
    ClsStoreSubCategoryItemItemDTO storeSubCategoryItemItemDTOC,
  ) {
    if (storeSubCategoryItemItems == null ||
        storeSubCategoryItemItems!.isEmpty) {
      return;
    }
    bool isUpdated = false;

    ClsStoreSubCategoryItemItemDTO storeSubCategoryItemItemDTO =
        storeSubCategoryItemItems!.firstWhere(
          (c) => c.storeItemID == storeSubCategoryItemItemDTOC.storeItemID,
          orElse: () => ClsStoreSubCategoryItemItemDTO(storeItemID: -1),
        );

    if (storeSubCategoryItemItemDTO.storeItemID != -1) {
      storeSubCategoryItemItemDTO.count =
          storeSubCategoryItemItemDTO.count! -
          storeSubCategoryItemItemDTOC.count!;
      isUpdated = true;
    }

    if (isUpdated) notifyListeners();
  }

  void increaseCountOneItem(
    ClsStoreSubCategoryItemItemDTO storeSubCategoryItemItemDTOC,
  ) {
    if (storeSubCategoryItemItems == null ||
        storeSubCategoryItemItems!.isEmpty) {
      return;
    }
    bool isUpdated = false;

    ClsStoreSubCategoryItemItemDTO storeSubCategoryItemItemDTO =
        storeSubCategoryItemItems!.firstWhere(
          (c) => c.storeItemID == storeSubCategoryItemItemDTOC.storeItemID,
          orElse: () => ClsStoreSubCategoryItemItemDTO(storeItemID: -1),
        );

    if (storeSubCategoryItemItemDTO.storeItemID != -1) {
      storeSubCategoryItemItemDTO.count =
          storeSubCategoryItemItemDTO.count! +
          storeSubCategoryItemItemDTOC.count!;
      isUpdated = true;
    }

    if (isUpdated) notifyListeners();
  }
}
