cordova.define("com.djpsoft.zap.plugin.zap", function(require, exports, module) {
var exec = require('cordova/exec');

var PLUGIN_NAME = 'zap';

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, PLUGIN_NAME, 'coolMethod', [arg0]);
};

});
