package realmeditor.editor.ui {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

import realmeditor.editor.ui.elements.SimpleText;
import realmeditor.util.BitmapUtil;

public class TileHotkeyElement extends Sprite {

    private var hotkeyText:SimpleText;
    private var texture:Bitmap;
    public var number:int;
    public var objType:int;
    public var drawType:int;

    public function TileHotkeyElement(number:int, objType:int, drawType:int, texture:BitmapData) {
        this.number = number;
        this.objType = objType;
        this.drawType = drawType;
        var scaled:BitmapData = BitmapUtil.scale(texture, 2);
        this.texture = new Bitmap(scaled);
        addChild(this.texture);
        this.hotkeyText = new SimpleText(10, 0xFFFFFF);
        this.hotkeyText.setText(number.toString());
        this.hotkeyText.setBold(true);
        this.hotkeyText.filters = Constants.SHADOW_FILTER_1;
        this.hotkeyText.useTextDimensions();
        this.hotkeyText.x = this.texture.width / 2 - this.hotkeyText.width / 2;
        this.hotkeyText.y = this.texture.height / 2 - this.hotkeyText.height / 2;
        addChild(this.hotkeyText);
    }
}
}