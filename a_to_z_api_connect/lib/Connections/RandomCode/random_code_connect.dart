// random_code_connect.dart
import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:dartz/dartz.dart';

class RandomCodeConnect {
  RandomCodeConnect._();

  static Future<Either<String?, String>> getPhoneNumberRandomCode(
    String phoneNumber,
  ) async {
    try {
      // Validate required fields
      if (phoneNumber.isEmpty) {
        return Left('Phone number is required');
      }

      // Make the API call - the PersonID is automatically handled by the backend
      // from the JWT token in the Authorization header
      final result = await DioClient.dio.get(
        'RandomCode/PhoneNumberRandomCode/${Uri.encodeComponent(phoneNumber)}',
      );

      // Handle different response status codes
      if (result.statusCode == 200) {
        // The API returns a simple string random code directly
        final randomCode = result.data.toString();
        return Right(randomCode);
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
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
