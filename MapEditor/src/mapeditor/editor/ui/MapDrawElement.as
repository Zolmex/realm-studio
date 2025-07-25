package mapeditor.editor.ui {
import common.assets.GroundLibrary;
import common.assets.ObjectLibrary;
import common.assets.RegionLibrary;
import common.ui.TextureParser;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mapeditor.editor.MEDrawType;
import mapeditor.editor.ui.elements.DrawListTooltip;

public class MapDrawElement extends Sprite {

    private static const TEXTURE_SIZE:int = 32;

    public var elementType:int;
    public var texture:Bitmap;
    public var drawType:int;
    private var tooltip:DrawListTooltip;
    private var background:Bitmap;

    public function MapDrawElement(elementType:int, texture:BitmapData, drawType:int) {
        this.elementType = elementType;
        this.drawType = drawType;

        this.background = TextureParser.instance.getTexture("UI", "drawelement_background");
        addChild(this.background);
        this.texture = new Bitmap(texture);
        this.texture.scaleX = TEXTURE_SIZE / this.texture.width;
        this.texture.scaleY = TEXTURE_SIZE / this.texture.height;
        this.texture.x = (this.background.width - this.texture.width) / 2;
        this.texture.y = (this.background.height - this.texture.height) / 2;
        addChild(this.texture);

        this.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
    }

    private function onRollOver(e:Event):void {
        this.removeEventListener(MouseEvent.ROLL_OVER, this.onRollOver);

        var xml:XML;
        switch(this.drawType){
            case MEDrawType.GROUND:
                xml = GroundLibrary.xmlLibrary_[this.elementType];
                break;
            case MEDrawType.OBJECTS:
                xml = ObjectLibrary.xmlLibrary_[this.elementType];
                break;
            case MEDrawType.REGIONS:
                xml = RegionLibrary.xmlLibrary_[this.elementType];
                break;
        }

        if (xml == null){
            return;
        }

        this.tooltip = new DrawListTooltip(this, this.texture.bitmapData, xml, this.drawType);
        MainView.Main.stage.addChild(this.tooltip);
    }
}
}
