import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class SessionConnect {
  SessionConnect._();

  static Future<Either<String, bool>> dropSession() async {
    try {
      final refreshToken =
          DioClient.dio.options.headers['RefreshToken'] as String?;

      if (refreshToken == null || refreshToken.isEmpty) {
        return const Left('RefreshToken is required');
      }

      final result = await DioClient.dio.put(
        'Session/DropSession',
        options: Options(headers: {'RefreshToken': refreshToken}),
      );

      if (result.statusCode == 200 && result.data is bool) {
        DioClient.clearHeaders();
        return Right(result.data as bool);
      } else {
        return Left(
          result.data?.toString() ??
              'Request failed with status: ${result.statusCode}',
        );
      }
    } on DioException catch (e) {
      return Left(e.response?.data?.toString() ?? e.message ?? 'Network error');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }
}
