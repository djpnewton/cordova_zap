cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
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
  "com.djpsoft.zap.plugin": "0.0.1",
  "cordova-plugin-whitelist": "1.3.3"
};
// BOTTOM OF METADATA
});