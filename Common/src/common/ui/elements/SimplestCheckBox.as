package common.ui.elements {

import common.util.Constants;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mapeditor.editor.ui.Constants;

public class SimplestCheckBox extends Sprite {

    private static const CHECKBOX_SIZE:int = 15;
    private static const CHECKCROSS_SIZE:int = 10;

    public var value:Boolean;
    private var checkBox:Sprite;
    private var checkCross:Shape;

    public function SimplestCheckBox(title:String, defaultValue:Boolean = false) {
        this.value = defaultValue;

        this.checkBox = new Sprite();
        var g:Graphics = this.checkBox.graphics;
        g.beginFill(Constants.BACK_COLOR_1);
        g.drawRoundRect(0, 0, CHECKBOX_SIZE, CHECKBOX_SIZE, 5, 5);
        g.endFill();
        addChild(this.checkBox);

        this.checkCross = new Shape();
        this.checkCross.visible = defaultValue;
        g = this.checkCross.graphics;
        g.lineStyle(3, 0xFFFFFF);
        g.lineTo(CHECKCROSS_SIZE, CHECKCROSS_SIZE);
        g.moveTo(CHECKCROSS_SIZE, 0);
        g.lineTo(0, CHECKCROSS_SIZE);
        g.lineStyle();
        addChild(this.checkCross);

        this.positionChildren();

        this.checkBox.addEventListener(MouseEvent.CLICK, this.onClick);
    }

    public function setValue(value:Boolean):void {
        this.value = value;
        this.checkCross.visible = value;
    }

    private function onClick(e:Event):void {
        this.value = !this.value;
        this.checkCross.visible = this.value;
        this.dispatchEvent(new Event(Event.CHANGE));
    }

    private function positionChildren():void {
        this.checkBox.x = 0;
        this.checkBox.y = 0;

        this.checkCross.x = this.checkBox.x + (CHECKBOX_SIZE - CHECKCROSS_SIZE) / 2;
        this.checkCross.y = this.checkBox.y + (CHECKBOX_SIZE - CHECKCROSS_SIZE) / 2;
    }
}
}