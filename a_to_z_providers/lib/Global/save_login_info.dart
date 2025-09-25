import 'dart:io';

import 'package:a_to_z_dto/Tokens/tokens_dto.dart';
import 'package:path_provider/path_provider.dart';

class SaveLoginInfo {
  SaveLoginInfo._();

  static Future<void> writeSaveLoginInfo(
    String jWTToken,
    String refreshToken,
  ) async {
    final dir = await getApplicationCacheDirectory();

    final file = File('${dir.path}/login_info_a_to_z.txt');

    if (jWTToken.startsWith('Bearer ')) {
      jWTToken = jWTToken.substring(7);
    }

    await file.writeAsString('$jWTToken\n$refreshToken', mode: FileMode.write);
  }

  static Future<ClsTokensDTO?> readReadLoginInfo() async {
    final dir = await getApplicationCacheDirectory();

    final file = File('${dir.path}/login_info_a_to_z.txt');

    if (await file.exists()) {
      final lines = await file.readAsLines();

      if (lines.isEmpty) return null;
      if (lines[0].isEmpty) return null;
      if (lines[1].isEmpty) return null;

      ClsTokensDTO tokens = ClsTokensDTO(
        jwtToken: lines[0],
        refreshToken: lines[1],
      );
      return tokens;
    }
    return null;
  }

  static Future<void> clearLoginInfo() async {
    final dir = await getApplicationCacheDirectory();

    final file = File('${dir.path}/login_info_a_to_z.txt');

    if (await file.exists()) {
      file.writeAsString('');
    }
  }
}
