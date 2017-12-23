import QtQuick 2.0
import QtPositioning 5.3

Item{
    id: geolocationPlugin
    objectName: "geolocationPlugin"
    property variant webview
    property string  callbackID
    property string  errCallbackID

    function getLocation(options) {
        geolocationPlugin.webview = options.webview
        geolocationPlugin.callbackID = options.params.shift()
        geolocationPlugin.errCallbackID = options.params.shift()
        if(!positionSource.active)
            positionSource.start()
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000

        onPositionChanged: {
            var coord = positionSource.position.coordinate;

            var position = {
                latitude: coord.latitude,
                longitude: coord.longitude,
                altitude: coord.altitude,
                accuracy: coord.horizontalAccuracy,
                altitudeAccuracy: coord.verticalAccuracy,
                speed: coord.speed,
                heading: -1,
                timestamp: new Date()
            }
            console.log("position:"+JSON.stringify(position))
            geolocationPlugin.webview.experimental.evaluateJavaScript("cordova.callback(%1,%2)".arg(geolocationPlugin.callbackID).arg(JSON.stringify(position)));
            positionSource.stop()
        }
    }
}
