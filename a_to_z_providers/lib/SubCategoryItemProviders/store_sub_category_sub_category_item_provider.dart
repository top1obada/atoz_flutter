import 'package:a_to_z_api_connect/Connections/SubCategoryItem/sub_category_item_connect.dart';
import 'package:a_to_z_dto/FilterDTO/store_sub_category_sub_category_items_dto.dart';
import 'package:a_to_z_dto/SubCategoryItemDTO/sub_category_item_dto.dart';

import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/widgets.dart';

class PVStoreSubCategorySubCategoryItems extends ChangeNotifier {
  List<ClsSubCategoryItem>? storeSubCategoryItems;

  void initToLoad() {
    _isFinished = false;
  }

  void clearSubCategoryItems() {
    _isFinished = _isLoaded = _isLoading = false;
    storeSubCategoryItems = null;
    _pageNumber = 0;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFinished = false;
  bool get isFinished => _isFinished;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _pageNumber = 0;

  Future<void> getStoreSubCategorySubCategoryItems(
    ClsStoreSubCategorySubCategoryItemsFilterDTO
    storeSubCategorySubCategoryItemsFilterDTO,
  ) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;

    if (storeSubCategoryItems == null) {
      _pageNumber = 1;
    } else {
      _pageNumber =
          (storeSubCategoryItems!
                      .where(
                        (c) =>
                            c.subCategoryID ==
                            storeSubCategorySubCategoryItemsFilterDTO
                                .subCategoryID,
                      )
                      .length /
                  storeSubCategorySubCategoryItemsFilterDTO.pageSize!)
              .ceil();
      if (_pageNumber == 0) _pageNumber = 1;
    }

    storeSubCategorySubCategoryItemsFilterDTO.pageNumber = _pageNumber;

    _isLoading = true;
    notifyListeners();

    final result =
        await SubCategoryItemConnect.getStoreSubCategorySubCategoryItems(
          storeSubCategorySubCategoryItemsFilterDTO,
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
        if (storeSubCategoryItems != null) {
          _isFinished =
              right.length <
              storeSubCategorySubCategoryItemsFilterDTO.pageSize!;
          int i = 0;
          for (i; i < right.length; i++) {
            if (!storeSubCategoryItems!.any(
              (c) => c.subCategoryID == right[i].subCategoryID,
            )) {
              storeSubCategoryItems!.add(right[i]);
            }
          }

          notifyListeners();
          return;
        }

        storeSubCategoryItems = right;

        if (storeSubCategoryItems != null) {
          _isFinished =
              storeSubCategoryItems!.length <
              storeSubCategorySubCategoryItemsFilterDTO.pageSize!;
        }

        notifyListeners();
        return;
      },
    );
  }
}
