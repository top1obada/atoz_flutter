import 'package:a_to_z_api_connect/Settings/dio_connect.dart';

class RefreshTokenConnect {
  RefreshTokenConnect._();

  static Future<bool> login() async {
    try {
      final result = await DioClient.dio.get('RefreshToken');

      if (result.statusCode == 200) {
        if (result.data != null) {
          DioClient.setAuthToken(result.data.toString());
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
