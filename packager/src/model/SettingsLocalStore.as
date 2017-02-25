package model {
import flash.events.EventDispatcher;
import flash.net.SharedObject;

public class SettingsLocalStore {
    public static var settings:Object;
    private static var so:SharedObject;

    public static function load(_reset:Boolean = false):void {
        so = SharedObject.getLocal("AIRiOSPackager");
        if (so.data["settings"] == undefined || _reset) {
            settings = new Settings();
            so.data["settings"] = settings;
            so.flush();
        } else {
            settings = so.data["settings"];
        }
    }

    public static function setProp(_key:String, _val:*):void {
        settings[_key] = _val;
        so.data["settings"] = settings;
        so.flush();
    }

    public static function getPropAsString(key:String):String {
        if (settings.hasOwnProperty(key) && settings[key] != null) {
            return settings[key];
        } else {
            return "";
        }
    }
}
}