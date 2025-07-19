package realmeditor.editor.ui.elements {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

import realmeditor.editor.ui.Constants;
import realmeditor.editor.ui.embed.SliceScalingBitmap;
import realmeditor.editor.ui.embed.TextureParser;

public class SimpleTextInput extends Sprite {

    private var background:SliceScalingBitmap;
    private var titleText:SimpleText;
    public var inputText:SimpleText;
    private var content:Sprite;

    public function SimpleTextInput(title:String, horizontal:Boolean = false, inputText:String = "", titleSize:int = 13, titleColor:uint = 0xB2B2B2, inputSize:int = 13, inputColor:uint = 0x777777, stopKeyPropagation:Boolean = false) {
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "switch_button_background");
        this.background.alpha = 0.9;
        addChild(this.background);

        this.content = new Sprite();
        addChild(this.content);

        this.titleText = new SimpleText(titleSize, titleColor);
        this.titleText.x = 2;
        this.titleText.y = 2;
        this.titleText.text = title;
        this.titleText.filters = Constants.SHADOW_FILTER_1;
        this.titleText.updateMetrics();
        this.content.addChild(this.titleText);

        this.inputText = new SimpleText(inputSize, inputColor, true, this.titleText.textWidth, this.titleText.textHeight, false, stopKeyPropagation);
        this.inputText.text = inputText;
        if (horizontal){
            this.inputText.x = this.titleText.x + this.titleText.width;
            this.inputText.y = this.titleText.y + (this.titleText.height - this.inputText.height) / 2;
        }
        else {
            this.inputText.x = this.titleText.x;
            this.inputText.y = this.titleText.y + this.titleText.height;
        }
        this.inputText.border = false;
        this.inputText.updateMetrics();
        this.content.addChild(this.inputText);

        this.drawBackground();
    }

    public function setWidth(newWidth:int):void {
        this.inputText.inputWidth_ = newWidth;
        this.inputText.updateMetrics();

        this.drawBackground();
    }

    private function drawBackground():void {
        this.background.width = this.content.width + 5;
        this.background.height = this.content.height + 5;
    }
}
}
