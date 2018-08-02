package com.djpsoft.zap.plugin;

public class zap_jni {
    private static final String TAG = "libzap";

    /* this is used to load the 'hello-jni' library on application
     * startup. The library has already been unpacked into
     * /data/data/com.djpsoft.zap.plugin/lib/libzap.so at
     * installation time by the package manager.
     */
    static {
        System.loadLibrary("zap");
    }

    /* A native method that is implemented by the
     * 'zap' native library, which is packaged
     * with this application.
     */
    public static native int version();
    public static native void set_network(char network_byte);
    public static native String seed_to_address(String key);
    public static native IntResult address_balance(String address);
    public static native String mnemonic_create();
    public static native int test_curl();
    public static native int test_jansson();
}
