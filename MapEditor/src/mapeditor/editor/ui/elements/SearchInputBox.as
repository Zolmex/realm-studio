package mapeditor.editor.ui.elements {
import common.ui.TextureParser;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

public class SearchInputBox extends Sprite {

    public var inputText:SimpleText;
    private var background:Bitmap;
    private var inputTextStr:String;

    public function SearchInputBox(width:int, height:int, textSize:int, inputText:String = "", inputColor:uint = 0xFFFFFF) {
        this.background = TextureParser.instance.getTexture("UI", "search_input_background");
        addChild(this.background);
        this.inputTextStr = inputText;
        this.inputText = new SimpleText(textSize, inputColor, true, width, height, false, true);
        this.inputText.text = inputText;
        this.inputText.setAutoSize(TextFieldAutoSize.LEFT);
        this.inputText.border = false;
        this.inputText.updateMetrics();
        this.inputText.x = 2;
        this.inputText.y = (this.background.height - this.inputText.height) / 2;
        this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addChild(this.inputText);
    }

    private function onAddedToStage(e:Event):void {
        stage.addEventListener(MouseEvent.CLICK, this.onClick);
    }

    private function onClick(e:Event):void {
        var inputClick:Boolean = e.target == this.inputText;
        if (inputClick) {
            if (this.inputText.text == this.inputTextStr) {
                this.inputText.text = "";
            }
        }
        else if (this.inputText.text == "") {
            this.inputText.text = this.inputTextStr;
        }
    }
}
}
