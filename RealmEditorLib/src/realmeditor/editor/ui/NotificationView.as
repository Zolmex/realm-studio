package realmeditor.editor.ui {
import com.gskinner.motion.GTween;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import realmeditor.editor.ui.elements.SimpleText;
import realmeditor.editor.ui.embed.SliceScalingBitmap;
import realmeditor.editor.ui.embed.TextureParser;

public class NotificationView extends Sprite {

    private var background:SliceScalingBitmap;
    private var text:SimpleText;
    private var tween:GTween;

    public function NotificationView() {
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "tooltip_header_background");
        this.background.alpha = 0.8;
        this.background.x = -4;
        this.background.y = -4;
        addChild(this.background);

        this.text = new SimpleText(18, 0xFFFFFF, false, 400);
        this.text.filters = Constants.SHADOW_FILTER_1;
        addChild(this.text);

        visible = false;
        filters = Constants.SHADOW_FILTER_1;

        addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
    }

    public function showNotification(text:String, size:int = 18, duration:Number = 2):void {
        this.text.setSize(size);
        this.text.text = text;
        this.text.multiline = true;
        this.text.wordWrap = true;
        this.text.updateMetrics();

        this.background.width = this.text.actualWidth_ + 6;
        this.background.height = this.text.actualHeight_ + 4;

        this.updatePosition();

        this.startAnimation(duration);
    }

    public function updatePosition():void {
        this.x = (MainView.StageWidth - this.background.width) / 2;
        this.y = 60;
    }

    private function startAnimation(duration:Number):void {
        if (this.tween != null){
            this.tween.end();
        }

        alpha = 1;
        visible = true;
        if (duration == -1){ // Infinite, must manually clear notification
            return;
        }

        this.tween = new GTween(this, duration, {"alpha": 0});
        this.tween.onComplete = this.endAnimation;
    }

    private function endAnimation(tween:GTween):void {
        alpha = 1;
        visible = false;
    }

    public function clear():void {
        alpha = 1;
        visible = false;
    }

    private function onRollOver(e:Event):void{
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        this.tween.paused = true;
    }

    private function onRollOut(e:Event):void {
        removeEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        this.tween.paused = false;
    }
}
}
