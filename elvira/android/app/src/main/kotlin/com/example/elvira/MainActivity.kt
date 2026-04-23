package com.example.elvira

import android.app.role.RoleManager
import android.content.Intent
import android.os.Build
import android.telecom.TelecomManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "elvira/call")
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "isDefaultDialer" -> {
                    result.success(
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            val tm = getSystemService(TELECOM_SERVICE) as TelecomManager
                            packageName == tm.defaultDialerPackage
                        } else false
                    )
                }
                "requestDefaultDialer" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        val rm = getSystemService(RoleManager::class.java)
                        startActivityForResult(
                            rm.createRequestRoleIntent(RoleManager.ROLE_DIALER), 42
                        )
                    } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        startActivity(
                            Intent(TelecomManager.ACTION_CHANGE_DEFAULT_DIALER).putExtra(
                                TelecomManager.EXTRA_CHANGE_DEFAULT_DIALER_PACKAGE_NAME, packageName
                            )
                        )
                    }
                    result.success(null)
                }
                "setCallerInfo" -> {
                    CallManager.pendingCallerName = call.argument<String>("name") ?: ""
                    CallManager.pendingCallerNumber = call.argument<String>("number") ?: ""
                    result.success(null)
                }
                "getCurrentState" -> result.success(CallManager.currentState())
                "endCall" -> { CallManager.disconnect(); result.success(null) }
                "setSpeaker" -> {
                    CallManager.setSpeaker(this, call.argument<Boolean>("on") ?: false)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "elvira/call/events")
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(args: Any?, sink: EventChannel.EventSink) =
                    CallManager.setSink(sink)
                override fun onCancel(args: Any?) = CallManager.setSink(null)
            })
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }
}
