/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    addSection: function(str) {
        var zaplog = document.getElementById("zaplog");
        zaplog.innerHTML += "<div class='zapsection'>" + str + "</div>";
    },

    addSubSection: function(str, id) {
        var ele = document.getElementById(id);
        ele.innerHTML += "<div class='zapsubsection'>" + str + "</div>";
    },

    hideSpinner: function() {
        var ele = document.getElementById("spinner");
        ele.setAttribute('style', 'display:none;');
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        var self = this;

        self.receivedEvent('deviceready');

        self.addSection("calling libzap...");
        cordova.plugins.zap.version(function(version) {
            self.addSection("version: " + version);
        });
        cordova.plugins.zap.mnemonicCreate(function(mnemonic) {
            self.addSection("mnemonic: " + mnemonic);
            cordova.plugins.zap.mnemonicCheck(mnemonic, function(mnemonic_ok) {
                self.addSection("mnemonic check: " + mnemonic_ok);
            },
            function(err) {
                self.addSection("mnemonic error: " + err);
            });
        });
        cordova.plugins.zap.seedAddress("daniel", function(address) {
            self.addSection("address: " + address);
            cordova.plugins.zap.addressBalance(address, function(balance) {
                self.addSection("balance: " + balance);
            },
            function(err) {
                self.addSection("balance error: " + err);
            });
            cordova.plugins.zap.addressTransactions(address, 10, function(txs) {
                self.addSection("<div id='txs'>transactions: " + txs.length + "</div>");
                for (var i = 0; i < txs.length; i++) {
                    var str = "<pre>" + JSON.stringify(txs[i], null, 2) + "</pre>";
                    self.addSubSection(str, "txs");
                    self.hideSpinner();
                }
            },
            function(err) {
                self.addSection("transactions error: " + err);
                self.hideSpinner();
            });
        });
        self.addSection("called libzap.");
        var sendbtn = document.getElementById("sendbtn");
        sendbtn.onclick = function() {
            var seed = document.getElementById("seed").value;
            var address = document.getElementById("address").value;
            var amount = parseInt(document.getElementById("amount").value);
            var attachment = document.getElementById("attachment").value;
            cordova.plugins.zap.transactionFee(function(fee) {
                cordova.plugins.zap.transactionCreate(seed, address, amount, fee, attachment, function(tx) {
                    self.addSection("created tx: " + tx.data + " - " + tx.signature);
                    cordova.plugins.zap.transactionBroadcast(tx, function(result) {
                        var str = "broadcast tx: <pre>" + JSON.stringify(result, null, 2) + "</pre>";
                        self.addSection(str);
                    },
                    function(err) {
                        self.addSection("broadcast tx: " + err);
                    });
                },
                function(err) {
                    self.addSection("create tx: " + err);
                });
            },
            function(err) {
                self.addSection("fee: " + err);
            });
        };
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

app.initialize();
