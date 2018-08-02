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

    public zap()
    {
        zap_jni.set_network(NETWORK_BYTE);
    }

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
        if (action.equals("addressBalance")) {
            String address = args.getString(0);
            this.addressBalance(address, callbackContext);
            return true;
        }
        if (action.equals("mnemonicCreate")) {
            this.mnemonicCreate(callbackContext);
            return true;
        }
        if (action.equals("testCurl")) {
            this.testCurl(callbackContext);
            return true;
        }
        if (action.equals("testJansson")) {
            this.testJansson(callbackContext);
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
            String address = zap_jni.seed_to_address(key);
            callbackContext.success(address);
        }
        catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void addressBalance(String address, CallbackContext callbackContext) {
        try {
            IntResult balance = zap_jni.address_balance(address);
            if (balance.getSuccess())
                callbackContext.success(balance.getValue());
            else
                callbackContext.error("unable to get balance");
        }
        catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void mnemonicCreate(CallbackContext callbackContext) {
        try {
            String mnemonic = zap_jni.mnemonic_create();
            if (mnemonic != null)
                callbackContext.success(mnemonic);
            else
                callbackContext.error("unable to create mnemonic");
        }
        catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void testCurl(CallbackContext callbackContext) {
        int res = zap_jni.test_curl();
        callbackContext.success(res);
    }

    private void testJansson(CallbackContext callbackContext) {
        int res = zap_jni.test_jansson();
        callbackContext.success(res);
    }
}
