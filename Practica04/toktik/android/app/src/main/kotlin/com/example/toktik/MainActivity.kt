package com.example.toktik

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "toktik/app_task")
            .setMethodCallHandler { call, result ->
                if (call.method == "closeAndRemoveFromRecents") {
                    finishAndRemoveTask()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
