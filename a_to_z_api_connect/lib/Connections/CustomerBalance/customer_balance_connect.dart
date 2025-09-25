import 'dart:convert';
import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:dartz/dartz.dart';
import 'package:a_to_z_dto/CustomerBalanceDTO/customer_balance_payments_history_and_customer_balance_dto.dart';
import 'package:a_to_z_dto/FilterDTO/customer_balance_payments_history_filter_dto.dart';

class CustomerBalanceConnection {
  CustomerBalanceConnection._();

  static Future<
    Either<String?, ClsCustomerBalancePaymentsHistoryAndCustomerBalanceDTO>
  >
  getCustomerBalancePaymentsHistoryAndBalance(
    ClsCustomerBalancePaymentsHistoryFilterDTO customerBalanceFilterDTO,
  ) async {
    try {
      // Convert the DTO to JSON string (no URL encoding needed)
      final customerBalanceFilterJson = jsonEncode(
        customerBalanceFilterDTO.toJson(),
      );

      final result = await DioClient.dio.get(
        'CustomerBalance/GetCustomerBalancePaymentsHistoryAndBalance/$customerBalanceFilterJson',
      );

      if (result.statusCode == 200) {
        if (result.data is Map<String, dynamic>) {
          final data = result.data as Map<String, dynamic>;
          final balanceData =
              ClsCustomerBalancePaymentsHistoryAndCustomerBalanceDTO.fromJson(
                data,
              );
          return Right(balanceData);
        } else {
          return Left('Invalid response format: Expected a map');
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

  static Future<Either<String?, double>> getCustomerBalance(
    int customerID,
  ) async {
    try {
      if (customerID <= 0) {
        return Left('Invalid Customer ID');
      }

      final result = await DioClient.dio.get(
        'CustomerBalance/GetCustomerBalance/$customerID',
      );

      if (result.statusCode == 200) {
        if (result.data is num) {
          final balance = (result.data as num).toDouble();
          return Right(balance);
        } else {
          return Left('Invalid response format: Expected a number');
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
}
