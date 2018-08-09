package com.djpsoft.zap.plugin;

import android.util.Log;
import android.util.Base64;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class zap extends CordovaPlugin {
    private static final String TAG = "LIBZAPj";
    private static final char NETWORK_BYTE = 'T';

    public zap()
    {
        zap_jni.network_set(NETWORK_BYTE);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("version")) {
            this.version(callbackContext);
            return true;
        }
        if (action.equals("mnemonicCreate")) {
            this.mnemonicCreate(callbackContext);
            return true;
        }
        if (action.equals("mnemonicCheck")) {
            String mnemonic = args.getString(0);
            this.mnemonicCheck(mnemonic, callbackContext);
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
        if (action.equals("addressTransactions")) {
            String address = args.getString(0);
            int count = args.getInt(1);
            this.addressTransactions(address, count, callbackContext);
            return true;
        }
        if (action.equals("transactionCreate")) {
            String seed = args.getString(0);
            String recipient = args.getString(1);
            long amount = args.getLong(2);
            String attachment = args.getString(3);
            this.transactionCreate(seed, recipient, amount, attachment, callbackContext);
            return true;
        }
        if (action.equals("transactionBroadcast")) {
            JSONObject spendTx = args.getJSONObject(0);
            this.transactionBroadcast(spendTx, callbackContext);
            return true;
        }
        return false;
    }

    private void version(CallbackContext callbackContext) {
        int version = zap_jni.version();
        callbackContext.success(version);
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
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void mnemonicCheck(String mnemonic, CallbackContext callbackContext) {
        try {
            int result = zap_jni.mnemonic_check(mnemonic);
            callbackContext.success(result);
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void seedToAddress(String key, CallbackContext callbackContext) {
        try {
            String address = zap_jni.seed_to_address(key);
            callbackContext.success(address);
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void addressBalance(String address, CallbackContext callbackContext) {
        try {
            IntResult balance = zap_jni.address_balance(address);
            if (balance.Success)
                //TODO: how to return long ints :(
                callbackContext.success((int)balance.Value);
            else
                callbackContext.error("unable to get balance");
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void addressTransactions(String address, int count, CallbackContext callbackContext) {
        try {
            // initialize txs with preallocated tx objects
            Tx[] txs = new Tx[count];
            for (int i = 0; i < count; i++)
                txs[i] = new Tx();
            // call into jni
            Log.d(TAG, String.format("calling address_transactions with count: %d", count));
            IntResult result = zap_jni.address_transactions(address, txs, count);
            if (result.Success) {
                JSONArray jsonTxs = new JSONArray();
                //TODO: why are longs not shown properly!!
                for (int i = 0; i < (int)result.Value; i++) {
                    JSONObject jsonTx = new JSONObject();
                    jsonTx.put("id", txs[i].Id);
                    jsonTx.put("sender", txs[i].Sender);
                    jsonTx.put("recipient", txs[i].Recipient);
                    jsonTx.put("asset_id", txs[i].AssetId);
                    jsonTx.put("fee_asset", txs[i].FeeAsset);
                    jsonTx.put("amount", txs[i].Amount);
                    jsonTx.put("fee", txs[i].Fee);
                    jsonTx.put("timestamp", txs[i].Timestamp);
                    jsonTxs.put(jsonTx);
                }
                Log.d(TAG, String.format("jsonTxs length: %d", jsonTxs.length()));
                callbackContext.success(jsonTxs);
            }
            else
            {
                Log.e(TAG, "addressTransactions failed");
                callbackContext.error("unable to get result");
            }
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void transactionCreate(String seed, String recipient, long amount, String attachment, CallbackContext callbackContext) {
        try {
            // call into jni
            Log.d(TAG, String.format("calling transaction_create with recipient: %s, amount: %d, attachment: %s", recipient, amount, attachment));
            SpendTx result = zap_jni.transaction_create(seed, recipient, amount, attachment);
            if (result.Success) {
                JSONObject spendTxJson = new JSONObject();
                spendTxJson.put("txdata", Base64.encodeToString(result.TxData, Base64.DEFAULT));
                spendTxJson.put("signature", Base64.encodeToString(result.Signature, Base64.DEFAULT));
                callbackContext.success(spendTxJson);
            }
            else
            {
                Log.e(TAG, "transactionCreate failed");
                callbackContext.error("unable to get result");
            }
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void transactionBroadcast(JSONObject spendTx, CallbackContext callbackContext) {
        try {
            // call into jni
            String txdata = spendTx.getString("txdata");
            String signature = spendTx.getString("signature");
            SpendTx spendTxJ = new SpendTx(false,
                    Base64.decode(txdata, Base64.DEFAULT),
                    Base64.decode(signature, Base64.DEFAULT));
            Log.d(TAG, String.format("calling transaction_broadcast txdata %s, signature %s", txdata, signature));
            int result = zap_jni.transaction_broadcast(spendTxJ);
            callbackContext.success(result);
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }
}
