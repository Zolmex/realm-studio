package mapeditor.editor.ui.elements {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mapeditor.editor.ui.embed.SliceScalingBitmap;
import mapeditor.editor.ui.embed.TextureParser;

public class SimpleScrollbar extends Sprite {

    private var background:SliceScalingBitmap;
    private var maxScroll:Number;
    public var cursorPos:Number;
    private var cursor:Sprite;
    private var cursorBmp:Bitmap;
    private var dragStartY:Number; // Will be used to determine how much the mouse moved, therefore how much to move the scrollbar cursor

    public function SimpleScrollbar() {
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "scrollbar_background");
        addChild(this.background);
        this.cursorBmp = TextureParser.instance.getTexture("UI", "scrollbar_position_icon");
        this.cursor = new Sprite();
        this.cursor.addChild(this.cursorBmp);
        this.cursor.x = (this.background.width - this.cursor.width) / 2;
        this.cursor.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        addChild(this.cursor);
    }

    private function onMouseDown(e:MouseEvent):void {
        this.dragStartY = e.stageY;
        stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
    }

    private function onMouseUp(e:Event):void {
        stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
    }

    private function onMouseMove(e:MouseEvent):void {
        var deltaY:Number = e.stageY - this.dragStartY;
        var dragRatio:Number = deltaY / this.background.height;
        var ratio:Number = Math.min(1, Math.max(0, (this.cursorPos / this.maxScroll) + dragRatio));

        this.cursorPos = ratio * this.maxScroll;
        this.dragStartY += deltaY;
        this.drawCursor();
        dispatchEvent(new Event(Event.CHANGE));
    }

    private function drawCursor():void {
        var ratio:Number = Math.min(1, Math.max(0, this.cursorPos / this.maxScroll));
        this.cursor.y = 2 + (this.background.height - this.cursor.height - 2) * ratio;
    }

    public function setup(height:int, currentScrollPos:Number, maxScroll:Number):void {
        this.background.height = height;
        this.cursorPos = Math.abs(currentScrollPos);
        this.maxScroll = Math.abs(maxScroll);
        this.drawCursor();
    }

    public function update(cursorPos:Number):void {
        this.cursorPos = Math.abs(cursorPos);
        this.drawCursor();
    }
}
}
