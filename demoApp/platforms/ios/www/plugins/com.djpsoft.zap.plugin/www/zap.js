cordova.define("com.djpsoft.zap.plugin.zap", function(require, exports, module) {
var exec = require('cordova/exec');

var PLUGIN_NAME = 'zap';

exports.version = function (success, error) {
    exec(success, null, PLUGIN_NAME, 'version', []);
};

exports.nodeGet = function (success, error) {
    exec(success, null, PLUGIN_NAME, 'nodeGet', []);
};

exports.nodeSet = function (url, success, error) {
    exec(success, null, PLUGIN_NAME, 'nodeSet', [url]);
};

exports.networkGet = function (success, error) {
    exec(success, null, PLUGIN_NAME, 'networkGet', []);
};

exports.networkSet = function (network_byte, success, error) {
    exec(success, null, PLUGIN_NAME, 'networkSet', [network_byte]);
};

exports.mnemonicCreate = function (success, error) {
    exec(success, error, PLUGIN_NAME, 'mnemonicCreate', []);
};

exports.mnemonicCheck = function (mnemonic, success, error) {
    exec(success, error, PLUGIN_NAME, 'mnemonicCheck', [mnemonic]);
};

exports.mnemonicWordlist = function (success, error) {
    exec(success, error, PLUGIN_NAME, 'mnemonicWordlist', []);
};

exports.seedAddress = function (seed, success, error) {
    exec(success, error, PLUGIN_NAME, 'seedAddress', [seed]);
};

exports.addressCheck = function (address, success, error) {
    exec(success, error, PLUGIN_NAME, 'addressCheck', [address]);
};

exports.addressBalance = function (address, success, error) {
    exec(success, error, PLUGIN_NAME, 'addressBalance', [address]);
};

exports.addressTransactions = function (address, limit, success, error) {
    exec(success, error, PLUGIN_NAME, 'addressTransactions', [address, limit]);
};

exports.transactionFee = function (success, error) {
    exec(success, null, PLUGIN_NAME, 'transactionFee', []);
};

exports.transactionCreate = function (seed, recipient, amount, fee, attachment, success, error) {
    exec(success, error, PLUGIN_NAME, 'transactionCreate', [seed, recipient, amount, fee, attachment]);
};

exports.transactionBroadcast = function (tx, success, error) {
    exec(success, error, PLUGIN_NAME, 'transactionBroadcast', [tx]);
};

exports.uriParse = function (uri, success, error) {
    exec(success, error, PLUGIN_NAME, 'uriParse', [uri]);
};


});
