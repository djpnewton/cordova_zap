package com.djpsoft.zap.plugin;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

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
    private static final char DEFAULT_NETWORK_BYTE = 'T';
    private ExecutorService executor = null;

    public zap()
    {
        // set the default network
        zap_jni.network_set(DEFAULT_NETWORK_BYTE);
        // create our thread pool
        executor = Executors.newSingleThreadExecutor(); 
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("version")) {
            this.version(callbackContext);
            return true;
        }
        if (action.equals("nodeGet")) {
            this.nodeGet(callbackContext);
            return true;
        }
        if (action.equals("nodeSet")) {
            String url = args.getString(0);
            this.nodeSet(url, callbackContext);
            return true;
        }
        if (action.equals("networkGet")) {
            this.networkGet(callbackContext);
            return true;
        }
        if (action.equals("networkSet")) {
            String networkByte = args.getString(0);
            this.networkSet(networkByte, callbackContext);
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
        if (action.equals("mnemonicWordlist")) {
            this.mnemonicWordlist(callbackContext);
            return true;
        }
        if (action.equals("seedAddress")) {
            String seed = args.getString(0);
            this.seedAddress(seed, callbackContext);
            return true;
        }
        if (action.equals("addressCheck")) {
            String address = args.getString(0);
            this.addressCheck(address, callbackContext);
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
            String after = args.getString(2);
            this.addressTransactions(address, count, after, callbackContext);
            return true;
        }
        if (action.equals("transactionFee")) {
            this.transactionFee(callbackContext);
            return true;
        }
        if (action.equals("transactionCreate")) {
            String seed = args.getString(0);
            String recipient = args.getString(1);
            long amount = args.getLong(2);
            long fee = args.getLong(3);
            String attachment = args.getString(4);
            this.transactionCreate(seed, recipient, amount, fee, attachment, callbackContext);
            return true;
        }
        if (action.equals("transactionBroadcast")) {
            JSONObject spendTx = args.getJSONObject(0);
            this.transactionBroadcast(spendTx, callbackContext);
            return true;
        }
        if (action.equals("uriParse")) {
            String uri = args.getString(0);
            this.uriParse(uri, callbackContext);
            return true;
        }
        return false;
    }

    private void error(CallbackContext callbackContext) {
        try {
            String[] msg_out = new String[1];
            int code = zap_jni.error(msg_out);
            JSONObject err = new JSONObject();
            err.put("code", code);
            err.put("message", msg_out[0]);
            callbackContext.error(err);
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void version(CallbackContext callbackContext) {
        int version = zap_jni.version();
        callbackContext.success(version);
    }

    private void nodeGet(CallbackContext callbackContext) {
        String url = zap_jni.node_get();
        callbackContext.success(url);
    }

    private void nodeSet(String url, CallbackContext callbackContext) {
        try {
            zap_jni.node_set(url);
            callbackContext.success();
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void networkGet(CallbackContext callbackContext) {
        char network_byte = zap_jni.network_get();
        callbackContext.success(Character.toString(network_byte));
    }

    private void networkSet(String networkByte, CallbackContext callbackContext) {
        try {
            if (networkByte != null && networkByte.length() == 1) {
                int result = zap_jni.network_set(networkByte.charAt(0));
                if (result != 0)
                    callbackContext.success();
                else
                    error(callbackContext);
            }
            else
                callbackContext.error("networkByte parameter is not valid - single character string required");
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
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

    private void mnemonicWordlist(CallbackContext callbackContext) {
        try {
            String[] words = zap_jni.mnemonic_wordlist();
            if (words != null) {
                JSONArray jsonWords = new JSONArray();
                for (int i = 0; i < words.length; i++)
                    jsonWords.put(words[i]);
                callbackContext.success(jsonWords);
            }
            else
                callbackContext.error("unable to create wordlist");
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void seedAddress(String seed, CallbackContext callbackContext) {
        try {
            String address = zap_jni.seed_address(seed);
            callbackContext.success(address);
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void addressCheck(String address, CallbackContext callbackContext) {
        try {
            IntResult balance = zap_jni.address_check(address);
            if (balance.Success)
                callbackContext.success(Long.toString(balance.Value));
            else
                error(callbackContext);
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }
    
    private void addressBalance(final String address, final CallbackContext callbackContext) {
        executor.execute(new Runnable() {
            @Override public void run() {
                try {
                    IntResult balance = zap_jni.address_balance(address);
                    if (balance.Success)
                        callbackContext.success(Long.toString(balance.Value));
                    else
                        error(callbackContext);
                }
                catch (Exception e) {
                    Log.e(TAG, "exception", e);
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }
    
    private void populateJsonTx(JSONObject jsonTx, Tx tx) throws JSONException {
        jsonTx.put("type", tx.Type);
        jsonTx.put("id", tx.Id);
        jsonTx.put("sender", tx.Sender);
        jsonTx.put("recipient", tx.Recipient);
        jsonTx.put("asset_id", tx.AssetId);
        jsonTx.put("fee_asset", tx.FeeAsset);
        jsonTx.put("amount", tx.Amount);
        jsonTx.put("fee", tx.Fee);
        jsonTx.put("timestamp", tx.Timestamp);
    }

    private void addressTransactions(final String address, final int count, final String after, final CallbackContext callbackContext) {
        executor.execute(new Runnable() {
            @Override public void run() {
                try {
                    // initialize txs with preallocated tx objects
                    Tx[] txs = new Tx[count];
                    for (int i = 0; i < count; i++)
                        txs[i] = new Tx();
                    // call into jni
                    Log.d(TAG, String.format("calling address_transactions with count: %d, after: %s", count, after));
                    IntResult result = zap_jni.address_transactions(address, txs, count, after);
                    if (result.Success) {
                        JSONArray jsonTxs = new JSONArray();
                        for (int i = 0; i < (int)result.Value; i++) {
                            JSONObject jsonTx = new JSONObject();
                            populateJsonTx(jsonTx, txs[i]);
                            jsonTxs.put(jsonTx);
                        }
                        Log.d(TAG, String.format("jsonTxs length: %d", jsonTxs.length()));
                        callbackContext.success(jsonTxs);
                    }
                    else
                    {
                        Log.e(TAG, "addressTransactions failed");
                        error(callbackContext);
                    }
                }
                catch (Exception e) {
                    Log.e(TAG, "exception", e);
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    private void transactionFee(final CallbackContext callbackContext) {
        executor.execute(new Runnable() {
            @Override public void run() {
                try {
                    // call into jni
                    Log.d(TAG, String.format("calling transaction_fee"));
                    IntResult result = zap_jni.transaction_fee();
                    if (result.Success) {
                        callbackContext.success(Long.toString(result.Value));
                    }
                    else
                    {
                        Log.e(TAG, "transactionFee failed");
                        error(callbackContext);
                    }
                }
                catch (Exception e) {
                    Log.e(TAG, "exception", e);
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    private void transactionCreate(String seed, String recipient, long amount, long fee, String attachment, CallbackContext callbackContext) {
        try {
            // call into jni
            Log.d(TAG, String.format("calling transaction_create with recipient: %s, amount: %d, fee: %d, attachment: %s", recipient, amount, fee, attachment));
            SpendTx result = zap_jni.transaction_create(seed, recipient, amount, fee, attachment);
            if (result.Success) {
                JSONObject spendTxJson = new JSONObject();
                spendTxJson.put("data", Base64.encodeToString(result.Data, Base64.DEFAULT));
                spendTxJson.put("signature", Base64.encodeToString(result.Signature, Base64.DEFAULT));
                callbackContext.success(spendTxJson);
            }
            else
            {
                Log.e(TAG, "transactionCreate failed");
                error(callbackContext);
            }
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }

    private void transactionBroadcast(final JSONObject spendTx, final CallbackContext callbackContext) {
        executor.execute(new Runnable() {
            @Override public void run() {
                try {
                    // call into jni
                    String data = spendTx.getString("data");
                    String signature = spendTx.getString("signature");
                    SpendTx spendTxJ = new SpendTx(false,
                            Base64.decode(data, Base64.DEFAULT),
                            Base64.decode(signature, Base64.DEFAULT));
                    Tx txJ = new Tx();
                    Log.d(TAG, String.format("calling transaction_broadcast data %s, signature %s", data, signature));
                    int result = zap_jni.transaction_broadcast(spendTxJ, txJ);
                    if (result != 0) {
                        JSONObject jsonTx = new JSONObject();
                        populateJsonTx(jsonTx, txJ);
                        callbackContext.success(jsonTx);
                    }
                    else
                        error(callbackContext);
                }
                catch (Exception e) {
                    Log.e(TAG, "exception", e);
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    private void populateJsonPaymentReq(JSONObject jsonReq, WavesPaymentRequest req) throws JSONException {
        jsonReq.put("address", req.Address);
        jsonReq.put("attachment", req.Attachment);
        jsonReq.put("asset_id", req.AssetId);
        jsonReq.put("amount", req.Amount);
    }

    private void uriParse(String uri, CallbackContext callbackContext) {
        try {
            // call into jni
            Log.d(TAG, String.format("uriParse: %s", uri));
            WavesPaymentRequest reqJ = new WavesPaymentRequest();
            int result = zap_jni.uri_parse(uri, reqJ);
            if (result != 0) {
                JSONObject jsonReq = new JSONObject();
                populateJsonPaymentReq(jsonReq, reqJ);
                callbackContext.success(jsonReq);
            }
            else {
                Log.e(TAG, "failed to parse uri");
                error(callbackContext);
            }
        }
        catch (Exception e) {
            Log.e(TAG, "exception", e);
            callbackContext.error(e.getMessage());
        }
    }
}
