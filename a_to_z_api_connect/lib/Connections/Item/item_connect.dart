import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/ItemDTO/store_sub_category_item_item_dto.dart';
import 'package:a_to_z_dto/FilterDTO/store_sub_category_item_items_filter_dto.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert';

class StoreSubCategoryItemItemConnect {
  StoreSubCategoryItemItemConnect._();

  static Future<Either<String?, List<ClsStoreSubCategoryItemItemDTO>>>
  getStoreSubCategoryItemItems(
    ClsStoreSubCategoryItemItemsFilterDTO storeSubCategoryItemItemsFilterDTO,
  ) async {
    try {
      final storeSubCategoryItemItemsFilterJson = jsonEncode(
        storeSubCategoryItemItemsFilterDTO.toJson(),
      );

      final result = await DioClient.dio.get(
        'Item/GetStoreSubCategoryItemItems/$storeSubCategoryItemItemsFilterJson',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final List<dynamic> dataList = result.data;
          final subCategoryItemItems =
              dataList
                  .map((item) => ClsStoreSubCategoryItemItemDTO.fromJson(item))
                  .toList();
          return Right(subCategoryItemItems);
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
