package com.lenden_delivery;

import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Location;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.lifecycle.Observer;
import androidx.work.Data;
import androidx.work.ExistingPeriodicWorkPolicy;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkInfo;
import androidx.work.WorkManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.DateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;

public class LocationUtils {

    static final String KEY_REQUESTING_LOCATION_UPDATES = "flutter.location-updates-state";
    static final String KEY_LOCATION_UPDATE_INTERVAL = "flutter.location-updates-interval";
    static final String KEY_LOCATION_SHOW_NOTIFICATION = "flutter.location-updates-show-notification";
    static final String LOCATION_WORK_NAME = "LDLocationWorker";

    static final int LOCATION_UPDATES_DISABLED = 0;
    static final int LOCATION_UPDATES_WORKER = 2;

    static final int DEFAULT_LOCATION_UPDATE_INTERVAL_MS = 60000; //15 minutes
    private static final String TAG = "LocationUtils";// nutes


    static void startWorker(Context context, long interval,String userId,String socketUrl, String logisticsId,String username,String mobileNumber) {
        Data userData = new Data.Builder()
                .putString("userId",userId)
                .putString("socketUrl",socketUrl)
                .putString("logisticsId",logisticsId)
                .putString("username",username)
                .putString("mobileNumber",mobileNumber)
                .build();
        PeriodicWorkRequest periodicWork = new PeriodicWorkRequest.Builder(LocationUpdateWorker.class, interval, TimeUnit.MILLISECONDS)
                .setInputData(userData)
                .build();
        WorkManager.getInstance(context).enqueueUniquePeriodicWork(LocationUtils.LOCATION_WORK_NAME, ExistingPeriodicWorkPolicy.REPLACE, periodicWork);
    }

}
