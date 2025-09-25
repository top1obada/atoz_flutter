import 'package:a_to_z_api_connect/Connections/Person/person_connect.dart';
import 'package:a_to_z_dto/PersonDTO/person_info_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';

class PVGetPersonInfo extends ChangeNotifier {
  ClsPersonInfoDTO? personInfo;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  bool _isLoaded = false;

  bool get isLoaded {
    return _isLoaded;
  }

  Future<void> getPersonInfo(int personID) async {
    if (_isLoading) return;

    Errors.errorMessage = null;
    _isLoading = true;
    _isLoaded = false;
    personInfo = null;
    notifyListeners();

    final result = await PersonConnect.getPersonInfo(personID);

    _isLoading = false;

    _isLoaded = true;

    result.fold(
      (left) {
        Errors.errorMessage = left;
      },
      (right) {
        personInfo = right;
      },
    );

    notifyListeners();
  }
}
