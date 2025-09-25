import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:dartz/dartz.dart';

class AdminInfoConnect {
  AdminInfoConnect._();

  static Future<Either<String?, String>> getAdminPhoneNumber(
    int adminID,
  ) async {
    try {
      // Validate required fields
      if (adminID <= 0) {
        return Left('Invalid Admin ID');
      }

      // Make the API call
      final result = await DioClient.dio.get(
        'AdminInfo/GetAdminPhoneNumber/$adminID',
      );

      // Handle different response status codes
      if (result.statusCode == 200) {
        // The API returns a simple string phone number
        final phoneNumber = result.data.toString();
        return Right(phoneNumber);
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
      } else if (result.statusCode == 404) {
        return Left('Admin phone number not found');
      } else if (result.statusCode == 500) {
        return Left('Server Error: ${result.data}');
      } else {
        return Left('Request failed with status: ${result.statusCode}');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
