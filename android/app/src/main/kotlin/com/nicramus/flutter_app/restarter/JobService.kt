package com.nicramus.flutter_app.restarter

import android.app.job.JobParameters
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Handler
import android.util.Log

import androidx.annotation.RequiresApi

import com.nicramus.flutter_app.Globals
import com.nicramus.flutter_app.ProcessMainClass


@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
class JobService : android.app.job.JobService() {

    override fun onStartJob(jobParameters: JobParameters): Boolean {
        val bck = ProcessMainClass()
        bck.launchService(this)
        registerRestarterReceiver()
        instance = this
        JobService.jobParameters = jobParameters

        return false
    }

    private fun registerRestarterReceiver() {

        // the context can be null if app just installed and this is called from restartsensorservice
        // https://stackoverflow.com/questions/24934260/intentreceiver-components-are-not-allowed-to-register-to-receive-intents-when
        // Final decision: in case it is called from installation of new version (i.e. from manifest, the application is
        // null. So we must use context.registerReceiver. Otherwise this will crash and we try with context.getApplicationContext
        if (restartSensorServiceReceiver == null)
            restartSensorServiceReceiver = RestartServiceBroadcastReceiver()
        else
            try {
                unregisterReceiver(restartSensorServiceReceiver)
            } catch (e: Exception) {
                // not registered
            }

        // give the time to run
        Handler().postDelayed(Runnable {
            // we register the  receiver that will restart the background service if it is killed
            // see onDestroy of Service
            val filter = IntentFilter()
            filter.addAction(Globals.RESTART_INTENT)
            try {
                registerReceiver(restartSensorServiceReceiver, filter)
            } catch (e: Exception) {
                try {
                    getApplicationContext().registerReceiver(restartSensorServiceReceiver, filter)
                } catch (ex: Exception) {

                }

            }
        }, 1000)

    }

    /**
     * called if Android kills the job service
     * @param jobParameters
     * @return
     */
    override fun onStopJob(jobParameters: JobParameters): Boolean {
        Log.i(TAG, "Stopping job")
        val broadcastIntent = Intent(Globals.RESTART_INTENT)
        sendBroadcast(broadcastIntent)
        // give the time to run
        Handler().postDelayed(Runnable { unregisterReceiver(restartSensorServiceReceiver) }, 1000)

        return false
    }

    companion object {
        private val TAG = JobService::class.java.simpleName
        private var restartSensorServiceReceiver: RestartServiceBroadcastReceiver? = null
        private var instance: JobService? = null
        private var jobParameters: JobParameters? = null


        /**
         * called when the tracker is stopped for whatever reason
         * (not used)
         * @param context
         */
        fun stopJob(context: Context) {
            if (instance != null && jobParameters != null) {
                try {
                    instance!!.unregisterReceiver(restartSensorServiceReceiver)
                } catch (e: Exception) {
                    // not registered
                }

                Log.i(TAG, "Finishing job")
                instance!!.jobFinished(jobParameters, true)
            }
        }
    }
}