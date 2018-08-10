var exec = require('cordova/exec');

var PLUGIN_NAME = 'zap';

exports.version = function (success, error) {
    exec(success, null, PLUGIN_NAME, 'version', []);
};

exports.mnemonicCreate = function (success, error) {
    exec(success, error, PLUGIN_NAME, 'mnemonicCreate', []);
};

exports.mnemonicCheck = function (mnemonic, success, error) {
    exec(success, error, PLUGIN_NAME, 'mnemonicCheck', [mnemonic]);
};

exports.seedAddress = function (seed, success, error) {
    exec(success, error, PLUGIN_NAME, 'seedAddress', [seed]);
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
