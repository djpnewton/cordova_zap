var exec = require('cordova/exec');

var PLUGIN_NAME = 'zap';

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, PLUGIN_NAME, 'coolMethod', [arg0]);
};

exports.version = function (success, error) {
    exec(success, null, PLUGIN_NAME, 'version', []);
};
