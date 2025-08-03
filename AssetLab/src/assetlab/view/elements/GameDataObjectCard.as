package assetlab.view.elements {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.text.SimpleText;
import common.util.Constants;

import flash.display.Sprite;
import flash.text.TextFieldAutoSize;

public class GameDataObjectCard extends Sprite {

    public static const WIDTH:int = 98;
    public static const HEIGHT:int = 100;

    private var xml:XML;

    private var background:SliceScalingBitmap;
    private var title:SimpleText;

    public function GameDataObjectCard(xml:XML) {
        this.xml = xml;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "drawelement_background");
        this.background.width = WIDTH;
        this.background.height = HEIGHT;
        addChild(this.background);

        this.title = new SimpleText(12, Constants.TEXT_UI_COLOR, false, WIDTH - 4);
        this.title.setAutoSize(TextFieldAutoSize.LEFT);
        this.title.setText(xml.@id);
        this.title.setBold(true);
        this.title.updateMetrics();
        addChild(this.title);

        this.positionChildren();
    }

    private function positionChildren():void {
        this.title.x = (WIDTH - this.title.actualWidth_) / 2;
        this.title.y = (20 - this.title.height) / 2;
    }
}
}
