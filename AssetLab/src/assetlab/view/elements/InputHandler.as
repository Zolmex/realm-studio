package assetlab.view.elements {
import common.Global;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.Dictionary;

public class InputHandler extends EventDispatcher {

    public static const MOUSE_DRAG:String = "InputMouseDrag";
    public static const MOUSE_DRAG_END:String = "InputMouseDragEnd";
    public static const MIDDLE_MOUSE_DRAG:String = "InputMiddleMouseDrag";
    public static const MIDDLE_MOUSE_DRAG_END:String = "InputMiddleMouseDragEnd";
    public static const RIGHT_MOUSE_DRAG:String = "InputRightMouseDrag";
    public static const RIGHT_MOUSE_DRAG_END:String = "InputRightMouseDragEnd";

    private var INPUT_TO_LISTENER:Object;

    private var owner:DisplayObject;
    private var dragging:Boolean;
    private var mouseDown:Boolean;
    private var lastMousePos:Point;
    private var mouseDelta:Point = new Point();
    private var functionCache:Dictionary = new Dictionary();

    public function InputHandler(owner:DisplayObject) {
        this.owner = owner;
        this.setup();
    }

    private function setup():void {
        INPUT_TO_LISTENER = {};
        INPUT_TO_LISTENER[MOUSE_DRAG] = this.mouseDragListener; // "END" events are automatically listened to, they don't need the be mapped here
        INPUT_TO_LISTENER[MIDDLE_MOUSE_DRAG] = this.middleMouseDragListener;
        INPUT_TO_LISTENER[RIGHT_MOUSE_DRAG] = this.rightMouseDragListener;
    }

    private function listenToOwner(eventType:String, func:Function, ...args):void {
        const newFunc:Function = function (e:Event):void {
            func(e, args);
        };
        this.functionCache[func] = newFunc;

        this.owner.addEventListener(eventType, newFunc);
    }

    private function removeListener(eventType:String, func:Function):void {
        var funcCache:Function = this.functionCache[func];
        if (funcCache == null){
            return;
        }
        this.owner.removeEventListener(eventType, funcCache);
        delete this.functionCache[func];
    }

    private function mouseDragListener():void {
        this.listenToOwner(MouseEvent.MOUSE_DOWN, this.onMouseDown, MOUSE_DRAG);
        this.mouseDragEndListener();
    }

    private function mouseDragEndListener():void {
        this.listenToOwner(MouseEvent.MOUSE_UP, this.onMouseUp, MOUSE_DRAG_END);
        this.listenToOwner(MouseEvent.ROLL_OUT, this.onRollOut, MOUSE_DRAG_END);
    }

    private function middleMouseDragListener():void {
        this.listenToOwner(MouseEvent.MIDDLE_MOUSE_DOWN, this.onMouseDown, MIDDLE_MOUSE_DRAG);
        this.middleMouseDragEndListener();
    }

    private function middleMouseDragEndListener():void {
        this.listenToOwner(MouseEvent.MIDDLE_MOUSE_UP, this.onMouseUp, MIDDLE_MOUSE_DRAG_END);
        this.listenToOwner(MouseEvent.ROLL_OUT, this.onRollOut, MIDDLE_MOUSE_DRAG_END);
    }

    private function rightMouseDragListener():void {
        this.listenToOwner(MouseEvent.RIGHT_MOUSE_DOWN, this.onMouseDown, RIGHT_MOUSE_DRAG);
        this.rightMouseDragEndListener();
    }

    private function rightMouseDragEndListener():void {
        this.listenToOwner(MouseEvent.RIGHT_MOUSE_UP, this.onMouseUp, RIGHT_MOUSE_DRAG_END);
        this.listenToOwner(MouseEvent.ROLL_OUT, this.onRollOut, RIGHT_MOUSE_DRAG_END);
    }

    private function onMouseDown(e:MouseEvent, eventType:String):void {
        this.dragging = false;
        this.mouseDown = true;
        this.listenToOwner(MouseEvent.MOUSE_MOVE, this.onMouseMove, eventType);
    }

    private function onMouseMove(e:MouseEvent, eventType:String):void {
        if (this.lastMousePos == null) {
            this.lastMousePos = new Point(Global.Main.stage.mouseX, Global.Main.stage.mouseY);
        }

        var deltaX:Number = Global.Main.stage.mouseX - this.lastMousePos.x;
        var deltaY:Number = Global.Main.stage.mouseY - this.lastMousePos.y;
        this.mouseDelta.x = deltaX;
        this.mouseDelta.y = deltaY;
        this.lastMousePos.x = Global.Main.stage.mouseX;
        this.lastMousePos.y = Global.Main.stage.mouseY;

        this.dragging = true;
        this.dispatchEvent(new InputHandlerEvent(eventType, this.mouseDelta));
    }

    private function onMouseUp(e:MouseEvent, eventType:String):void {
        if (this.dragging){
            this.endDrag(eventType);
        }
        this.mouseDown = false;
        this.removeListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
    }

    private function onRollOut(e:MouseEvent, eventType:String):void {
        if (this.dragging){
            this.endDrag(eventType);
        }
        this.mouseDown = false;
        this.removeListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
    }

    private function endDrag(eventType:String):void {
        this.dragging = false;
        this.lastMousePos = null;
        this.dispatchEvent(new InputHandlerEvent(eventType));
    }

    public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);

        var eventListener:Function = INPUT_TO_LISTENER[type];
        if (eventListener != null) {
            eventListener(); // The listener method will add all the necessary events
        }
    }
}
}
