import QtQuick 2.0
import org.freedesktop.contextkit 1.0


Item {
    id: batteryPlugin
    objectName: "batteryPlugin"

    QtObject {
        id: battery
        property int chargePercentage: 0
        property bool isCharging: false
    }

    ContextProperty {
        id: batteryChargePercentageContextProperty
        key: "Battery.ChargePercentage"
        onValueChanged: battery.chargePercentage = value
    }

    ContextProperty {
        id: batteryIsChargingContextProperty
        key: "Battery.IsCharging"
        onValueChanged: battery.isCharging = value
    }



    function start(options) {
        var webView = options.webview
        var callbackID = options.params.shift()
        var errCallbackID = options.params.shift()
        var result = {
            level: battery.chargePercentage,
            isPlugged: battery.isCharging
        }
        webView.experimental.evaluateJavaScript("cordova.callback(%1,%2)".arg(callbackID).arg(JSON.stringify(result)));
    }
}
