echo # REMOVE PLUGIN
call cordova plugin remove com.djpsoft.zap.plugin
echo # DONE

echo # ADD PLUGIN
call cordova plugin add ..\plugin
echo # DONE

echo # RUN ON ANDROID
call cordova run android
echo # DONE
