import 'dart:convert';

import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/FilterDTO/customer_requests_filter_dto.dart';
import 'package:a_to_z_dto/RequestDTO/customer_request_dto.dart';
import 'package:dartz/dartz.dart';
import 'package:a_to_z_dto/RequestDTO/completed_request_dto.dart';

class RequestConnect {
  RequestConnect._();

  static Future<Either<String?, int>> insertCompletedRequest(
    ClsCompletedRequestDto completedRequestDTO,
  ) async {
    try {
      final String requestDataJson = jsonEncode(completedRequestDTO.toJson());

      final result = await DioClient.dio.post(
        'Request/InsertCompletedRequest',
        data: requestDataJson,
      );

      if (result.statusCode == 200) {
        final requestId = result.data as int;
        return Right(requestId);
      } else if (result.statusCode == 400) {
        return Left(result.data?.toString() ?? "Bad request");
      } else if (result.statusCode == 500) {
        return Left(result.data?.toString() ?? "Internal server error");
      } else {
        return Left("Unexpected error: ${result.statusCode}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String?, List<ClsCustomerRequestDto>>>
  getCustomerRequests(ClsCustomerRequestsFilterDTO filter) async {
    try {
      final String filterJson = jsonEncode(filter.toJson());

      final result = await DioClient.dio.post(
        'Request/GetCustomerRequests/$filterJson',
      );

      if (result.statusCode == 200) {
        // Parse the response data into a list of ClsCustomerRequestDto
        final List<dynamic> responseData = result.data;
        final List<ClsCustomerRequestDto> requests =
            responseData
                .map((item) => ClsCustomerRequestDto.fromJson(item))
                .toList();

        return Right(requests);
      } else if (result.statusCode == 400) {
        return Left(result.data?.toString() ?? "Bad request");
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
