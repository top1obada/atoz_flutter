import 'package:a_to_z_api_connect/Connections/SubCategory/sub_category_connect.dart';
import 'package:a_to_z_dto/FilterDTO/store_category_sub_categories_dto.dart';
import 'package:a_to_z_dto/SubCategoryDTO/sub_category_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/widgets.dart';

class PVStoreCategorySubCategories extends ChangeNotifier {
  List<ClsSubCategoryDTO>? storeSubCategories;

  void initToLoad() {
    _isFinished = false;
  }

  void clearSubCategories() {
    _isFinished = _isLoaded = _isLoading = false;
    storeSubCategories = null;
    _pageNumber = 0;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFinished = false;
  bool get isFinished => _isFinished;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _pageNumber = 0;

  Future<void> getStoreCategorySubCategories(
    ClsStoreCategorySubCategoriesFilterDTO storeCategorySubCategoriesFilterDTO,
  ) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;

    if (storeSubCategories == null) {
      _pageNumber = 1;
    } else {
      _pageNumber =
          (storeSubCategories!
                      .where(
                        (c) =>
                            c.categoryID ==
                            storeCategorySubCategoriesFilterDTO.categoryID,
                      )
                      .length /
                  storeCategorySubCategoriesFilterDTO.pageSize!)
              .ceil();
      if (_pageNumber == 0) _pageNumber = 1;
    }

    storeCategorySubCategoriesFilterDTO.pageNumber = _pageNumber;

    _isLoading = true;
    notifyListeners();

    final result = await SubCategoryConnect.getStoreCategorySubCategories(
      storeCategorySubCategoriesFilterDTO,
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
        if (storeSubCategories != null) {
          _isFinished =
              right.length < storeCategorySubCategoriesFilterDTO.pageSize!;

          int i = 0;
          for (i; i < right.length; i++) {
            if (!storeSubCategories!.any(
              (c) => c.categoryID == right[i].categoryID,
            )) {
              storeSubCategories!.add(right[i]);
            }
          }
          notifyListeners();
          return;
        }

        storeSubCategories = right;

        if (storeSubCategories != null) {
          _isFinished =
              storeSubCategories!.length <
              storeCategorySubCategoriesFilterDTO.pageSize!;
        }

        notifyListeners();
        return;
      },
    );
  }
}
