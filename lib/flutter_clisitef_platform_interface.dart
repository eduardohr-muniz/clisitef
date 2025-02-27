import 'package:clisitef/flutter_clisitef_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterClisitefPlatform extends PlatformInterface {
  /// Constructs a FlutterClisitefPlatform.
  FlutterClisitefPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterClisitefPlatform _instance = MethodChannelFlutterClisitef();

  /// The default instance of [FlutterClisitefPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterClisitef].
  static FlutterClisitefPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterClisitefPlatform] when
  /// they register themselves.
  static set instance(FlutterClisitefPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
