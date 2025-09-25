import 'package:a_to_z_api_connect/Connections/ContactInformation/contact_information_connect.dart';
import 'package:a_to_z_dto/ContactInformationDTO/contact_information_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';

class PVGetPersonContactInfo extends ChangeNotifier {
  ClsContactInformationDTO? contactInfo;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  bool _isLoaded = false;

  bool get isLoaded {
    return _isLoaded;
  }

  Future<void> getPersonContactInfo(int personID) async {
    if (_isLoading) return;

    Errors.errorMessage = null;
    _isLoading = true;
    contactInfo = null;
    _isLoaded = false;
    notifyListeners();

    final result = await ContactInformationConnect.getPersonContactInformations(
      personID,
    );

    _isLoading = false;

    _isLoaded = true;

    result.fold(
      (left) {
        Errors.errorMessage = left;
      },
      (right) {
        contactInfo = right;
      },
    );

    notifyListeners();
  }
}
