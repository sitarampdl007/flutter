package com.lenden_delivery;

import android.Manifest;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.core.app.ActivityCompat;
import androidx.work.WorkManager;


import org.json.JSONObject;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.lenden_delivery/native";

    private static final int REQUEST_PERMISSIONS_REQUEST_CODE = 34;

    private int locationUpdatesType = LocationUtils.LOCATION_UPDATES_DISABLED;
    private static final String TAG = "MainActivity";
    String userId, socketUrl, logisticsId,username,mobileNumber;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    Context context = getActivity();
                    switch (call.method) {
                        case "checkLocationService":
                            try{
                                if (!isLocationEnabled(MainActivity.this)) {
                                    Toast.makeText(MainActivity.this, "Please enable GPS Location", Toast.LENGTH_SHORT).show();
                                    startActivity(new Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS));
                                }
                                result.success("service_enabled");
                            }
                            catch (Exception e)
                            {
                                Log.e(TAG, "configureFlutterEngine: Cant enable", e);
                                result.error("service_disabled",e.getMessage(),e);
                            }
                            break;
                        case "startLocationService":
                            try {
                                userId = call.argument("userId").toString();
                                socketUrl = call.argument("socketUrl").toString();
                                logisticsId = call.argument("logisticsId").toString();
                                username = call.argument("username").toString();
                                mobileNumber = call.argument("mobileNumber").toString();
                                Log.e(TAG, "configureFlutterEngine: User id is" + userId);
                                Log.e(TAG, "configureFlutterEngine: the socket url is" + socketUrl);
                                Log.e(TAG, "configureFlutterEngine: the logistic id is" + logisticsId);
                                Log.e(TAG, "configureFlutterEngine: the logistic id is" + username);
                                Log.e(TAG, "configureFlutterEngine: the logistic id is" + mobileNumber);
                                startLocationUpdates(userId, socketUrl,logisticsId,username,mobileNumber);
                                result.success("Started Posting");
                            } catch (Exception e) {
                                Log.e(TAG, "configureFlutterEngine: Error Starting");
                                result.error("location_error", e.getMessage(), e);
                            }
                            break;
                        case "stopLocationService":
                            try {
                                stopLocationUpdates();
                                result.success("Stopped Posting");
                            } catch (Exception e) {
                                Log.e(TAG, "configureFlutterEngine: Error Stopping");
                                result.error("location_error", e.getMessage(), e);
                            }
                            break;
                        case "cancelOldWorker":
                            stopLocationUpdates();
                            result.success("Cancelled Worker");
                            break;
                        default:
                            result.success("");
                    }
                }
        );
    }


    /*
     * =================================== ACTIVITY LIFECYCLE =======================================
     */

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onResume() {

        super.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopLocationUpdates();
    }

    /*
     * =================================== Location Functions =======================================
     */


    private void startLocationUpdates(String userId, String socketUrl,String logisticsId,String username, String mobileNumber) {
        locationUpdatesType = LocationUtils.LOCATION_UPDATES_WORKER;
        long locationUpdatesInterval = LocationUtils.DEFAULT_LOCATION_UPDATE_INTERVAL_MS;
        SocketUtils.connectToServerSocket(isSuccess -> {
            if(isSuccess)
            {
                Log.e(TAG, "From Main connected to the socket");
                LocationUtils.startWorker(this, locationUpdatesInterval, userId, socketUrl,logisticsId,username,mobileNumber);
            }
        },socketUrl);
    }



    private void stopLocationUpdates() {
        WorkManager.getInstance(this).cancelAllWork();
        WorkManager.getInstance(this).cancelAllWorkByTag("com.lenden_delivery.SendDataHomeWorker");
        WorkManager.getInstance(this).cancelAllWorkByTag("SendDataHomeWorker");
        WorkManager.getInstance(this).cancelAllWorkByTag("com.lenden_delivery.LocationUpdateWorker");
        WorkManager.getInstance(this).cancelAllWorkByTag("LocationUpdateWorker");
        WorkManager.getInstance(this).cancelUniqueWork(LocationUtils.LOCATION_WORK_NAME);
        WorkManager.getInstance(this).cancelUniqueWork("SendLocationUpdate");
        SocketUtils.recycle();
        locationUpdatesType = LocationUtils.LOCATION_UPDATES_DISABLED;
    }

    private boolean isNoLocationPermissions() {
        return PackageManager.PERMISSION_GRANTED != ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION);
    }

    private void requestLocationPermissions() {
        ActivityCompat.requestPermissions(MainActivity.this,
                new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                REQUEST_PERMISSIONS_REQUEST_CODE);
    }

    public static Boolean isLocationEnabled(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
// This is new method provided in API 28
            LocationManager lm = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
            return lm.isLocationEnabled();
        } else {
// This is Deprecated in API 28
            int mode = Settings.Secure.getInt(context.getContentResolver(), Settings.Secure.LOCATION_MODE,
                    Settings.Secure.LOCATION_MODE_OFF);
            return (mode != Settings.Secure.LOCATION_MODE_OFF);

        }
    }


}
