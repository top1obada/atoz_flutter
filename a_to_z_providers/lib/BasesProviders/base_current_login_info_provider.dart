import 'package:flutter/material.dart';
import 'package:a_to_z_dto/LoginDTO/retriving_login_dto.dart';

import 'package:a_to_z_providers/BasesProviders/SecureStorage/secure_storage.dart';

class PVBaseCurrentLoginInfo extends ChangeNotifier {
  ClsRetrivingLoggedInDTO? retrivingLoggedInDTO;

  Future<void> clear() async {
    retrivingLoggedInDTO = null;
    await StorageService.clear();
  }
}
