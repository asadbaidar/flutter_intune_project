import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:intune_plugin/intune_plugin_platform_interface.dart';

/// An implementation of [IntunePluginPlatform] that uses method channels.
class MethodChannelIntunePlugin extends IntunePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('intune_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
