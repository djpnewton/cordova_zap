cordova.define("com.djpsoft.zap.plugin.zap", function(require, exports, module) {
var exec = require('cordova/exec');

var PLUGIN_NAME = 'zap';

exports.version = function (success, error) {
    exec(success, null, PLUGIN_NAME, 'version', []);
};

exports.mnemonicCreate = function (success, error) {
    exec(success, error, PLUGIN_NAME, 'mnemonicCreate', []);
};

exports.mnemonicCheck = function (arg0, success, error) {
    exec(success, error, PLUGIN_NAME, 'mnemonicCheck', [arg0]);
};

exports.seedToAddress = function (arg0, success, error) {
    exec(success, error, PLUGIN_NAME, 'seedToAddress', [arg0]);
};

exports.addressBalance = function (arg0, success, error) {
    exec(success, error, PLUGIN_NAME, 'addressBalance', [arg0]);
};

exports.addressTransactions = function (arg0, arg1, success, error) {
    exec(success, error, PLUGIN_NAME, 'addressTransactions', [arg0, arg1]);
};

exports.transactionCreate = function (arg0, arg1, arg2, arg3, success, error) {
    exec(success, error, PLUGIN_NAME, 'transactionCreate', [arg0, arg1, arg2, arg3]);
};

exports.transactionBroadcast = function (arg0, success, error) {
    exec(success, error, PLUGIN_NAME, 'transactionBroadcast', [arg0]);
};

});
