import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_api_connect/Settings/refresh_token_connect.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/Global/save_login_info.dart';

class PVRefreshToken extends PVBaseCurrentLoginInfo {
  Future<bool> login() async {
    final tokens = await SaveLoginInfo.readReadLoginInfo();

    if (tokens == null) return false;

    DioClient.setRefreshToken(tokens.refreshToken!);

    final result = await RefreshTokenConnect.login();

    if (result) {
      await SaveLoginInfo.writeSaveLoginInfo(
        DioClient.dio.options.headers['Authorization'],
        tokens.refreshToken!,
      );

      DioClient.initOnRequest();

      return true;
    } else {
      await SaveLoginInfo.clearLoginInfo();

      DioClient.clearHeaders();

      return false;
    }
  }
}
