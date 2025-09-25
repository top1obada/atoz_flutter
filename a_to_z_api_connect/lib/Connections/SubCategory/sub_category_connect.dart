import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/SubCategoryDTO/sub_category_dto.dart';
import 'package:a_to_z_dto/FilterDTO/store_category_sub_categories_dto.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert';

class SubCategoryConnect {
  SubCategoryConnect._();

  static Future<Either<String?, List<ClsSubCategoryDTO>>>
  getStoreCategorySubCategories(
    ClsStoreCategorySubCategoriesFilterDTO storeCategorySubCategoriesFilterDTO,
  ) async {
    try {
      final storeCategorySubCategoriesFilterJson = jsonEncode(
        storeCategorySubCategoriesFilterDTO.toJson(),
      );

      final result = await DioClient.dio.get(
        'SubCategory/GetStoreCategorySubCategories/$storeCategorySubCategoriesFilterJson',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final List<dynamic> dataList = result.data;
          final subCategories =
              dataList.map((item) => ClsSubCategoryDTO.fromJson(item)).toList();
          return Right(subCategories);
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
