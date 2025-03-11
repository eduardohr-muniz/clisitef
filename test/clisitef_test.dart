import 'package:clisitef/clisitef_method_channel.dart';
import 'package:clisitef/clisitef_platform_interface.dart';
import 'package:clisitef/flutter_clisitef.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClisitefPlatform with MockPlatformInterfaceMixin implements ClisitefPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ClisitefPlatform initialPlatform = ClisitefPlatform.instance;

  test('$MethodChannelClisitef is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelClisitef>());
  });

  test('getPlatformVersion', () async {
    FlutterClisitef clisitefPlugin = FlutterClisitef();
    MockClisitefPlatform fakePlatform = MockClisitefPlatform();
    ClisitefPlatform.instance = fakePlatform;

    expect(await clisitefPlugin.getPlatformVersion(), '42');
  });
}
