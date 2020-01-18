/*
 * Copyright (c) 2019. This code has been developed by Fabio Ciravegna, The University of Sheffield. All rights reserved. No part of this code can be used without the explicit written permission by the author
 */
package com.nicramus.flutter_app

import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import android.app.Service

import java.util.Timer
import java.util.TimerTask

import com.nicramus.flutter_app.Notification

class NotificationService : Service() {
    private var counter = 0
    internal var oldTime: Long = 0


    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            restartForeground()
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        Log.d(TAG, "restarting Service !!")
        counter = 0

        // it has been killed by Android and now it is restarted. We must make sure to have reinitialised everything
        if (intent == null) {
            val bck = ProcessMainClass()
            bck.launchService(this)
        }

        // make sure you call the startForeground on onStartCommand because otherwise
        // when we hide the notification on onScreen it will nto restart in Android 6 and 7
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            restartForeground()
        }

        notificationServiceLogic()

        // return start sticky so if it is killed by android, it will be restarted with Intent null
        return START_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }


    /**
     * it starts the process in foreground. Normally this is done when screen goes off
     * THIS IS REQUIRED IN ANDROID 8 :
     * "The system allows apps to call Context.startForegroundService()
     * even while the app is in the background.
     * However, the app must call that service's startForeground() method within five seconds
     * after the service is created."
     */
    fun restartForeground() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Log.i(TAG, "restarting foreground")
            try {
                val notification = Notification()
                startForeground(NOTIFICATION_ID, notification
                        .setNotification(this, "Service notification",
                                "This is the service's notification", R.drawable.ic_sleep))
                Log.i(TAG, "restarting foreground successful")
                notificationServiceLogic()
            } catch (e: Exception) {
                Log.e(TAG, "Error in notification " + e.message)
            }

        }
    }


    override fun onDestroy() {
        super.onDestroy()
        Log.i(TAG, "onDestroy called")
        // restart the never ending service
        val broadcastIntent = Intent(Globals.RESTART_INTENT)
        sendBroadcast(broadcastIntent)
        stoptimertask()
    }


    /**
     * this is called when the process is killed by Android
     *
     * @param rootIntent
     */

    override fun onTaskRemoved(rootIntent: Intent) {
        super.onTaskRemoved(rootIntent)
        Log.i(TAG, "onTaskRemoved called")
        // restart the never ending service
        val broadcastIntent = Intent(Globals.RESTART_INTENT)
        sendBroadcast(broadcastIntent)
        // do not call stoptimertask because on some phones it is called asynchronously
        // after you swipe out the app and therefore sometimes
        // it will stop the timer after it was restarted
        // stoptimertask();
    }

    fun notificationServiceLogic() {
        Log.i(TAG, "Starting timer")

        //set a new Timer - if one is already running, cancel it to avoid two running at the same time
        stoptimertask()
        timer = Timer()

        //initialize the TimerTask's job
        initializeTimerTask()

        Log.i(TAG, "Scheduling...")
        //schedule the timer, to wake up every 1 second
        timer!!.schedule(timerTask!!, 1000, 1000) //
    }

    /**
     * it sets the timer to print the counter every x seconds
     */
    fun initializeTimerTask() {
        Log.i(TAG, "initialising TimerTask")
        Companion.timerTask = object : TimerTask() {
            override fun run() {
                Log.i("in timer", "in timer ++++  " + counter++)
            }
        }
    }

    /**
     * not needed
     */
    fun stoptimertask() {
        //stop the timer, if it's not already null
        if (Companion.timer != null) {
            Companion.timer!!.cancel()
            Companion.timer = null
        }
    }

    companion object {
        protected val NOTIFICATION_ID = 1337
        private val TAG = "Service"

        /**
         * static to avoid multiple timers to be created when the service is called several times
         */
        private var timer: Timer? = null
        private var timerTask: TimerTask? = null

    }


}