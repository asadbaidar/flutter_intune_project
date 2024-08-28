
import 'package:intune_plugin/intune_plugin_platform_interface.dart';

class IntunePlugin {
  Future<String?> getPlatformVersion() {
    return IntunePluginPlatform.instance.getPlatformVersion();
  }
}
