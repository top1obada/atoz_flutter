import 'dart:convert';

import 'package:a_to_z_api_connect/Settings/device_connect.dart';
import 'package:a_to_z_dto/CustomerDTO/customer_sign_up_by_username_dto.dart';
import 'package:a_to_z_dto/LocationDTO/user_point_dto.dart';
import 'package:a_to_z_dto/PersonDTO/person_with_point_dto.dart';

import 'package:dartz/dartz.dart';
import 'package:a_to_z_api_connect/Settings/dio_connect.dart';
import 'package:a_to_z_dto/LoginDTO/native_login_info_dto.dart';
import 'package:a_to_z_dto/Tokens/tokens_dto.dart';

class CustomerConnect {
  CustomerConnect._();

  static Future<Either<String?, ClsTokensDTO>> customerGoEmail(
    String idToken,
    String accessToken,
    ClsUserPointDTO userPointDTO,
  ) async {
    DioClient.clearHeaders();

    DioClient.setIDToken(idToken);
    DioClient.setAccessToken(accessToken);

    String deviceName = await getDeviceName();

    final String userPointJson = jsonEncode(userPointDTO.toJson());

    try {
      final result = await DioClient.dio.post(
        'Customer/GoEmail/$deviceName',
        data: userPointJson,
      );

      if (result.statusCode == 200) {
        final tokens = ClsTokensDTO.fromJson(result.data);

        if (tokens.jwtToken == null) {
          return Left("There Is No JWT Token");
        }

        if (tokens.refreshToken == null) {
          return Left("There Is No refreshed Token");
        }

        DioClient.clearHeaders();

        DioClient.setAuthToken(tokens.jwtToken!);

        DioClient.setRefreshToken(tokens.refreshToken!);

        return Right(tokens);
      } else {
        return Left(result.data?.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String?, ClsTokensDTO>> customerLoginByUserName(
    ClsNativeLoginInfoDTO nativeLoginInfoDTO,
    ClsUserPointDTO userPointDTO,
  ) async {
    try {
      // Serialize the DTO to JSON

      DioClient.clearHeaders();
      // Set the serialized JSON as LoginData header
      final String loginDataJson = jsonEncode(nativeLoginInfoDTO.toJson());
      DioClient.setLoginData(loginDataJson);

      String deviceName = await getDeviceName();

      final String userPointJson = jsonEncode(userPointDTO.toJson());

      final result = await DioClient.dio.get(
        'CustomerAccess/LoginByUserName/$deviceName',
        data: userPointJson,
      );

      if (result.statusCode == 200) {
        final tokens = ClsTokensDTO.fromJson(result.data);

        if (tokens.jwtToken == null) {
          return Left("There Is No JWT Token");
        }

        if (tokens.refreshToken == null) {
          return Left("There Is No refreshed Token");
        }

        DioClient.clearHeaders();

        DioClient.setAuthToken(tokens.jwtToken!);

        DioClient.setRefreshToken(tokens.refreshToken!);

        return Right(tokens);
      } else {
        return Left(result.data?.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String?, ClsTokensDTO>> customerSignUpByUserName(
    ClsSignUpCustomerByUserNameDTO customerSignUpByUserNameDTO,
    ClsUserPointDTO userPointDTO,
  ) async {
    DioClient.clearHeaders();

    ClsNativeLoginInfoDTO nativeLoginInfoDTO = ClsNativeLoginInfoDTO(
      userName: customerSignUpByUserNameDTO.nativeLoginInfoDTO!.userName,
      password: customerSignUpByUserNameDTO.nativeLoginInfoDTO!.password,
    );

    final String loginDataJson = jsonEncode(nativeLoginInfoDTO.toJson());

    DioClient.setLoginData(loginDataJson);

    String deviceName = await getDeviceName();

    ClsPersonWithPointDTO personWithPointDTO = ClsPersonWithPointDTO(
      personDTO: customerSignUpByUserNameDTO.person,
      userPointDTO: userPointDTO,
    );

    final String personWithPointJson = jsonEncode(personWithPointDTO.toJson());

    try {
      final result = await DioClient.dio.post(
        'CustomerAccess/SignUpByUserName/$deviceName',
        data: personWithPointJson,
      );

      if (result.statusCode == 200) {
        final tokens = ClsTokensDTO.fromJson(result.data);

        if (tokens.jwtToken == null) {
          return Left("There Is No JWT Token");
        }

        if (tokens.refreshToken == null) {
          return Left("There Is No refreshed Token");
        }

        DioClient.clearHeaders();

        DioClient.setAuthToken(tokens.jwtToken!);

        DioClient.setRefreshToken(tokens.refreshToken!);

        return Right(tokens);
      } else {
        return Left(result.data?.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
