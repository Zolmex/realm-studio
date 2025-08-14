package assetlab.view.elements {
import common.util.MoreColorUtil;

import flash.display.JointStyle;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class UISliceView extends Sprite {

    public var cutRect:Rectangle;
    public var sliceType:String;
    public var sliceRect:Rectangle;

    private var outline:Shape;

    public function UISliceView(cutConfig:Object, sliceConfig:Object) {
        var frame:Object = cutConfig.frame;
        this.cutRect = new Rectangle(frame.x, frame.y, frame.w, frame.h);
        this.sliceType = sliceConfig.type;
        var rectangle:Object = sliceConfig.rectangle;
        this.sliceRect = new Rectangle(rectangle.x, rectangle.y, rectangle.w, rectangle.h);

        this.outline = new Shape();
        this.outline.graphics.lineStyle(1, 0x0000FF, 0.8, false, "normal", null, JointStyle.MITER);
        this.outline.graphics.drawRect(0, 0, this.cutRect.width, this.cutRect.height);
        this.outline.graphics.lineStyle();
        addChild(this.outline);

        addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    private function onRollOver(e:MouseEvent):void {
        transform.colorTransform = MoreColorUtil.brightCT;
    }

    private function onRollOut(e:MouseEvent):void {
        transform.colorTransform = MoreColorUtil.identity;
    }
}
}
