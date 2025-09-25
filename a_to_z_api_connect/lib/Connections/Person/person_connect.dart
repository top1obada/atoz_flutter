import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:dartz/dartz.dart';
import 'package:a_to_z_dto/PersonDTO/person_info_dto.dart';

class PersonConnect {
  PersonConnect._();

  static Future<Either<String?, ClsPersonInfoDTO>> getPersonInfo(
    int personID,
  ) async {
    try {
      // Validate required fields
      if (personID <= 0) {
        return Left('Invalid Person ID');
      }

      // Make the API call
      final result = await DioClient.dio.get('Person/GetPersonInfo/$personID');

      // Handle different response status codes
      if (result.statusCode == 200) {
        if (result.data is Map<String, dynamic>) {
          final data = result.data as Map<String, dynamic>;
          final personInfo = ClsPersonInfoDTO.fromJson(data);
          return Right(personInfo);
        } else {
          return Left('Invalid response format: Expected person info data');
        }
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
      } else if (result.statusCode == 404) {
        return Left('Person not found');
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
