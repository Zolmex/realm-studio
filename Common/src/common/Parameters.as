package common {
import flash.net.SharedObject;

public class Parameters {

    private static var sharedObj:SharedObject;
    public static var data:Object;

    public static function load():void {
        try {
            sharedObj = SharedObject.getLocal("RealmEditorSettings", "/");
            data = sharedObj.data;
        }
        catch (error:Error) {
            trace("WARNING: unable to save settings");
            data = {};
        }
        setDefaults();
        save();
    }

    public static function save():void {
        try {
            if (sharedObj) {
                sharedObj.flush();
            }
        }
        catch (error:Error) {
        }
    }

    private static function setDefaults():void {
    }
}
}
