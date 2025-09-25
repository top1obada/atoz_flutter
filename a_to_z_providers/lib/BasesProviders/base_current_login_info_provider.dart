import 'package:flutter/material.dart';
import 'package:a_to_z_dto/LoginDTO/retriving_login_dto.dart';

class PVBaseCurrentLoginInfo extends ChangeNotifier {
  ClsRetrivingLoggedInDTO? retrivingLoggedInDTO;

  void clear() {
    retrivingLoggedInDTO = null;
  }
}
