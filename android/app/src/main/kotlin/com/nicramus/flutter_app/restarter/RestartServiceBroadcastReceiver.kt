/*
 * Copyright (c) 2019. This code has been developed by Fabio Ciravegna, The University of Sheffield. All rights reserved. No part of this code can be used without the explicit written permission by the author
 */

package com.nicramus.flutter_app.restarter


import android.app.job.JobInfo
import android.app.job.JobScheduler
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageInfo
import android.os.Build
import android.os.Handler
import android.util.Log

import androidx.annotation.RequiresApi

import com.nicramus.flutter_app.Globals
import com.nicramus.flutter_app.ProcessMainClass

import android.content.Context.JOB_SCHEDULER_SERVICE

class RestartServiceBroadcastReceiver : BroadcastReceiver() {
    private var restartSensorServiceReceiver: RestartServiceBroadcastReceiver? = null


    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "about to start timer " + context.toString())
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            scheduleJob(context)
        } else {
            registerRestarterReceiver(context)
            val bck = ProcessMainClass()
            bck.launchService(context)
        }
    }


    private fun registerRestarterReceiver(context: Context) {

        // the context can be null if app just installed and this is called from restartsensorservice
        // https://stackoverflow.com/questions/24934260/intentreceiver-components-are-not-allowed-to-register-to-receive-intents-when
        // Final decision: in case it is called from installation of new version (i.e. from manifest, the application is
        // null. So we must use context.registerReceiver. Otherwise this will crash and we try with context.getApplicationContext
        if (restartSensorServiceReceiver == null)
            restartSensorServiceReceiver = RestartServiceBroadcastReceiver()
        else
            try {
                context.unregisterReceiver(restartSensorServiceReceiver)
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
                context.registerReceiver(restartSensorServiceReceiver, filter)
            } catch (e: Exception) {
                try {
                    context.getApplicationContext().registerReceiver(restartSensorServiceReceiver, filter)
                } catch (ex: Exception) {

                }

            }
        }, 1000)

    }

    companion object {
        val TAG = RestartServiceBroadcastReceiver::class.java.simpleName
        private var jobScheduler: JobScheduler? = null

        /**
         * it returns the number of version code
         *
         * @param context
         * @return
         */
        fun getVersionCode(context: Context): Long {
            val pInfo: PackageInfo
            try {
                pInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0)
                return System.currentTimeMillis()

            } catch (e: Exception) {
                Log.e(TAG, e.message)
            }

            return 0
        }

        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        fun scheduleJob(context: Context) {
            if (jobScheduler == null) {
                jobScheduler = context
                        .getSystemService(JOB_SCHEDULER_SERVICE) as JobScheduler
            }
            val componentName = ComponentName(context,
                    JobService::class.java)
            val jobInfo = JobInfo.Builder(1, componentName)
                    // setOverrideDeadline runs it immediately - you must have at least one constraint
                    // https://stackoverflow.com/questions/51064731/firing-jobservice-without-constraints
                    .setOverrideDeadline(0)
                    .setPersisted(true).build()
            jobScheduler!!.schedule(jobInfo)
        }


        fun reStartTracker(context: Context) {
            // restart the never ending service
            Log.i(TAG, "Restarting tracker")
            val broadcastIntent = Intent(Globals.RESTART_INTENT)
            context.sendBroadcast(broadcastIntent)
        }
    }

}
