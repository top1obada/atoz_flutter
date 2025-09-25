import 'dart:convert';

import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/StoreDTO/customer_store_suggestion_dto.dart';
import 'package:dartz/dartz.dart';
import 'package:a_to_z_dto/FilterDTO/customer_store_filter_dto.dart';
import 'package:a_to_z_dto/FilterDTO/customer_favorite_store_filter_dto.dart';
import 'package:a_to_z_dto/FilterDTO/customer_searching_store_filter_dto.dart';

class StoreConnection {
  StoreConnection._();

  static Future<Either<String?, List<ClsCustomerStoreSuggestionDTO>>>
  getCustomerStoreSuggestions(
    ClsCustomerStoresFilterDTO customerStoreFilterDTO,
  ) async {
    try {
      // Convert the DTO to JSON string (no URL encoding needed)
      final customerStoresFilterJson = jsonEncode(
        customerStoreFilterDTO.toJson(),
      );

      final result = await DioClient.dio.get(
        'Store/GetCustomerStoresSuggestions/$customerStoresFilterJson',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final List<dynamic> dataList = result.data;
          final stores =
              dataList
                  .map((item) => ClsCustomerStoreSuggestionDTO.fromJson(item))
                  .toList();
          return Right(stores);
        } else {
          return Left('Invalid response format: Expected a list');
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

  static Future<Either<String?, List<ClsCustomerStoreSuggestionDTO>>>
  getCustomerFavoriteStore(
    ClsCustomerFavoriteStoreFilterDTO customerFavoriteStoreFilterDTO,
  ) async {
    try {
      final customerFavoriteStoreFilterJson = jsonEncode(
        customerFavoriteStoreFilterDTO.toJson(),
      );
      final result = await DioClient.dio.get(
        'Store/GetCustomerFavoriteStores/$customerFavoriteStoreFilterJson',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final List<dynamic> dataList = result.data;
          final stores =
              dataList
                  .map((item) => ClsCustomerStoreSuggestionDTO.fromJson(item))
                  .toList();
          return Right(stores);
        } else {
          return Left('Invalid response format: Expected a list');
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

  static Future<Either<String?, List<ClsCustomerStoreSuggestionDTO>>>
  getFamousCustomerStore(
    ClsCustomerStoresFilterDTO customerStoreFilterDTO,
  ) async {
    try {
      final customerFamousStoreFilterJson = jsonEncode(
        customerStoreFilterDTO.toJson(),
      );
      final result = await DioClient.dio.get(
        'Store/GetFamousCustomerStores/$customerFamousStoreFilterJson',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final List<dynamic> dataList = result.data;
          final stores =
              dataList
                  .map((item) => ClsCustomerStoreSuggestionDTO.fromJson(item))
                  .toList();
          return Right(stores);
        } else {
          return Left('Invalid response format: Expected a list');
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

  static Future<Either<String?, List<ClsCustomerStoreSuggestionDTO>>>
  getCustomerPreviousRequestsStores(
    ClsCustomerFavoriteStoreFilterDTO customerFavoriteStoreFilterDTO,
  ) async {
    try {
      final customerFavoriteStoreFilterJson = jsonEncode(
        customerFavoriteStoreFilterDTO.toJson(),
      );

      final result = await DioClient.dio.get(
        'Store/GetCustomerPreviousRequestsStores/$customerFavoriteStoreFilterJson',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final List<dynamic> dataList = result.data;
          final stores =
              dataList
                  .map((item) => ClsCustomerStoreSuggestionDTO.fromJson(item))
                  .toList();
          return Right(stores);
        } else {
          return Left('Invalid response format: Expected a list');
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

  static Future<Either<String?, List<ClsCustomerStoreSuggestionDTO>>>
  getCustomerSearchStores(
    ClsCustomerSearchingStoresFilterDTO customerSearchingStoresFilterDTO,
  ) async {
    try {
      final customerSearchingStoresFilterJson = jsonEncode(
        customerSearchingStoresFilterDTO.toJson(),
      );
      final result = await DioClient.dio.get(
        'Store/GetCustomerSearchStores/$customerSearchingStoresFilterJson',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final List<dynamic> dataList = result.data;
          final stores =
              dataList
                  .map((item) => ClsCustomerStoreSuggestionDTO.fromJson(item))
                  .toList();
          return Right(stores);
        } else {
          return Left('Invalid response format: Expected a list');
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
