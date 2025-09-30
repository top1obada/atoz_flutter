import 'package:a_to_z_providers/BasesProviders/SecureStorage/secure_storage.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:flutter/material.dart';
import 'package:a_to_z_api_connect/Connections/Session/session_connect.dart';

class PVDropSessionProvider extends ChangeNotifier {
  Future<bool> drop() async {
    Errors.errorMessage = null;

    final result = await SessionConnect.dropSession();

    return await result.fold(
      (left) {
        Errors.errorMessage = left;
        return false;
      },
      (right) async {
        await StorageService.clear();
        return right;
      },
    );
  }
}
