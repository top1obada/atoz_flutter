import 'dart:convert';
import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:dartz/dartz.dart';

class AddressConnect {
  AddressConnect._();

  static Future<Either<String?, int>> addAddress(
    ClsAddressDTO addressDTO,
  ) async {
    try {
      // Validate required fields
      if (addressDTO.city == null || addressDTO.city!.isEmpty) {
        return Left('City is required');
      }

      // Convert the DTO to JSON string
      final addressJson = jsonEncode(addressDTO.toJson());

      // Make the API call
      final result = await DioClient.dio.post('Address', data: addressJson);

      // Handle different response status codes
      if (result.statusCode == 200) {
        if (result.data is int) {
          final addressID = result.data as int;
          return Right(addressID);
        } else {
          return Left('Invalid response format: Expected integer address ID');
        }
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

  static Future<Either<String?, bool>> updateAddress(
    ClsAddressDTO addressDTO,
  ) async {
    try {
      // Validate required fields
      if (addressDTO.addressID == null || addressDTO.addressID! <= 0) {
        return Left('Valid Address ID is required');
      }

      if (addressDTO.city == null || addressDTO.city!.isEmpty) {
        return Left('City is required');
      }

      // Convert the DTO to JSON string
      final addressJson = jsonEncode(addressDTO.toJson());

      // Make the API call
      final result = await DioClient.dio.put('Address', data: addressJson);

      // Handle different response status codes
      if (result.statusCode == 200) {
        if (result.data is bool) {
          final isUpdated = result.data as bool;
          return Right(isUpdated);
        } else {
          return Left('Invalid response format: Expected boolean');
        }
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
      } else if (result.statusCode == 404) {
        return Left('Address not found');
      } else if (result.statusCode == 500) {
        return Left('Server Error: ${result.data}');
      } else {
        return Left('Request failed with status: ${result.statusCode}');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String?, ClsAddressDTO>> findAddress(
    int personID,
  ) async {
    try {
      // Validate required fields
      if (personID <= 0) {
        return Left('Invalid person ID');
      }

      // Make the API call
      final result = await DioClient.dio.get('Address/FindAddress/$personID');

      // Handle different response status codes
      if (result.statusCode == 200) {
        if (result.data is Map<String, dynamic>) {
          final data = result.data as Map<String, dynamic>;
          final address = ClsAddressDTO.fromJson(data);
          return Right(address);
        } else {
          return Left('Invalid response format: Expected address data');
        }
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
      } else if (result.statusCode == 404) {
        return Left('Address not found');
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
