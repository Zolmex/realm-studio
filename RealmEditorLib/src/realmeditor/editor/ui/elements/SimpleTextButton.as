package realmeditor.editor.ui.elements {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.geom.ColorTransform;

import realmeditor.editor.ui.Constants;
import realmeditor.editor.ui.embed.SliceScalingBitmap;
import realmeditor.editor.ui.embed.TextureParser;
import realmeditor.util.FilterUtil;
import realmeditor.util.MoreColorUtil;

public class SimpleTextButton extends Sprite {

    private var backgroundBmp:SliceScalingBitmap;
    private var textField:SimpleText;
    private var background:Boolean;

    public function SimpleTextButton(textStr:String, size:int = 9, color:uint = 0x696969, background:Boolean = true) {
        this.backgroundBmp = TextureParser.instance.getSliceScalingBitmap("UI", "button_background");
        this.backgroundBmp.visible = false;
        addChild(this.backgroundBmp);

        this.textField = new SimpleText(size, color);
        this.textField.setBold(true);
        this.textField.htmlText = textStr;
        this.textField.filters = Constants.SHADOW_FILTER_1;
        this.textField.updateMetrics();
        addChild(this.textField);

        this.background = background;
        if (background) {
            var shapeW:int = this.width + 10;
            var shapeH:int = this.height + 5;
            this.backgroundBmp.width = shapeW;
            this.backgroundBmp.height = shapeH;
            this.backgroundBmp.visible = true;
            this.textField.x = (this.width - this.textField.width) / 2;
            this.textField.y = (this.height - this.textField.height) / 2;
        }

        filters = Constants.SHADOW_FILTER_1;

        this.addEventListener(MouseEvent.ROLL_OVER, this.onMouseRollOver);
        this.addEventListener(MouseEvent.ROLL_OUT, this.onMouseRollOut);
    }

    public function setText(htmlText:String):void {
        this.textField.htmlText = htmlText;
        this.textField.updateMetrics();
    }

    private function onMouseRollOver(e:Event):void {
        transform.colorTransform = new ColorTransform(1, 1, 1, 1, 40, 40, 40, 0.5);
    }

    private function onMouseRollOut(e:Event):void {
        transform.colorTransform = MoreColorUtil.identity;
    }
}
}
