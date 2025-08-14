package assetlab.view.elements {
import assetlab.view.elements.ContentViewUI;

import common.Global;
import common.util.MoreColorUtil;

import flash.display.JointStyle;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class UISliceView extends Sprite {

    public var cutName:String;
    public var cutRect:Rectangle;
    public var sliceType:String;
    public var sliceRect:Rectangle;

    private var view:ContentViewUI;
    private var outline:Shape;
    private var tooltip:UISliceTooltip;

    public function UISliceView(view:ContentViewUI, cutName:String, cutConfig:Object, sliceConfig:Object) {
        this.view = view;
        this.cutName = cutName;
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

        doubleClickEnabled = true;
        addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        addEventListener(MouseEvent.DOUBLE_CLICK, this.onDoubleClick);
    }

    private function onDoubleClick(e:MouseEvent):void {
        this.view.showSliceEditor(true, this.cutName, this.cutRect, this.sliceType, this.sliceRect);
    }

    private function onRollOver(e:MouseEvent):void {
        if (this.tooltip == null){
            this.tooltip = new UISliceTooltip(this);
            Global.Main.stage.addChild(this.tooltip);
        }
        transform.colorTransform = MoreColorUtil.brightCT;
    }

    private function onRollOut(e:MouseEvent):void {
        transform.colorTransform = MoreColorUtil.identity;
    }
}
}

import assetlab.view.elements.UISliceView;

import common.ui.elements.Tooltip;
import common.ui.text.SimpleText;
import common.util.Constants;

import flash.display.DisplayObject;
import flash.text.TextFieldAutoSize;

class UISliceTooltip extends Tooltip {

    private static const WIDTH:int = 180;

    private var slice:UISliceView;
    private var title:SimpleText;
    private var sizeText:SimpleText;
    private var tip:SimpleText;

    function UISliceTooltip(target:UISliceView) {
        this.slice = target;

        this.title = new SimpleText(13, Constants.TEXT_UI_COLOR, false, WIDTH - 4);
        this.title.setAutoSize(TextFieldAutoSize.LEFT);
        this.title.setText(this.slice.cutName);
        this.title.updateMetrics();

        this.sizeText = new SimpleText(11, Constants.TEXT_UI_COLOR);
        this.sizeText.setText("Width: " + this.slice.cutRect.width + "\nHeight: " + this.slice.cutRect.height);
        this.sizeText.updateMetrics();

        this.tip = new SimpleText(10, Constants.TEXT_UI_COLOR);
        this.tip.setText("Double-click to edit.");
        this.tip.updateMetrics();

        super(target);
    }

    protected override function addChildren():void {
        addChild(this.title);
        addChild(this.sizeText);
    }

    protected override function positionChildren():void {
        this.title.y = 5;
        this.title.x = 5;

        this.sizeText.x = 5;
        this.sizeText.y = this.title.y + this.title.height + 3;

        this.tip.x = this.sizeText.x;
        this.tip.y = this.sizeText.y + this.sizeText.height;
    }
}