import QtQuick 2.0
import QtSystemInfo 5.0

Item {
    id: batteryPlugin
    objectName: "batteryPlugin"


//    BatteryInfo{
//        id: battery
//    }
    Item{
        id: battery
        function remainingCapacity(offset){
            return 1;
        }

        function maximumCapacity(offset){
            return 100;
        }

        function chargingState(offset){
            return "unknown";
        }
    }

    function start(options) {
        var webView = options.webview
        var callbackID = options.params.shift()
        var errCallbackID = options.params.shift()
        var result = {
            level: (battery.remainingCapacity(0) / battery.maximumCapacity(0) * 100).toFixed(0),
            isPlugged: battery.chargingState(0) === "Charging" /*BatteryInfo.Charging*/
        }
        webView.experimental.evaluateJavaScript("cordova.callback(%1,%2)".arg(callbackID).arg(JSON.stringify(result)));
    }
}
