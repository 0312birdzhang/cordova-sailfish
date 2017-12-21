var page;
var PluginsManager = {
    plugins: {},
    addPlugin: function(id) {
        var plugin = Qt.createComponent("plugins/"+id+".qml");
        switch(plugin.status) {
        case Component.Ready:
            var pluginObject = plugin.createObject(page);
            this.plugins[id] = pluginObject;
            break;
        case Component.Loading:
            console.log("loading plugin ",id)
            break;
        case Component.Error:
            console.error("Error loading plugin ",id, plugin.errorString())
            break;
        }
    },

    plugin: function(id) {
        return this.plugins[id]
    }
}

var plugins = ["Device",
                "Vibration",
                "NetworkStatus",
                "Compass",
                "Battery",
                "Notification",
                "Accelerometer",
                "InAppBrowser",
                "Geolocation",
                "Camera",
                "Contacts" ];
