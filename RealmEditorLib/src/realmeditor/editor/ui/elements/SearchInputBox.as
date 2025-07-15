package realmeditor.editor.ui.elements {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextFieldAutoSize;

import realmeditor.editor.ui.embed.TextureParser;

public class SearchInputBox extends Sprite {

    public var inputText:SimpleText;
    private var background:Bitmap;

    public function SearchInputBox(inputText:String = "", inputColor:uint = 0xFFFFFF) {
        this.background = TextureParser.instance.getTexture("UI", "search_input_background");
        addChild(this.background);
        this.inputText = new SimpleText(9, inputColor, true, 154, 15, false, true);
        this.inputText.setAutoSize(TextFieldAutoSize.LEFT);
        this.inputText.border = false;
        this.inputText.text = inputText;
        this.inputText.updateMetrics();
        this.inputText.x = 2;
        this.inputText.y = (this.background.height - this.inputText.height) / 2;
        addChild(this.inputText);
    }
}
}
