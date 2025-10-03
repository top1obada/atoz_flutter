import 'dart:convert';
import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/LocationDTO/CustomerLocationDTO/customer_location_dto.dart';
import 'package:dartz/dartz.dart';

class CustomerLocationConnect {
  CustomerLocationConnect._();

  static Future<Either<String?, ClsCustomerLocationDTO?>> getCustomerLocation(
    int customerID,
  ) async {
    try {
      final result = await DioClient.dio.get('CustomerLocation/$customerID');

      if (result.statusCode == 200) {
        final data = result.data;
        if (data != null) {
          final customerLocationDTO = ClsCustomerLocationDTO.fromJson(data);
          return Right(customerLocationDTO);
        } else {
          return const Right(null);
        }
      } else if (result.statusCode == 404) {
        return Left(
          result.data?.toString() ??
              "This Customer ID Not Has Location Or Customer Not Found",
        );
      } else if (result.statusCode == 500) {
        return Left(result.data?.toString() ?? "Internal server error");
      } else {
        return Left("Unexpected error: ${result.statusCode}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String?, bool>> updateCustomerLocation(
    ClsCustomerLocationDTO customerLocationDTO,
  ) async {
    try {
      final String requestDataJson = jsonEncode(customerLocationDTO.toJson());

      final result = await DioClient.dio.put(
        'CustomerLocation',
        data: requestDataJson,
      );

      if (result.statusCode == 200) {
        final success = result.data as bool;
        return Right(success);
      } else if (result.statusCode == 400) {
        return Left(
          result.data?.toString() ?? "The Informations Is Not Completed",
        );
      } else if (result.statusCode == 404) {
        return Left(result.data?.toString() ?? "The CustomerID Is Not Found");
      } else if (result.statusCode == 500) {
        return Left(result.data?.toString() ?? "Internal server error");
      } else {
        return Left("Unexpected error: ${result.statusCode}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
