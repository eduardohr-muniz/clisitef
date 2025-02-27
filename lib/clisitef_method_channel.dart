import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'clisitef_platform_interface.dart';

/// An implementation of [ClisitefPlatform] that uses method channels.
class MethodChannelClisitef extends ClisitefPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('clisitef');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
