import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/SubCategoryItemDTO/sub_category_item_dto.dart';
import 'package:a_to_z_dto/FilterDTO/store_sub_category_sub_category_items_dto.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert';

class SubCategoryItemConnect {
  SubCategoryItemConnect._();

  static Future<Either<String?, List<ClsSubCategoryItem>>>
  getStoreSubCategorySubCategoryItems(
    ClsStoreSubCategorySubCategoryItemsFilterDTO
    storeSubCategorySubCategoryItemsFilterDTO,
  ) async {
    try {
      final storeCategorySubCategoriesFilterJson = jsonEncode(
        storeSubCategorySubCategoryItemsFilterDTO.toJson(),
      );

      final result = await DioClient.dio.get(
        'SubCategoryItem/GetStoreSubCategorySubCategoryItems/$storeCategorySubCategoriesFilterJson',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final List<dynamic> dataList = result.data;
          final subCategoryItems =
              dataList
                  .map((item) => ClsSubCategoryItem.fromJson(item))
                  .toList();
          return Right(subCategoryItems);
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
