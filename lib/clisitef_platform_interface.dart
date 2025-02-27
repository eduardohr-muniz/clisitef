import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'clisitef_method_channel.dart';

abstract class ClisitefPlatform extends PlatformInterface {
  /// Constructs a ClisitefPlatform.
  ClisitefPlatform() : super(token: _token);

  static final Object _token = Object();

  static ClisitefPlatform _instance = MethodChannelClisitef();

  /// The default instance of [ClisitefPlatform] to use.
  ///
  /// Defaults to [MethodChannelClisitef].
  static ClisitefPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ClisitefPlatform] when
  /// they register themselves.
  static set instance(ClisitefPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
