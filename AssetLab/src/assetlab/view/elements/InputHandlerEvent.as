package assetlab.view.elements {
import flash.events.Event;

public class InputHandlerEvent extends Event {

    public var value:Object;

    public function InputHandlerEvent(eventType:String, value:Object = null) {
        super(eventType);
        this.value = value;
    }
}
}
