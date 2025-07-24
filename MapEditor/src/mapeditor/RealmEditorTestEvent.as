package mapeditor {
import flash.events.Event;

public class RealmEditorTestEvent extends Event {

    public var mapJSON_:String;
    public static const TEST_CONNECT:String = "TestConnect";

    public function RealmEditorTestEvent(mapJSON:String) {
        super(TEST_CONNECT);
        this.mapJSON_ = mapJSON;
    }
}
}
