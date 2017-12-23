/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0
import io.thp.pyotherside 1.4
import "../plugins"
import "../plugins_manager.js" as PluginsManager

Page {
    id: cordovaPage

    Python{
        id:scnner
        signal started();
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../py'));
            setHandler("started", started)
            scnner.importModule('main',function () {
                scnner.startScan();
            });


        }

        function startScan(){
            scnner.call('main.scanPort',[port],function(result){
            });
        }

        onStarted: {
            var url = "http://127.0.0.1:"+ port + "/index.html";
            webView.url = url;
            busy.running = false;
            webView.visible = true;
        }

    }


    BusyIndicator {
        id: busy
        running: true
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
    }



    SilicaWebView {
        id: webView
        anchors.fill: parent
        visible: false
        // Set preferences
        experimental.preferences.developerExtrasEnabled: true
        experimental.preferences.navigatorQtObjectEnabled: true
        experimental.preferences.localStorageEnabled: true
        experimental.preferences.offlineWebApplicationCacheEnabled: true
        experimental.preferences.universalAccessFromFileURLsAllowed: true
        experimental.preferences.webGLEnabled: true
        experimental.transparentBackground: true


        // Listen to messages from JS
        experimental.onMessageReceived: {
            var msg = JSON.parse(message.data);
//            console.log("WebView received Message: " + JSON.stringify(msg))
            var func = msg.func;
            var p = PluginsManager.PluginsManager.plugin(msg.plugin);
            if(p[func]) {
                p[func].call(this,{webview: webView, params: msg.params});
            } else {
                console.error("No such function ", msg.func, " in plugin ", msg.plugin)
            }
        }
    }

    Component.onCompleted: {
        PluginsManager.page = cordovaPage;
        for(var i = 0;i<PluginsManager.plugins.length; i++){
            PluginsManager.PluginsManager.addPlugin(PluginsManager.plugins[i]);
        }
    }
}


