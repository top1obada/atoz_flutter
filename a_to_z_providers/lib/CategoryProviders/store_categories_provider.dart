import 'package:a_to_z_api_connect/Connections/Category/category_connect.dart';
import 'package:a_to_z_dto/CategoryDTO/category_dto.dart';
import 'package:a_to_z_dto/FilterDTO/store_categories_filter_dto.dart';

import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/widgets.dart';

class PVStoreCategories extends ChangeNotifier {
  List<ClsCategoryDto>? storeCategories;

  void clearCategories() {
    _isFinished = _isLoaded = _isLoading = false;
    storeCategories = null;
    _pageNumber = 0;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFinished = false;
  bool get isFinished => _isFinished;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _pageNumber = 0;

  Future<void> getStoreCategories(
    ClsStoreCategoriesFilterDTO storeCategoriesFilterDTO,
  ) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;

    _pageNumber++;

    storeCategoriesFilterDTO.pageNumber = _pageNumber;

    _isLoading = true;
    notifyListeners();

    final result = await CategoryConnect.getStoreCategories(
      storeCategoriesFilterDTO,
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
        if (storeCategories != null) {
          _isFinished = right.length < storeCategoriesFilterDTO.pageSize!;
          storeCategories!.addAll(right);
          notifyListeners();
          return;
        }

        storeCategories = right;

        if (storeCategories != null) {
          _isFinished =
              storeCategories!.length < storeCategoriesFilterDTO.pageSize!;
        }

        notifyListeners();
        return;
      },
    );
  }
}
