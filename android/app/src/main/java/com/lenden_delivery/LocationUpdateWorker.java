package com.lenden_delivery;

import android.content.Context;
import android.location.Location;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.concurrent.futures.CallbackToFutureAdapter;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.Observer;
import androidx.work.Constraints;
import androidx.work.Data;
import androidx.work.ExistingWorkPolicy;
import androidx.work.ListenableWorker;
import androidx.work.NetworkType;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkInfo;
import androidx.work.WorkManager;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;

import static android.content.ContentValues.TAG;

import com.google.common.util.concurrent.ListenableFuture;


public class LocationUpdateWorker extends ListenableWorker {
    private final Context currentContext;
    private LocationCallback callback;
    private FusedLocationProviderClient fusedLocationClient;

    public LocationUpdateWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
        currentContext = context;
    }

    @NonNull
    @Override
    public ListenableFuture<Result> startWork() {
        return CallbackToFutureAdapter.getFuture(completer -> {
            fusedLocationClient = LocationServices.getFusedLocationProviderClient(currentContext);
            callback = new LocationCallback() {
                @Override
                public void onLocationResult(LocationResult locationResult) {
                    super.onLocationResult(locationResult);
                    Location location = locationResult.getLastLocation();
                    Constraints constraints = new Constraints.Builder()
                            .setRequiredNetworkType(NetworkType.CONNECTED)
                            .build();


                    Data locationData = new Data.Builder()
                            .putInt(SendDataHomeWorker.DATA_TYPE_KEY, SendDataHomeWorker.DATA_TYPE_LOCATION)
                            .putDouble("Lat", location.getLatitude())
                            .putDouble("Long", location.getLongitude())
                            .putString("userId",getInputData().getString("userId"))
                            .putString("socketUrl",getInputData().getString("socketUrl"))
                            .putString("logisticsId",getInputData().getString("logisticsId"))
                            .putString("username",getInputData().getString("username"))
                            .putString("mobileNumber",getInputData().getString("mobileNumber"))
                            .build();

                    OneTimeWorkRequest uploadWorkRequest =
                            new OneTimeWorkRequest.Builder(SendDataHomeWorker.class)
                                    .setConstraints(constraints)
                                    .setInputData(locationData)
                                    .build();

                    WorkManager
                            .getInstance(getApplicationContext())
                            .enqueueUniqueWork("SendLocationUpdate", ExistingWorkPolicy.REPLACE, uploadWorkRequest);

                    finish();
                    completer.set(Result.success());
                }
            };

            LocationRequest locationRequest = new LocationRequest();
            locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
            locationRequest.setInterval(5000);
            try {
                fusedLocationClient.requestLocationUpdates(locationRequest,
                        callback, Looper.myLooper());
            } catch (SecurityException e) {
                Log.e(TAG, "doWork: got error", e);
                completer.setException(e);
            }

            return callback;
        });
    }

    private void finish() {
        fusedLocationClient.removeLocationUpdates(callback);
    }


}