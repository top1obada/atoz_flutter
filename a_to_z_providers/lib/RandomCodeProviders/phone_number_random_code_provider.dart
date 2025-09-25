import 'package:a_to_z_dto/LoginDTO/retriving_login_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';
import 'package:a_to_z_api_connect/Connections/RandomCode/random_code_connect.dart';
import 'package:provider/provider.dart';

class PVPhoneNumberRandomCode extends ChangeNotifier {
  String? randomCode;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  Future<void> getPhoneNumberRandomCode(
    String phoneNumber,
    BuildContext context,
  ) async {
    if (_isLoading) return;

    _isLoading = true;

    Errors.errorMessage = null;

    randomCode = null;

    notifyListeners();

    final result = await RandomCodeConnect.getPhoneNumberRandomCode(
      phoneNumber,
    );

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
      },
      (right) {
        randomCode = right;
        context
            .read<PVBaseCurrentLoginInfo>()
            .retrivingLoggedInDTO!
            .verifyPhoneNumberMode = EnVerifyPhoneNumberMode.eVerifyProcess;
      },
    );

    notifyListeners();
  }
}
