package common.ui.elements {
import common.ui.text.SimpleText;

import flash.display.Sprite;

public class SimpleInputBox extends Sprite {

    public var inputText:SimpleText;

    public function SimpleInputBox(width:int, height:int, inputText:String = "", inputSize:int = 18, inputColor:uint = 0xFFFFFF, stopKeyPropagation:Boolean = false) {
        this.inputText = new SimpleText(inputSize, inputColor, true, width, height, false, stopKeyPropagation);
        this.inputText.text = inputText;
        this.inputText.updateMetrics();
        addChild(this.inputText);
    }
}
}
