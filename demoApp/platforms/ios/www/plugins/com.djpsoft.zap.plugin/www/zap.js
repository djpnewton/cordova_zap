cordova.define("com.djpsoft.zap.plugin.zap", function(require, exports, module) {
var exec = require('cordova/exec');

var PLUGIN_NAME = 'zap';

exports.version = function (success, error) {
    exec(success, null, PLUGIN_NAME, 'version', []);
};

exports.seedToAddress = function (arg0, success, error) {
    exec(success, error, PLUGIN_NAME, 'seedToAddress', [arg0]);
};


});
