import 'package:clisitef/clisitef.dart';
import 'package:clisitef/flutter_clisitef.dart';
import 'package:clisitef/flutter_clisitef_method_channel.dart';
import 'package:clisitef/flutter_clisitef_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clisitef/clisitef.dart';
import 'package:clisitef/clisitef_platform_interface.dart';
import 'package:clisitef/clisitef_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterClisitefPlatform with MockPlatformInterfaceMixin implements FlutterClisitefPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterClisitefPlatform initialPlatform = FlutterClisitefPlatform.instance;

  test('$MethodChannelFlutterClisitef is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterClisitef>());
  });

  test('getPlatformVersion', () async {
    FlutterClisitef flutterClisitefPlugin = FlutterClisitef();
    MockFlutterClisitefPlatform fakePlatform = MockFlutterClisitefPlatform();
    FlutterClisitefPlatform.instance = fakePlatform;

    expect(await flutterClisitefPlugin.getPlatformVersion(), '42');
  });
}
