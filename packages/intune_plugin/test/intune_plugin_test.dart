import 'package:flutter_test/flutter_test.dart';
import 'package:intune_plugin/intune_plugin.dart';
import 'package:intune_plugin/intune_plugin_method_channel.dart';
import 'package:intune_plugin/intune_plugin_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIntunePluginPlatform
    with MockPlatformInterfaceMixin
    implements IntunePluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IntunePluginPlatform initialPlatform = IntunePluginPlatform.instance;

  test('$MethodChannelIntunePlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIntunePlugin>());
  });

  test('getPlatformVersion', () async {
    final IntunePlugin intunePlugin = IntunePlugin();
    final MockIntunePluginPlatform fakePlatform = MockIntunePluginPlatform();
    IntunePluginPlatform.instance = fakePlatform;

    expect(await intunePlugin.getPlatformVersion(), '42');
  });
}
