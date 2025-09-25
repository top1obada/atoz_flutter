import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/LocationDTO/user_point_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:a_to_z_providers/Global/save_login_info.dart';
import 'package:a_to_z_providers/LocationProviders/get_current_location_provider.dart';
import 'package:a_to_z_providers/StaticLibraries/jwt_token_helper.dart';

import 'package:a_to_z_api_connect/Connections/Customer/customer_connect.dart';

class PVCustomerGoEmail extends PVBaseCurrentLoginInfo {
  String? errorMessageText;

  Future<bool> goEmail(String idToken, String accessToken) async {
    Errors.errorMessage = null;

    ClsUserPointDTO? userPointDTO =
        await PVCurrentLocation().getCurrentLocation();

    if (userPointDTO == null) {
      return false;
    }

    final result = await CustomerConnect.customerGoEmail(
      idToken,
      accessToken,
      userPointDTO,
    );

    return await result.fold(
      (left) async {
        Errors.errorMessage = left;
        notifyListeners();
        return false;
      },
      (tokens) async {
        retrivingLoggedInDTO = ClsJWTTokenHelper.extractLoginInfoFromToken(
          tokens.jwtToken,
        );

        await SaveLoginInfo.writeSaveLoginInfo(
          tokens.jwtToken!,
          tokens.refreshToken!,
        );

        DioClient.initOnRequest();

        notifyListeners();

        return true;
      },
    );
  }
}
