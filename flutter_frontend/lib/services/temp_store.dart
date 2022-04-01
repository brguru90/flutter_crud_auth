import 'package:device_info_plus/device_info_plus.dart';

Map temp_store = {};

void temp_store_reset() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final map = deviceInfo.toMap();
  temp_store = {"deviceInfo": map};
}
