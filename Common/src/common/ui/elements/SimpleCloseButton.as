package common.ui.elements {
import common.ui.text.SimpleText;
import common.util.Constants;
import common.util.MoreColorUtil;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mapeditor.editor.ui.Constants;

public class SimpleCloseButton extends Sprite {

    private var closeText:SimpleText;

    public function SimpleCloseButton() {
        this.closeText = new SimpleText(14, 0xB2B2B2);
        this.closeText.setText("Close");
        this.closeText.updateMetrics();
        this.closeText.x = 3;
        this.closeText.y = 3;
        this.closeText.filters = Constants.SHADOW_FILTER_1;
        addChild(this.closeText);

        this.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
        this.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    private function onRollOver(e:Event):void {
        this.transform.colorTransform = MoreColorUtil.darkCT;
    }

    private function onRollOut(e:Event):void {
        this.transform.colorTransform = MoreColorUtil.identity;
    }
}
}
