import 'package:a_to_z_api_connect/Connections/StoreType/store_type_with_color_connect.dart';
import 'package:a_to_z_dto/StoreTypeDTO/store_type_with_color_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/widgets.dart';

class PVStoreTypesWithColors extends ChangeNotifier {
  List<ClsStoreTypeWithColorDto>? storeTypesWithColors;

  void clearStoreTypes() {
    _isLoaded = _isLoading = false;
    storeTypesWithColors = null;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getStoreTypesWithColors() async {
    Errors.errorMessage = null;

    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final result = await StoreTypeWithColorConnect.getStoreTypesWithColors();

    _isLoading = false;
    _isLoaded = true;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        notifyListeners();
        return;
      },
      (right) {
        storeTypesWithColors = right;

        notifyListeners();
        return;
      },
    );
  }
}
