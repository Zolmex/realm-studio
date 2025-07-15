package realmeditor.editor.ui {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import realmeditor.assets.GroundLibrary;
import realmeditor.assets.ObjectLibrary;
import realmeditor.assets.RegionLibrary;
import realmeditor.editor.MEDrawType;
import realmeditor.editor.ui.elements.DrawListTooltip;
import realmeditor.editor.ui.embed.TextureParser;

public class MapDrawElement extends Sprite {

    private static const TEXTURE_SIZE:int = 32;

    public var elementType:int;
    public var texture:Bitmap;
    private var drawType:int;
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
