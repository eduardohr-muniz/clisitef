import 'package:clisitef/flutter_clisitef_platform_interface.dart';

class FlutterClisitef {
  Future<String?> getPlatformVersion() {
    return FlutterClisitefPlatform.instance.getPlatformVersion();
  }
}
