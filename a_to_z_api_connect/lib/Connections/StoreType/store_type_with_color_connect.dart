import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/StoreTypeDTO/store_type_with_color_dto.dart';
import 'package:dartz/dartz.dart';

class StoreTypeWithColorConnect {
  StoreTypeWithColorConnect._();

  static Future<Either<String?, List<ClsStoreTypeWithColorDto>>>
  getStoreTypesWithColors() async {
    try {
      final result = await DioClient.dio.get(
        'StoreType/GetStoreTypesWithColors',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final List<dynamic> dataList = result.data;
          final storeTypesWithColors =
              dataList
                  .map((item) => ClsStoreTypeWithColorDto.fromJson(item))
                  .toList();
          return Right(storeTypesWithColors);
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
