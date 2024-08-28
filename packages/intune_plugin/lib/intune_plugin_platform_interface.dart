import 'package:intune_plugin/intune_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class IntunePluginPlatform extends PlatformInterface {
  /// Constructs a IntunePluginPlatform.
  IntunePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static IntunePluginPlatform _instance = MethodChannelIntunePlugin();

  /// The default instance of [IntunePluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelIntunePlugin].
  static IntunePluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IntunePluginPlatform] when
  /// they register themselves.
  static set instance(IntunePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
