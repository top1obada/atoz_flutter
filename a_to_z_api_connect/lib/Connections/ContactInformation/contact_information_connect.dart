import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/ContactInformationDTO/contact_information_dto.dart';
import 'package:dartz/dartz.dart';

class ContactInformationConnect {
  ContactInformationConnect._();

  static Future<Either<String?, ClsContactInformationDTO>>
  getPersonContactInformations(int personID) async {
    try {
      // Validate required fields
      if (personID <= 0) {
        return Left('Invalid Person ID');
      }

      // Make the API call
      final result = await DioClient.dio.get(
        'ContactInformation/GetPersonContactInformation/$personID',
      );

      // Handle different response status codes
      if (result.statusCode == 200) {
        if (result.data is Map<String, dynamic>) {
          final data = result.data as Map<String, dynamic>;
          final contactInfo = ClsContactInformationDTO.fromJson(data);
          return Right(contactInfo);
        } else {
          return Left('Invalid response format: Expected contact info data');
        }
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
      } else if (result.statusCode == 404) {
        return Left('Person contact information not found');
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
