import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppTaskService {
  static const _channel = MethodChannel('toktik/app_task');

  static Future<void> closeAndRemoveFromRecents() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    await _channel.invokeMethod<void>('closeAndRemoveFromRecents');
  }
}
