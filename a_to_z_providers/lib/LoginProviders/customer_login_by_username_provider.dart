import 'package:a_to_z_api_connect/Connections/Customer/customer_connect.dart';
import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/LocationDTO/user_point_dto.dart';
import 'package:a_to_z_dto/LoginDTO/native_login_info_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:a_to_z_providers/Global/save_login_info.dart';
import 'package:a_to_z_providers/LocationProviders/get_current_location_provider.dart';
import 'package:a_to_z_providers/StaticLibraries/jwt_token_helper.dart';

class PVCustomerLoginByUsername extends PVBaseCurrentLoginInfo {
  Future<bool> login(ClsNativeLoginInfoDTO nativeLoginInfoDTO) async {
    Errors.errorMessage = null;

    ClsUserPointDTO? userPointDTO =
        await PVCurrentLocation().getCurrentLocation();

    if (userPointDTO == null) {
      return false;
    }

    final result = await CustomerConnect.customerLoginByUserName(
      nativeLoginInfoDTO,
      userPointDTO,
    );

    // Use fold with proper async handling
    return await result.fold(
      (left) async {
        Errors.errorMessage = left;
        notifyListeners();
        return false;
      },
      (right) async {
        retrivingLoggedInDTO = ClsJWTTokenHelper.extractLoginInfoFromToken(
          right.jwtToken!,
        );

        await SaveLoginInfo.writeSaveLoginInfo(
          right.jwtToken!,
          right.refreshToken!,
        );

        DioClient.initOnRequest();

        notifyListeners();

        return true;
      },
    );
  }
}
