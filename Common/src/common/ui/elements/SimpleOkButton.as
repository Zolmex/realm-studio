package common.ui.elements {
import common.ui.text.SimpleText;
import common.util.Constants;
import common.util.MoreColorUtil;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mapeditor.editor.ui.Constants;

public class SimpleOkButton extends Sprite {

    private var okText:SimpleText;

    public function SimpleOkButton() {
        this.okText = new SimpleText(14, 0xB2B2B2);
        this.okText.setText("Ok");
        this.okText.updateMetrics();
        this.okText.x = 3;
        this.okText.y = 3;
        this.okText.filters = Constants.SHADOW_FILTER_1;
        addChild(this.okText);

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
