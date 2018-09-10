cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
  {
    "id": "cordova-plugin-qrscanner.QRScanner",
    "file": "plugins/cordova-plugin-qrscanner/www/www.min.js",
    "pluginId": "cordova-plugin-qrscanner",
    "clobbers": [
      "QRScanner"
    ]
  },
  {
    "id": "com.djpsoft.zap.plugin.zap",
    "file": "plugins/com.djpsoft.zap.plugin/www/zap.js",
    "pluginId": "com.djpsoft.zap.plugin",
    "clobbers": [
      "cordova.plugins.zap"
    ]
  }
];
module.exports.metadata = 
// TOP OF METADATA
{
  "cordova-plugin-whitelist": "1.3.3",
  "cordova-plugin-add-swift-support": "1.7.2",
  "cordova-plugin-qrscanner": "2.6.0",
  "com.djpsoft.zap.plugin": "0.0.2"
};
// BOTTOM OF METADATA
});