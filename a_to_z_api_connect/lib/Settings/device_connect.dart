import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<String> getDeviceName() async {
  final deviceInfo = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model ?? "Android Device";
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine ?? "iOS Device";
    } else if (Platform.isWindows) {
      var windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.computerName;
    } else if (Platform.isLinux) {
      var linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.name;
    } else if (Platform.isMacOS) {
      var macInfo = await deviceInfo.macOsInfo;
      return macInfo.model;
    } else {
      return "Unknown Device";
    }
  } catch (e) {
    return "Unknown Device";
  }
}
