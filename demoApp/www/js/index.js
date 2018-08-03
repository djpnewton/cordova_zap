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

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');

        var zapElement = document.getElementById("zaplog");
        zapElement.innerHTML += "calling libzap...<br/>";
        cordova.plugins.zap.version(function(version) {
            zapElement.innerHTML += "version: " + version + "<br/>";
        });
        cordova.plugins.zap.mnemonicCreate(function(mnemonic) {
            zapElement.innerHTML += "mnemonic: " + mnemonic + "<br/>";
            cordova.plugins.zap.mnemonicCheck(mnemonic, function(mnemonic_ok) {
                zapElement.innerHTML += "mnemonic check: " + mnemonic_ok + "<br/>";
            },
            function(err) {
                zapElement.innerHTML += "mnemonic error: " + err + "<br/>";
            });
        });
        cordova.plugins.zap.seedToAddress("daniel", function(address) {
            zapElement.innerHTML += "address: " + address + "<br/>";
            cordova.plugins.zap.addressBalance(address, function(balance) {
                zapElement.innerHTML += "balance: " + balance + "<br/>";
            },
            function(err) {
                zapElement.innerHTML += "balance error: " + err + "<br/>";
            });
            cordova.plugins.zap.addressTransactions(address, 10, function(txs) {
                zapElement.innerHTML += "transactions: " + txs.length + "<br/>";
                for (var i = 0; i < txs.length; i++) {
                    zapElement.innerHTML += "    id: " + txs[i].id + "<br/>";
                    zapElement.innerHTML += "    sender: " + txs[i].sender + "<br/>";
                    zapElement.innerHTML += "    recipient: " + txs[i].recipient + "<br/>";
                    zapElement.innerHTML += "    asset_id: " + txs[i].asset_id + "<br/>";
                    zapElement.innerHTML += "    fee_asset: " + txs[i].fee_asset + "<br/>";
                    zapElement.innerHTML += "    attachment: " + txs[i].attachment + "<br/>";
                    zapElement.innerHTML += "    amount: " + txs[i].amount + "<br/>";
                    zapElement.innerHTML += "    fee: " + txs[i].fee + "<br/>";
                    zapElement.innerHTML += "    timestamp: " + txs[i].timestamp + "<br/>";
                }
            },
            function(err) {
                zapElement.innerHTML += "transactions error: " + err + "<br/>";
            });
        });
        zapElement.innerHTML += "called libzap.<br/>";
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
