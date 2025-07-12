package {

import flash.display.Sprite;
import flash.text.TextField;

public class Main extends Sprite {
    public function Main() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);
    }
}
}
