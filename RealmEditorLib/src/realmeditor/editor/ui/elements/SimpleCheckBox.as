package realmeditor.editor.ui.elements {
import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

import realmeditor.editor.ui.Constants;
import realmeditor.editor.ui.embed.SliceScalingBitmap;
import realmeditor.editor.ui.embed.TextureParser;

public class SimpleCheckBox extends Sprite {

    private static const WIDTH:int = 95;
    private static const HEIGHT:int = CHECKBOX_HEIGHT + 8;
    private static const CHECKBOX_WIDTH:int = 23;
    private static const CHECKBOX_HEIGHT:int = 15;

    public var value:Boolean;
    private var background:SliceScalingBitmap;
    private var title:SimpleText;
    private var enabledIcon:Sprite;
    private var disabledIcon:Sprite;
    private var content:Sprite;

    public function SimpleCheckBox(title:String, defaultValue:Boolean = false) {
        this.value = defaultValue;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "switch_button_background");
        this.background.alpha = 0.9;
        addChild(this.background);

        this.content = new Sprite();
        addChild(this.content);

        this.title = new SimpleText(14, 0xB9A960, false, WIDTH - CHECKBOX_WIDTH - 7);
        this.title.setAutoSize(TextFieldAutoSize.LEFT);
        this.title.setText(title);
        this.title.filters = Constants.SHADOW_FILTER_1;
        this.title.updateMetrics();
        this.content.addChild(this.title);

        var enabled:Bitmap = TextureParser.instance.getTexture("UI", "enabled_icon");
        this.enabledIcon = new Sprite();
        this.enabledIcon.addChild(enabled);
        this.enabledIcon.scaleX = CHECKBOX_WIDTH / this.enabledIcon.width;
        this.enabledIcon.scaleY = CHECKBOX_HEIGHT / this.enabledIcon.height;
        this.enabledIcon.visible = defaultValue;
        this.content.addChild(this.enabledIcon);

        var disabled:Bitmap = TextureParser.instance.getTexture("UI", "disabled_icon");
        this.disabledIcon = new Sprite();
        this.disabledIcon.addChild(disabled);
        this.disabledIcon.scaleX = this.enabledIcon.scaleX;
        this.disabledIcon.scaleY = this.enabledIcon.scaleY;
        this.disabledIcon.visible = !defaultValue;
        this.content.addChild(this.disabledIcon);

        this.positionChildren();
        this.drawBackground();

        if (!defaultValue) {
            this.disabledIcon.addEventListener(MouseEvent.CLICK, this.onClick);
        }
        else {
            this.enabledIcon.addEventListener(MouseEvent.CLICK, this.onClick);
        }
    }

    public function setValue(value:Boolean):void {
        this.value = value;
        this.enabledIcon.visible = value;
        this.disabledIcon.visible = !value;
        if (this.enabledIcon.visible){
            this.disabledIcon.removeEventListener(MouseEvent.CLICK, this.onClick);
            this.enabledIcon.addEventListener(MouseEvent.CLICK, this.onClick);
        }
        else{
            this.enabledIcon.removeEventListener(MouseEvent.CLICK, this.onClick);
            this.disabledIcon.addEventListener(MouseEvent.CLICK, this.onClick);
        }
    }

    private function onClick(e:Event):void {
        this.value = !this.value;
        this.enabledIcon.visible = this.value;
        this.disabledIcon.visible = !this.value;
        if (this.enabledIcon.visible){
            this.disabledIcon.removeEventListener(MouseEvent.CLICK, this.onClick);
            this.enabledIcon.addEventListener(MouseEvent.CLICK, this.onClick);
        }
        else{
            this.enabledIcon.removeEventListener(MouseEvent.CLICK, this.onClick);
            this.disabledIcon.addEventListener(MouseEvent.CLICK, this.onClick);
        }

        this.dispatchEvent(new Event(Event.CHANGE));
    }

    private function positionChildren():void {
        this.title.x = 2;
        this.title.y = (HEIGHT - this.title.actualHeight_) / 2;

        this.enabledIcon.x = this.title.x + this.title.actualWidth_ + 5;
        this.enabledIcon.y = (HEIGHT - this.enabledIcon.height) / 2;
        this.disabledIcon.x = this.enabledIcon.x;
        this.disabledIcon.y = this.enabledIcon.y;
    }

    private function drawBackground():void {
        this.background.width = this.content.width + 6;
        this.background.height = HEIGHT;
    }
}
}
