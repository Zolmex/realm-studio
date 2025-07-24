package mapeditor.editor.ui.elements {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mapeditor.assets.AssetLibrary;
import mapeditor.editor.ui.Constants;
import mapeditor.util.FilterUtil;

public class ChoiceElement extends Sprite {

    public var value:Object;
    public var title:String;
    public var iconId:int;
    public var fileName:String;
    public var iconTexture:BitmapData;

    private var titleText:SimpleText;
    private var background:Shape;
    private var icon:Bitmap;

    public function ChoiceElement(value:Object, title:String, size:int, color:uint, iconId:int, fileName:String = "editorTools") {
        this.value = value;
        this.title = title;
        this.iconId = iconId;
        this.fileName = fileName;
        this.iconTexture = this.getTexture();

        this.background = new Shape();
        addChild(this.background);
        this.titleText = new SimpleText(size, color, false);
        this.titleText.setText(title);
        this.titleText.updateMetrics();
        addChild(this.titleText);
        this.icon = new Bitmap(this.iconTexture);
        addChild(this.icon);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        updatePositions();
    }

    public function updatePositions():void {
        this.titleText.x = 2;
        this.titleText.y = 0;
        this.icon.x = this.titleText.x + this.titleText.width + 2;
        this.icon.y = this.titleText.y + this.titleText.height / 2 - this.icon.height / 2;
        drawBackground();
    }

    private function drawBackground():void {
        var g:Graphics = this.background.graphics;
        g.clear();
        g.beginFill(Constants.BACK_COLOR_2, 1);
        g.drawRect(0, 0, width + 4, height);
        g.endFill();
    }

    private function onMouseOver(e:Event):void {
        this.background.filters = FilterUtil.GREY_COLOR_FILTER_1;
    }

    private function onMouseOut(e:Event):void {
        this.background.filters = null;
    }

    private function getTexture():BitmapData {
        if (this.fileName == "" || this.iconId == -1)
            return null;
        return AssetLibrary.getImageFromSet(this.fileName, this.iconId);
    }
}
}