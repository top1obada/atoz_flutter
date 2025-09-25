import 'dart:convert';

import 'package:a_to_z_dto/LoginDTO/retriving_login_dto.dart';

class ClsJWTTokenHelper {
  ClsJWTTokenHelper._();

  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final payloadBytes = base64Url.decode(normalized);
    final payloadString = utf8.decode(payloadBytes);

    return json.decode(payloadString);
  }

  static ClsRetrivingLoggedInDTO? extractLoginInfoFromToken(String? token) {
    if (token == null) return null;

    Map<String, dynamic> payload = _parseJwt(token);

    // Parse PersonID from string to int
    int? personId;
    if (payload.containsKey('PersonID') && payload['PersonID'] != null) {
      personId = int.tryParse(payload['PersonID'].toString());
    }

    // Parse UserID from string to int
    int? userId;
    if (payload.containsKey('UserID') && payload['UserID'] != null) {
      userId = int.tryParse(payload['UserID'].toString());
    }

    // Parse BranchID from string to int
    int? branchID;
    if (payload.containsKey('BranchID') && payload['BranchID'] != null) {
      branchID = int.tryParse(payload['BranchID'].toString());
    }

    // Parse IsAddressInfoConifrmed from "Yes"/"No" to boolean
    bool? isAddressInfoConifrmed;
    if (payload.containsKey('AddressConfirmed') &&
        payload['AddressConfirmed'] != null) {
      final addressConfirmed = payload['AddressConfirmed'].toString();
      isAddressInfoConifrmed = addressConfirmed == 'Yes';
    }

    // Parse VerifyPhoneNumberMode from string to enum
    EnVerifyPhoneNumberMode? verifyPhoneNumberMode;
    if (payload.containsKey('VerifyPhoneNumberMode') &&
        payload['VerifyPhoneNumberMode'] != null) {
      final modeString = payload['VerifyPhoneNumberMode'].toString();

      verifyPhoneNumberMode = EnVerifyPhoneNumberMode.values.firstWhere((e) {
        return e.name == modeString;
      }, orElse: () => EnVerifyPhoneNumberMode.eNotVerified);
    }

    // Parse JoiningDate from string to DateTime
    DateTime? parseCustomDate(String dateString) {
      try {
        // تنسيق yyyy/MM/dd
        final parts = dateString.split('/');
        if (parts.length == 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
        return null;
      } catch (e) {
        return null;
      }
    }

    // Parse JoiningDate
    DateTime? joiningDate;
    if (payload.containsKey('JoiningDate') && payload['JoiningDate'] != null) {
      final dateString = payload['JoiningDate'].toString();
      joiningDate = parseCustomDate(dateString);
    }

    return ClsRetrivingLoggedInDTO.fromJson({
      'FirstName':
          payload.containsKey('FirstName') ? payload['FirstName'] : null,
      'PersonID': personId,
      'UserID': userId,
      'JoiningDate': joiningDate,
      'BranchID': branchID,
      'IsAddressInfoConifrmed': isAddressInfoConifrmed,
      'VerifyPhoneNumberMode': verifyPhoneNumberMode?.value,
    });
  }
}
