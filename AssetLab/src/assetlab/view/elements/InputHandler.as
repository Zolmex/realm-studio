package assetlab.view.elements {
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

public class InputHandler extends EventDispatcher {

    public static const MOUSE_DRAG:String = "InputMouseDrag";
    public static const MOUSE_DRAG_END:String = "InputMouseDragEnd";

    private static var INPUT_TO_LISTENER:Object;

    private var owner:DisplayObject;
    private var dragging:Boolean;
    private var mouseDown:Boolean;

    public function InputHandler(owner:DisplayObject) {
        if (INPUT_TO_LISTENER == null){
            this.setup();
        }

        this.owner = owner;
    }

    private function setup():void {
        INPUT_TO_LISTENER = {};
        INPUT_TO_LISTENER[MOUSE_DRAG] = this.mouseDragListener;
        INPUT_TO_LISTENER[MOUSE_DRAG_END] = this.mouseDragEndListener;
    }

    private function mouseDragListener():void {
        this.owner.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
    }

    private function mouseDragEndListener():void {
        this.owner.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        this.owner.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    private function onMouseDown(e:MouseEvent):void {
        this.dragging = false;
        this.mouseDown = true;
        this.owner.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
    }

    private function onMouseUp(e:MouseEvent):void {
        if (this.dragging){
            this.dragging = false;
            this.dispatchEvent(new Event(MOUSE_DRAG_END));
        }
        this.owner.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
    }

    private function onMouseMove(e:MouseEvent):void {
        this.dragging = true;
        this.dispatchEvent(new Event(MOUSE_DRAG));
    }

    private function onRollOut(e:MouseEvent):void {
        if (this.dragging){
            this.dragging = false;
            this.dispatchEvent(new Event(MOUSE_DRAG_END));
        }
        this.owner.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
    }

    public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);

        var eventListener:Function = INPUT_TO_LISTENER[type];
        eventListener(); // The listener method will add all the necessary events
    }
}
}
