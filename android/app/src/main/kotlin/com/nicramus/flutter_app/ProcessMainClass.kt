/*
 * Copyright (c) 2019. This code has been developed by Fabio Ciravegna, The University of Sheffield. All rights reserved. No part of this code can be used without the explicit written permission by the author
 */

/*
 * Created by Fabio Ciravegna, The University of Sheffield. All rights reserved.
 * no part of this code can be used without explicit permission by the author
 * f.ciravegna@shef.ac.uk
 */
package com.nicramus.flutter_app

import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

import com.nicramus.flutter_app.NotificationService

class ProcessMainClass {


    private fun setServiceIntent(context: Context) {
        if (serviceIntent == null) {
            serviceIntent = Intent(context, NotificationService::class.java)
        }
    }

    /**
     * launching the service
     */
    fun launchService(context: Context?) {
        if (context == null) {
            return
        }
        setServiceIntent(context)
        // depending on the version of Android we eitehr launch the simple service (version<O)
        // or we start a foreground service
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context!!.startForegroundService(serviceIntent)
        } else {
            context!!.startService(serviceIntent)
        }
        //Log.d(TAG, "ProcessMainClass: start service go!!!!")
    }

    companion object {
        val TAG = ProcessMainClass::class.java.simpleName
        private var serviceIntent: Intent? = null
    }
}