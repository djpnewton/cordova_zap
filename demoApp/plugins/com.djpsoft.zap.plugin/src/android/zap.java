package com.djpsoft.zap.plugin;

import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class zap extends CordovaPlugin {
    private static final String TAG = "libzap";
    private static final char NETWORK_BYTE = 'T';

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("version")) {
            this.version(callbackContext);
            return true;
        }
        if (action.equals("seedToAddress")) {
            String key = args.getString(0);
            this.seedToAddress(key, callbackContext);
            return true;
        }
        return false;
    }

    private void version(CallbackContext callbackContext) {
        int version = zap_jni.version();
        callbackContext.success(version);
    }

    private void seedToAddress(String key, CallbackContext callbackContext) {
        try {
            String address = zap_jni.seed_to_address(key, this.NETWORK_BYTE);
            callbackContext.success(address);
        }
        catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }
}
