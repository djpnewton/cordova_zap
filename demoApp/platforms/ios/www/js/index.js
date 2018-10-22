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

    showSpinner: function() {
        var ele = document.getElementById("spinner");
        ele.setAttribute('style', 'display:block;');
    },

    hideSpinner: function() {
        var ele = document.getElementById("spinner");
        ele.setAttribute('style', 'display:none;');
    },

    stringifyAndPre: function(obj) {
        return "<pre>" + JSON.stringify(obj, null, 2) + "</pre>";
    },

    clear: function() {
        var self = this;

        var zaplog = document.getElementById("zaplog");
        zaplog.innerHTML = "";
    },

    mainnet: function() {
        var self = this;

        self.addSection("setting mainnet in libzap...");
        cordova.plugins.zap.networkSet("W", function(result) {
            self.addSection("network set: " + result);
        });
    },

    runTests: function() {
        var self = this;

        self.showSpinner();

        self.addSection("calling libzap...");
        cordova.plugins.zap.version(function(version) {
            self.addSection("version: " + version);
        });
        cordova.plugins.zap.nodeGet(function(url) {
            self.addSection("node: " + url);
            cordova.plugins.zap.nodeSet(url, function() {
                self.addSection("node set: success");
            });
        });
        cordova.plugins.zap.networkGet(function(network) {
            self.addSection("network: " + network);
            cordova.plugins.zap.networkSet(network, function() {
                self.addSection("network set: success");
            });
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
        cordova.plugins.zap.mnemonicWordlist(function(words) {
            self.addSection("word list: " + words[0] + ".." + words[words.length-1] + " (" + words.length + ")");
        });
        cordova.plugins.zap.networkGet(function(network) {
            var uri = "waves://3MpkEPnU3KkDYkFGwivUn2psMQo74MX4fyJ?asset=CgUrFtinLXEbJwJVjwwcppk4Vpz1nMmR3H5cQaDcUcfe&amount=10&attachment=hi there";
            if (network == "W")
                uri = "waves://3PCY824X11eqRAZWVUAw1JAvzKxovY6FoiA?asset=9R3iLi4qGLVWKc16Tg98gmRvgg1usGEYd7SgC1W5D6HB&amount=10&attachment=hi there";
            cordova.plugins.zap.uriParse(uri, function(result) {
                self.addSection("uri parse: " + uri + self.stringifyAndPre(result));
            },
            function(err) {
                self.addSection("uri parse error: " + uri + self.stringifyAndPre(err));
            });
        },
        function(err) {
            self.addSection("network get error: " + self.stringifyAndPre(err));
        });

        var uri2 = "invalid_uri";
        cordova.plugins.zap.uriParse(uri2, function(result) {},
            function(err) {
                self.addSection("uri parse error: " + uri2 + self.stringifyAndPre(err));
            });
        cordova.plugins.zap.seedAddress("daniel", function(address) {
            self.addSection("address: " + address);
            cordova.plugins.zap.addressCheck(address, function(check) {
                self.addSection("addr check: " + check);
            },
            function(err) {
                self.addSection("addr check error: " + self.stringifyAndPre(err));
            });
            cordova.plugins.zap.addressBalance(address, function(balance) {
                self.addSection("balance: " + balance);
            },
            function(err) {
                self.addSection("balance error: " + self.stringifyAndPre(err));
            });
            cordova.plugins.zap.addressTransactions(address, 3, function(txs) {
                self.addSection("<div id='txs'>transactions: " + txs.length + "</div>");
                for (var i = 0; i < txs.length; i++) {
                    self.addSubSection(self.stringifyAndPre(txs[i]), "txs");
                    self.hideSpinner();
                }
            },
            function(err) {
                self.addSection("transactions error: " + self.stringifyAndPre(err));
                self.hideSpinner();
            });
        });
        self.addSection("called libzap.");
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        var self = this;

        self.receivedEvent('deviceready');
        self.hideSpinner();

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
                        var str = "broadcast tx: " + self.stringifyAndPre(result);
                        self.addSection(str);
                    },
                    function(err) {
                        self.addSection("broadcast tx error: " + self.stringifyAndPre(err));
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

        var scanbtn = document.getElementById("scanbtn");
        scanbtn.onclick = function() {
            var callback = function(err, contents){
                if(err){
                    console.error(err._message);
                }
                cordova.plugins.zap.uriParse(contents,
                    function(result) {
                        document.getElementById("address").value = result.address;
                        document.getElementById("amount").value = result.amount;
                        document.getElementById("attachment").value = result.attachment;
                    },
                    function(err) {
                        self.addSection("uri parse error: " + err + self.stringifyAndPre(err));
                    });
                document.getElementById("app").setAttribute("style", "display:block");
                QRScanner.destroy();
            };
            QRScanner.scan(callback);
            QRScanner.show(function(status){
                document.getElementById("app").setAttribute("style", "display:none");
                console.log(status);
            });
        };

        var clearbtn = document.getElementById("clearbtn");
        clearbtn.onclick = function() {
            self.clear();
        };

        var mainnetbtn = document.getElementById("mainnetbtn");
        mainnetbtn.onclick = function() {
            self.mainnet();
        };

        var testbtn = document.getElementById("testbtn");
        testbtn.onclick = function() {
            self.runTests();
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
