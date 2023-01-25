package com.lenden_delivery;
import android.util.Log;
import org.json.JSONObject;

import java.net.URISyntaxException;
import io.socket.client.Socket;
import io.socket.client.IO;
import io.socket.emitter.Emitter;

public class SocketUtils {

    private static final String TAG = "SocketUtils";
    //socket io
    public static Socket socket;

    public static void connectToServerSocket(final SocketCallback callback,String socketUrl) {
        if (socket != null && socket.connected()) {
            return;
        }

        try {
            IO.Options options = new IO.Options();
            options.transports = new String[] {"websocket"};
            socket = IO.socket(socketUrl, options);

        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        socket.connect();
        if(socket.connected()){
            Log.e(TAG, "connectToServerSocket: socket connected and ready" );
        }
        else{
            Log.e(TAG, "connectToServerSocket: socket not connected" );
        }
        socket.on(Socket.EVENT_CONNECT, args -> {
            Log.e(TAG, "connectToServerSocket: "+"****Connected : " );
            callback.onConnection(true);

        }).on(Socket.EVENT_DISCONNECT, new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                Log.e(TAG , " connectToServerSocket event_disconnected"+ "Connection lost  : ");
                callback.onConnection(false);
            }

        });
    }

    //    START NODE JS LISTENERS
    public static void emitLocationDetail(JSONObject userObj) {
        if (socket != null && socket.connected()) {
            Log.e(TAG , " emitJobAccept emit emitter for socket connected and join to room");
            //emitter to post data
            Log.e(TAG , " nodeJs emitJobAccept emit data" + userObj.toString());
            socket.emit("location", userObj);
        }
    }

    public static boolean isSocketConnected() {
        if (socket == null) return false;
        return socket.connected();
    }

    public static void recycle() {
        try {
            if (socket != null) {
                if (socket.connected()) {
                    socket.disconnect();
                }
                socket = null;
            }
        } catch (Exception e) {
        }
    }

    public interface SocketCallback {
        void onConnection(boolean isSuccess);
    }

}
