package assetlab.view.elements {
import assetlab.io.LabAssets;

import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.text.SimpleText;
import common.util.Constants;
import common.util.MoreColorUtil;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

public class GameDataObjectCard extends Sprite {

    public static const WIDTH:int = 115;
    public static const HEIGHT:int = 100;

    private var xml_:XML;

    private var background:SliceScalingBitmap;
    private var title:SimpleText;
    private var typeText:SimpleText;
    private var textureDisplay:GameDataTextureDisplay;

    public function GameDataObjectCard(xml:XML) {
        this.xml_ = xml;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "drawelement_background");
        this.background.width = WIDTH;
        this.background.height = HEIGHT;
        addChild(this.background);

        this.title = new SimpleText(12, Constants.TEXT_UI_COLOR, false, WIDTH - 4);
        this.title.scrollMs = 20;
        this.title.setText(xml.@id);
        this.title.setBold(true);
        this.title.updateMetrics();
        addChild(this.title);

        this.typeText = new SimpleText(10, Constants.TEXT_UI_COLOR);
        this.typeText.setText("#" + int(xml.@type));
        this.typeText.updateMetrics();
        addChild(this.typeText);

        this.textureDisplay = new GameDataTextureDisplay(LabAssets.getTextureData(xml));
        addChild(this.textureDisplay);

        addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);

        this.positionChildren();
    }

    private function onRollOver(e:Event):void {
        this.textureDisplay.startAnimation();
        this.title.scrollingEnabled = true;
        transform.colorTransform = MoreColorUtil.brightCT;
    }

    private function onRollOut(e:Event):void {
        this.textureDisplay.pauseAnimation();
        this.title.scrollingEnabled = false;
        transform.colorTransform = MoreColorUtil.identity;
    }

    private function positionChildren():void {
        var textW:Number = Math.min(this.title.width, this.title.actualWidth_);
        this.title.x = (WIDTH - textW) / 2;
        this.title.y = (25 - this.title.height) / 2;

        this.typeText.x = (WIDTH - this.typeText.width) / 2;
        this.typeText.y = this.title.y + this.title.height + 2;

        this.textureDisplay.x = (WIDTH - this.textureDisplay.width) / 2;
        this.textureDisplay.y = this.typeText.y + this.typeText.height + (HEIGHT - (this.typeText.y + this.typeText.height) - this.textureDisplay.height) / 2;
    }

    public function get xml():XML{
        return this.xml_;
    }
}
}
