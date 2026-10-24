package com.example.toktik

import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager

/**
 * Solo se registra desde src/debug. Al instalar una compilación de depuración,
 * devuelve el launcher a .DEFAULT para que Flutter pueda iniciar la app.
 */
class DebugIconResetReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_MY_PACKAGE_REPLACED) return

        val packageManager = context.packageManager
        val packageName = context.packageName
        val aliases = listOf("DEFAULT", "halloween", "christmas", "valentines")

        aliases.forEach { alias ->
            val state = if (alias == "DEFAULT") {
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            } else {
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            }
            packageManager.setComponentEnabledSetting(
                ComponentName(packageName, "$packageName.$alias"),
                state,
                PackageManager.DONT_KILL_APP,
            )
        }
    }
}
