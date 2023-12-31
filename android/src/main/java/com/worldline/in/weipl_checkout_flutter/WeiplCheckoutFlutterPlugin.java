package com.worldline.in.weipl_checkout_flutter;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;

import com.weipl.checkout.WLCheckoutActivity;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * WeiplCheckoutFlutterPlugin
 */
public class WeiplCheckoutFlutterPlugin implements FlutterPlugin, MethodCallHandler, WLCheckoutActivity.PaymentResponseListener, ActivityAware {
    // The MethodChannel that will the communication between Flutter and native Android
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity

    private static final String PLUGIN_NAME = "weipl_checkout_flutter";
    private static final String TAG = "WeiplCheckout";
    private static MethodChannel channel;

    private static Activity activity;

    private static Result callback;

    public WeiplCheckoutFlutterPlugin() {

    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), PLUGIN_NAME);
        activity = registrar.activity();
        channel.setMethodCallHandler(new WeiplCheckoutFlutterPlugin());
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), PLUGIN_NAME);
        channel.setMethodCallHandler(this);

        Context context;
        context = flutterPluginBinding.getApplicationContext();
        WLCheckoutActivity.setPaymentResponseListener(this);
        WLCheckoutActivity.preloadData(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        this.callback = result;
        try {
            if (call.method.equals("open")) {
                this.open((Map < String, Object > ) call.arguments);
            } else if (call.method.equals("upiIntentAppsList")) {
                this.upiIntentAppsList();
            } else {
                result.notImplemented();
            }
        } catch (Exception e) {
            Log.d(TAG, "Error occurred in onMethodCall() :\n" + e.getLocalizedMessage());
        }
    }

    private void open(Map < String, Object > args) {
        if (args == null) {
            this.callback.success("Expected checkout initialisation options");
            return;
        }

        try {
            JSONObject convertedObject = new JSONObject(args);
            WLCheckoutActivity.open(activity, convertedObject);
        } catch (Exception e) {
            Log.d(TAG, e.getLocalizedMessage());
            throw new RuntimeException(e);
        }
    }

    private void upiIntentAppsList() {
        JSONArray upiIntentResponse = WLCheckoutActivity.getUPIResponse(activity);

        if (upiIntentResponse == null) {
            if (this != null && this.callback != null) {
                this.callback.success("No response received!");
            }
            Log.d(TAG, "No response received!");
        } else {
            List < Object > retList = new ArrayList < Object > ();
            if (upiIntentResponse != null) {
                try {
                    retList = toList(upiIntentResponse);
                    this.callback.success(retList);
                } catch (Exception e) {
                    Log.d(TAG, "Got error in upiIntentAppsList()");
                    throw new RuntimeException(e);
                }
            }
        }
    }

    public static Map < String, Object > toMap(JSONObject object) throws JSONException {
        Map < String, Object > map = new HashMap < String, Object > ();

        Iterator < String > keysItr = object.keys();
        while (keysItr.hasNext()) {
            String key = keysItr.next();
            Object value = object.get(key);

            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            map.put(key, value);
        }
        return map;
    }

    public static List < Object > toList(JSONArray array) throws JSONException {
        List < Object > list = new ArrayList < Object > ();
        for (int i = 0; i < array.length(); i++) {
            Object value = array.get(i);
            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            list.add(value);
        }
        return list;
    }

    @Override
    public void wlCheckoutPaymentResponse(JSONObject jsonObject) {
        Map < String, Object > retMap = new HashMap < String, Object > ();
        if (jsonObject != null) {
            try {
                retMap = toMap(jsonObject);
                this.callback.success(retMap);
            } catch (Exception e) {
                Log.d(TAG, "Got error in wlCheckoutPaymentResponse()");
                throw new RuntimeException(e);
            }
        }
    }

    @Override
    public void wlCheckoutPaymentError(JSONObject jsonObject) {
        Map < String, Object > retMap = new HashMap < String, Object > ();
        if (jsonObject != null) {
            try {
                retMap = toMap(jsonObject);
                this.callback.success(retMap);
            } catch (Exception e) {
                Log.d(TAG, "Got error in wlCheckoutPaymentError()");
                throw new RuntimeException(e);
            }
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        try {
            channel.setMethodCallHandler(null);
        } catch (Exception e) {
            Log.d(TAG, "Got error in onDetachedFromEngine()");
        }
    }

    @Override
    public void onDetachedFromActivity() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        try {
            activity = binding.getActivity();
        } catch (Exception e) {
            Log.d(TAG, "Got error in onReattachedToActivityForConfigChanges()");
        }
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        try {
            activity = binding.getActivity();
        } catch (Exception e) {
            Log.d(TAG, "Got error in onAttachedToActivity()");
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }
}
