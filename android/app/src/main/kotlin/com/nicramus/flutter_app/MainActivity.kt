package com.nicramus.flutter_app

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.os.Build

import io.flutter.plugin.common.MethodChannel

import com.nicramus.flutter_app.restarter.RestartServiceBroadcastReceiver

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.nicramus.notificationinterceptor/service"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "startService") {
                connectToService()
                //ProcessMainClass ppp = ProcessMainClass()
            }
        }
    }

    //send different configuration to the service
    //TODO config - which notifications should be filtered - the settings as parameters
    fun connectToService() {

    }

    override fun onResume() {
        super.onResume()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            RestartServiceBroadcastReceiver.scheduleJob(getApplicationContext())
        } else {
            val bck = ProcessMainClass()
            bck.launchService(getApplicationContext())
        }
    }

}
