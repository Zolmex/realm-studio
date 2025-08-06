package assetlab.view.elements {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.text.SimpleText;
import common.util.Constants;
import common.util.MoreColorUtil;

import flash.display.Sprite;

import flash.events.Event;

import flash.events.MouseEvent;
import flash.filesystem.File;

public class VerticalListSlot extends Sprite {

    public static const WIDTH:int = 144;
    public static const HEIGHT:int = 25;

    private var background:SliceScalingBitmap;
    private var nameText:SimpleText;
    public var selected:Boolean;

    function VerticalListSlot(name:String) {
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "drawelementselector_selection");
        this.background.width = WIDTH;
        this.background.height = HEIGHT;
        addChild(this.background);

        this.nameText = new SimpleText(14, Constants.TEXT_UI_COLOR, false, WIDTH - 4);
        this.nameText.setText(name);
        this.nameText.updateMetrics();
        this.nameText.x = (WIDTH - this.nameText.width) / 2;
        this.nameText.y = (HEIGHT - this.nameText.height) / 2;
        addChild(this.nameText);

        addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    private function onRollOver(e:Event):void {
        this.nameText.scrollingEnabled = true;
        if (!this.selected) {
            transform.colorTransform = MoreColorUtil.identity;
        }
    }

    private function onRollOut(e:Event):void {
        this.nameText.scrollingEnabled = false;
        if (!this.selected) {
            transform.colorTransform = MoreColorUtil.darkCT;
        }
    }

    public function setSelected(val:Boolean):void {
        this.selected = val;
        this.nameText.setColor(val ? Constants.TITLE_COLOR : Constants.TEXT_UI_COLOR);
        transform.colorTransform = val ? MoreColorUtil.identity : MoreColorUtil.darkCT;
    }
}
}
