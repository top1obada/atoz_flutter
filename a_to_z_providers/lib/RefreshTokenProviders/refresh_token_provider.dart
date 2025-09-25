import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_api_connect/Settings/refresh_token_connect.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/BasesProviders/SecureStorage/secure_storage.dart';
import 'package:a_to_z_providers/StaticLibraries/jwt_token_helper.dart';

class PVRefreshToken extends PVBaseCurrentLoginInfo {
  Future<bool> login() async {
    final tokens = await StorageService.read();

    if (tokens == null) return false;

    DioClient.setRefreshToken(tokens['refreshToken']!);

    final result = await RefreshTokenConnect.login();

    if (result) {
      String jWTToken = DioClient.dio.options.headers['Authorization'];

      retrivingLoggedInDTO = ClsJWTTokenHelper.extractLoginInfoFromToken(
        jWTToken,
      );

      await StorageService.save(jWTToken, tokens['refreshToken']!);

      DioClient.initOnRequest();

      return true;
    } else {
      await StorageService.clear();

      DioClient.clearHeaders();

      return false;
    }
  }
}
