package mapeditor.editor.ui.elements {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mapeditor.editor.ui.Constants;
import mapeditor.editor.ui.MainView;

public class Tooltip extends Sprite {

    private var target:DisplayObject;
    private var background:SliceScalingBitmap;

    // Tooltips should always be instantiated on roll over
    public function Tooltip(target:DisplayObject) {
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "maplist_element_background");
        addChild(this.background);

        this.target = target;
        target.addEventListener(MouseEvent.ROLL_OUT, this.onTargetOut);
        target.addEventListener(MouseEvent.ROLL_OVER, this.onTargetOver);
        target.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);

        this.addChildren();
        this.positionChildren();
        this.drawBackground();
        this.fixPosition();

        filters = Constants.SHADOW_FILTER_1;
    }

    private function onTargetOver(e:Event):void {
        this.target.addEventListener(MouseEvent.ROLL_OUT, this.onTargetOut);
        this.target.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        this.fixPosition();
        this.visible = true;
    }

    private function onTargetOut(e:Event):void {
        this.target.removeEventListener(MouseEvent.ROLL_OUT, this.onTargetOut);
        this.target.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        this.visible = false;
    }

    private function onEnterFrame(e:Event):void {
        this.fixPosition();
    }

    protected virtual function addChildren():void {
    }

    protected virtual function positionChildren():void {
    }

    protected virtual function drawBackground():void {
        this.background.width = width + 10;
        this.background.height = height + 10;
        this.background.alpha = 0.8;
    }

    protected function updateChildren():void {
        this.addChildren();
        this.positionChildren();
        this.drawBackground();
    }

    public function fixPosition():void {
        this.x = this.getXPos();
        this.y = this.getYPos();
    }

    private function getXPos():Number {
        var limitWidth:Number = width + 1;
        var mouseX:Number = MainView.Main.stage.mouseX;
        if (mouseX < MainView.StageWidth / 2) { // Center orientation: right
            if (mouseX < 0) { // Left limit
                return 0;
            }
            if (mouseX + limitWidth > MainView.StageWidth) { // When tooltip touches screen right
                return MainView.StageWidth - limitWidth;
            }
            return mouseX;
        }

        if (mouseX >= MainView.StageWidth / 2) { // Center orientation: left
            if (mouseX > MainView.StageWidth) { // Right limit
                return MainView.StageWidth - limitWidth;
            }
            if (mouseX - limitWidth < 0) { // When tooltip touches screen left
                return 0;
            }
            return mouseX - limitWidth;
        }
        return mouseX;
    }

    private function getYPos():Number {
        var limitHeight:Number = height + 1;
        var mouseY:Number = MainView.Main.stage.mouseY;
        if (mouseY < MainView.StageHeight / 2) { // Center orientation: up
            if (mouseY < 0) { // Top limit
                return 0;
            }
            if (mouseY + limitHeight > MainView.StageHeight) { // When tooltip touches screen bottom
                return MainView.StageHeight - limitHeight;
            }
            return mouseY;
        }

        if (mouseY >= MainView.StageHeight / 2) { // Center orientation: left
            if (mouseY > MainView.StageHeight) { // Right limit
                return MainView.StageHeight - limitHeight;
            }
            if (mouseY - limitHeight < 0) { // When tooltip touches screen top
                return 0;
            }
            return mouseY - limitHeight;
        }
        return mouseY;
    }
}
}
