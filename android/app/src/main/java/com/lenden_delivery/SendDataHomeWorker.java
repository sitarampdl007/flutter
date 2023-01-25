package com.lenden_delivery;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.Locale;


public class SendDataHomeWorker extends Worker {

    private static final String TAG = "SendDataHomeWorker";

    //constants
    public static final String DATA_TYPE_KEY = "dataType";
    public static final int DATA_TYPE_LOCATION = 1;

    private Context currentContext;

    //Keys
    public static final String KEY_LAT_ARG = "Lat";
    public static final String KEY_LONG_ARG = "Long";
    public static final String KEY_STR_USER = "userId";
    public static final String KEY_STR_LOGI = "logisticsId";
    public static final String KEY_STR_URL = "socketUrl";
    public static final String KEY_STR_USERNAME = "username";
    public static final String KEY_STR_MOBILE = "mobileNumber";

    //Date Formats
    private static final SimpleDateFormat DATE_TIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:00", Locale.ENGLISH);
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
    private static final SimpleDateFormat TIME_FORMAT = new SimpleDateFormat("HH:mm:00", Locale.ENGLISH);

    public SendDataHomeWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
        currentContext = context;
    }

    @NonNull
    @Override
    public Result doWork() {
        //connect to socket and emit data here
        try {
            JSONObject dataGot = getLocationDataToSend();
            Log.e(TAG, "doWork: the data got" + dataGot);
            checkSocketSetupAndSend(dataGot);
            return Result.success();
        } catch (Exception e) {
            Log.e(TAG, "doWork: found error", e);
            return Result.failure();
        }
    }

    private JSONObject getLocationDataToSend() {
        try {
            //get data from shared prefs
            JSONObject dataToSend = new JSONObject();
            dataToSend.put("userId", getInputData().getString(KEY_STR_USER));
            dataToSend.put("logisticsId", getInputData().getString(KEY_STR_LOGI));
            dataToSend.put("username", getInputData().getString(KEY_STR_USERNAME));
            dataToSend.put("mobileNumber", getInputData().getString(KEY_STR_MOBILE));
            JSONObject location = new JSONObject();

            location.put("latitude", getInputData().getDouble(KEY_LAT_ARG, 0));
            location.put("longitude", getInputData().getDouble(KEY_LONG_ARG, 0));
            dataToSend.put("location", location);
            return dataToSend;
        } catch (Exception e) {
            Log.e(TAG, "getLocationDataToSend: ", e);
            return null;
        }
    }

    private void checkSocketSetupAndSend(JSONObject jsonObject) {
        if (!SocketUtils.isSocketConnected()) {
            Log.e(TAG, "checkSocketSetupAndSend: socket trying to reconnect" );
            SocketUtils.connectToServerSocket(isSuccess -> {
                    SocketUtils.emitLocationDetail(jsonObject);

            },getInputData().getString(KEY_STR_URL));
        } else {
            SocketUtils.emitLocationDetail(jsonObject);
        }
    }
}
