import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/CategoryDTO/category_dto.dart';
import 'package:a_to_z_dto/FilterDTO/store_categories_filter_dto.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert';

class CategoryConnect {
  CategoryConnect._();

  static Future<Either<String?, List<ClsCategoryDto>>> getStoreCategories(
    ClsStoreCategoriesFilterDTO storeCategoriesFilterDTO,
  ) async {
    try {
      // Serialize the filter to JSON
      final storeCategoriesFilterJson = jsonEncode(
        storeCategoriesFilterDTO.toJson(),
      );

      final result = await DioClient.dio.get(
        'Category/GetStoreCategories/$storeCategoriesFilterJson',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final List<dynamic> dataList = result.data;
          final categories =
              dataList.map((item) => ClsCategoryDto.fromJson(item)).toList();
          return Right(categories);
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
