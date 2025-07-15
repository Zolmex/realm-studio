package realmeditor.editor.ui.elements {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import realmeditor.editor.ui.Constants;

public class ChoiceBox extends Sprite {

    private var elements:Vector.<ChoiceElement>;
    private var border:Shape;
    private var arrowButton:SimpleTextButton;
    private var arrowBackground:Shape;
    private var color:uint;
    private var expanded:Boolean;
    private var expandBackground:Shape;

    public var selectedElement:ChoiceElement;
    public var selected:int;

    public function ChoiceBox(elements:Vector.<ChoiceElement>, size:int, color:uint, firstId:int = 0) {
        this.elements = elements;
        this.selected = firstId;
        this.color = color;
        this.arrowBackground = new Shape();
        addChild(this.arrowBackground);
        this.arrowButton = new SimpleTextButton("<b>V</b>", size, color, false);
        this.arrowButton.addEventListener(MouseEvent.CLICK, this.onArrowClick);
        addChild(this.arrowButton);
        this.selectedElement = this.elements[firstId];
        addChild(this.selectedElement);
        this.border = new Shape();
        addChild(this.border);
        this.expandBackground = new Shape();
        addChild(this.expandBackground);
        updatePositions();

        var i:int = 0;
        for each (var element:ChoiceElement in this.elements) {
            element.addEventListener(MouseEvent.CLICK, onElementClick(i));
            i++;
        }
    }

    private function updatePositions():void {
        this.selectedElement.x = 0;
        this.selectedElement.y = 0;
        this.selectedElement.updatePositions();

        this.arrowButton.x = this.selectedElement.x + this.selectedElement.width;
        this.arrowButton.y = this.selectedElement.y + this.selectedElement.height / 2 - this.arrowButton.height / 2;

        this.arrowBackground.x = this.arrowButton.x;
        this.arrowBackground.y = 0;
        drawArrowBackground();
        drawBorder();
    }

    private function drawBorder():void {
        var g:Graphics = this.border.graphics;
        g.clear();
        var w:Number = width;
        var h:Number = height;
        g.lineStyle(1, this.color);
        g.moveTo(0, 0);
        g.lineTo(w, 0);
        g.lineTo(w, h);
        g.lineTo(0, h);
        g.lineTo(0, 0);
        g.endFill();
    }

    private function drawArrowBackground():void {
        var g:Graphics = this.arrowBackground.graphics;
        g.clear();
        var w:Number = this.arrowButton.width + 2;
        var h:Number = this.arrowButton.height + 1;
        g.beginFill(Constants.BACK_COLOR_1, 1);
        g.drawRect(0, 0, w, h);
        g.endFill();

    }

    private function onElementClick(id:int):Function {
        return function (e:Event):void {
            onClick(id);
        }
    }

    private function onArrowClick(e:Event):void {
        if (this.expanded) {
            this.collapse();
        } else {
            this.expand();
        }
    }

    private function onClick(id:int):void {
        if (id == selected) {
            if (this.expanded) {
                this.collapse();
            } else {
                this.expand();
            }

            return;
        }

        this.setSelected(id);
    }

    public function setSelected(id:int):void {
        this.selectedElement = this.elements[id];
        this.selected = id;
        this.collapse();
        removeChild(this.border);
        addChild(this.border);
        this.updatePositions();
        dispatchEvent(new Event(Event.CHANGE));
    }

    private function drawExpandBackground():void {
        var g:Graphics = this.expandBackground.graphics;
        g.clear();
        var w:int = this.width;
        var h:int = 0;
        for each (var element:ChoiceElement in this.elements) {
            if (element == selectedElement)
                continue;
            w = Math.max(w, element.width);
            h += element.height + 1;
        }

        g.moveTo(0, 0);
        g.beginFill(Constants.BACK_COLOR_2, 1);
        g.drawRect(0, 0, w, h);
        g.endFill();

        w = this.expandBackground.width - 1;
        h = this.expandBackground.height;
        g.moveTo(0, 0);
        g.lineStyle(1, 0xFFFFFF);
        g.lineTo(w, 0);
        g.lineTo(w, h);
        g.lineTo(0, h);
        g.lineTo(0, 0);
    }

    public function expand():void {
        if (this.expanded)
            return;

        var bgY:int = this.y + this.height;
        this.drawExpandBackground();
        this.expandBackground.y = bgY;
        this.expandBackground.visible = true;

        var y:int = this.expandBackground.y + 1;
        for each (var element:ChoiceElement in this.elements) {
            if (element == selectedElement)
                continue;

            element.x = this.expandBackground.width / 2 - element.width / 2;
            element.y = y;
            addChild(element);
            y += element.height + 1;
        }

        this.expanded = true;
    }

    public function collapse():void {
        if (!this.expanded)
            return;

        this.expandBackground.graphics.clear();
        this.expandBackground.visible = false;

        for each (var element:ChoiceElement in this.elements) {
            if (element == selectedElement)
                continue;

            removeChild(element);
        }

        this.expanded = false;
    }
}
}