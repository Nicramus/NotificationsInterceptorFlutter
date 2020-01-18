package com.nicramus.flutter_app

import com.nicramus.flutter_app.R
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build

import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

import com.nicramus.flutter_app.MainActivity


class Notification {
    private var notificationPendingIntent: PendingIntent? = null

    /**
     * This is the method  called to create the Notification
     */
    fun setNotification(context: Context, title: String, text: String, icon: Int): android.app.Notification {
        if (notificationPendingIntent == null) {
            val notificationIntent = Intent(context, MainActivity::class.java)
            notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            // notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            notificationPendingIntent = PendingIntent.getActivity(context, 0, notificationIntent, 0)
        }

        val notification: android.app.Notification

        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // OREO
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the NotificationChannel, but only on API 26+ because
            // the NotificationChannel class is new and not in the support library
            val name = "Permanent Notification"
            //mContext.getString(R.string.channel_name);
            val importance = NotificationManager.IMPORTANCE_LOW

            val CHANNEL_ID = "uk.ac.shef.oak.channel"
            val channel = NotificationChannel(CHANNEL_ID, name, importance)
            //String description = mContext.getString(R.string.notifications_description);
            val description = "I would like to receive travel alerts and notifications for:"
            channel.setDescription(description)
            val notificationBuilder = NotificationCompat.Builder(context, CHANNEL_ID)
            if (notificationManager != null) {
                notificationManager!!.createNotificationChannel(channel)
            }
            notification = notificationBuilder
                    //the log is PNG file format with a transparent background
                    .setSmallIcon(icon)
                    //.setColor(ContextCompat.getColor(context, R.color.colorAccent))
                    .setContentTitle(title)
                    .setContentText(text)
                    .setContentIntent(notificationPendingIntent)
                    .build()

        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            notification = NotificationCompat.Builder(context, "channel")
                    // to be defined in the MainActivity of the app
                    .setSmallIcon(icon)
                    .setContentTitle(title)
                    //                    .setColor(mContext.getResources().getColor(R.color.colorAccent))
                    .setContentText(text)
                    .setPriority(android.app.Notification.PRIORITY_MIN)
                    .setContentIntent(notificationPendingIntent).build()
        } else {
            notification = NotificationCompat.Builder(context, "channel")
                    // to be defined in the MainActivity of the app
                    .setSmallIcon(icon)
                    .setContentTitle(title)
                    .setContentText(text)
                    .setPriority(android.app.Notification.PRIORITY_MIN)
                    .setContentIntent(notificationPendingIntent).build()
        }

        return notification
    }

}