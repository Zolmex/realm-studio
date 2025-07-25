package mapeditor.editor.ui {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.elements.SimpleTextButton;
import common.ui.elements.SimpleTextInput;
import common.ui.text.SimpleText;
import common.util.Constants;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

public class ObjectFilterOptionsView extends Sprite {

    private static const LETTERS:String = "abcdefghijklmopuqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    private var listView:MapDrawElementListView;
    private var background:SliceScalingBitmap;
    private var arrowText:SimpleText;
    private var propInput:SimpleTextInput;
    private var valueInput:SimpleTextInput;
    private var addButton:SimpleTextButton;
    private var options:Dictionary;
    private var content:Sprite;

    public function ObjectFilterOptionsView(listView:MapDrawElementListView) {
        this.listView = listView;
        this.options = new Dictionary();

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "settings_background");
        this.background.alpha = 0.8;
        this.background.visible = false;
        addChild(this.background);

        this.content = new Sprite();
        addChild(this.content);

        this.arrowText = new SimpleText(20, 0xFFFFFF);
        this.arrowText.setText("<");
        this.arrowText.setBold(true);
        this.arrowText.useTextDimensions();
        this.arrowText.mouseEnabled = true;
        this.arrowText.filters = Constants.SHADOW_FILTER_1;
        this.arrowText.addEventListener(MouseEvent.CLICK, this.onArrowClick);
        this.content.addChild(this.arrowText);

        this.drawPanel();

        filters = Constants.SHADOW_FILTER_1;
    }

    private function drawPanel():void {
        this.propInput = new SimpleTextInput("Property:", true, "", 13, 0xB2B2B2, 13, 0x777777, true);
        this.propInput.inputText.restrict = "a-z A-Z 0-9";
        this.propInput.x = this.arrowText.x - this.propInput.width - 5;
        this.propInput.y = 20;
        this.propInput.filters = Constants.SHADOW_FILTER_1;

        this.valueInput = new SimpleTextInput("Value:", true, "", 13, 0xB2B2B2, 13, 0x777777, true);
        this.valueInput.inputText.restrict = "a-z A-Z 0-9";
        this.valueInput.x = this.propInput.x;
        this.valueInput.y = this.propInput.y + this.propInput.height + 2;
        this.valueInput.filters = Constants.SHADOW_FILTER_1;

        this.addButton = new SimpleTextButton("Add");
        this.addButton.addEventListener(MouseEvent.CLICK, this.onAddClick);
        this.addButton.x = this.propInput.x;
        this.addButton.y = this.valueInput.y + this.valueInput.height + 5;

        this.drawBackground();
    }

    private function drawBackground():void {
        this.background.width = this.content.width + 5;
        this.background.height = this.content.height + 6;
        this.background.x = -(this.content.width - this.arrowText.width) - 5;
    }

    private function onArrowClick(e:Event):void {
        var val:Boolean = !this.background.visible;
        this.arrowText.setText(val ? ">" : "<");
        this.arrowText.useTextDimensions();

        if (val) {
            this.content.addChild(this.propInput);
            this.content.addChild(this.valueInput);
            this.content.addChild(this.addButton);
        } else {
            this.content.removeChild(this.propInput);
            this.content.removeChild(this.valueInput);
            this.content.removeChild(this.addButton);
        }

        this.background.visible = val;
        this.drawBackground();
        this.optionsVisible(val);
    }

    private function onAddClick(e:Event):void {
        var propName:String = this.propInput.inputText.text;
        var valueStr:String = this.valueInput.inputText.text;
        if (propName == "" || this.options.hasOwnProperty(propName)) {
            return;
        }

        var val:*;
        if (valueStr == "") {
            val = true;
        } else if (IsNumber(valueStr)) {
            val = int(valueStr);
        } else if (valueStr == "true") {
            val = true;
        } else if (valueStr == "false") {
            val = false;
        } else {
            val = valueStr;
        }

        this.listView.addPropertyFilter(propName, val);

        var option:FilterOption = new FilterOption(propName, val);
        this.content.addChild(option);

        this.options[propName] = option;
        this.positionOptions();

        this.drawBackground();
    }

    public function removeOption(option:FilterOption):void {
        if (!this.options.hasOwnProperty(option.propName)) {
            return;
        }

        this.listView.removePropertyFilter(option.propName);

        this.content.removeChild(option);
        delete this.options[option.propName];

        this.positionOptions();

        this.drawBackground();
    }

    private function positionOptions():void {
        var i:int = 0;
        for (var propName:String in this.options) {
            this.options[propName].x = this.propInput.x;
            this.options[propName].y = this.addButton.y + this.addButton.height + 5;
            this.options[propName].y += i * FilterOption.HEIGHT + i * 2; // 2 pixels separation between each slot
            i++;
        }
    }

    private function optionsVisible(val:Boolean):void {
        for (var propName:String in this.options) {
            this.options[propName].visible = val;
        }
    }

    private static function IsNumber(str:String):Boolean {
        for (var i:int = 0; i < LETTERS.length; i++) {
            var c:String = LETTERS.charAt(i);
            if (str.indexOf(c) != -1) {
                return false;
            }
        }
        return true;
    }
}
}

import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.text.SimpleText;
import common.util.Constants;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mapeditor.editor.ui.ObjectFilterOptionsView;

class FilterOption extends Sprite {

    public static const HEIGHT:int = 20;

    public var propName:String;
    private var propText:SimpleText;
    private var valText:SimpleText;
    private var propBackground:SliceScalingBitmap;
    private var crossBackground:SliceScalingBitmap;
    private var cross:Sprite;

    public function FilterOption(propName:String, val:*) {
        this.propName = propName;

        this.propBackground = TextureParser.instance.getSliceScalingBitmap("UI", "checkbox_title_background");
        addChild(this.propBackground);

        this.propText = new SimpleText(13, 0xB2B2B2);
        this.propText.setText(propName + ":");
        this.propText.useTextDimensions();
        this.propText.y = (HEIGHT - this.propText.height) / 2;
        this.propText.filters = Constants.SHADOW_FILTER_1;
        addChild(this.propText);

        this.valText = new SimpleText(13, 0xB2B2B2);
        this.valText.setText(val.toString());
        this.valText.useTextDimensions();
        this.valText.x = this.propText.x + this.propText.width + 3;
        this.valText.y = (HEIGHT - this.valText.height) / 2;
        this.valText.filters = Constants.SHADOW_FILTER_1;
        addChild(this.valText);

        this.propBackground.width = this.propText.x + this.propText.width + this.valText.width + 3;
        this.propBackground.height = this.propText.height + 3;
        this.propBackground.y = (HEIGHT - this.propBackground.height) / 2;

        this.crossBackground = TextureParser.instance.getSliceScalingBitmap("UI", "checkbox_background");
        addChild(this.crossBackground);

        this.cross = new Sprite();
        this.cross.addEventListener(MouseEvent.CLICK, this.onCrossClick);
        addChild(this.cross);

        var crossSize:int = 10;
        this.crossBackground.width = crossSize + 8;
        this.crossBackground.height = crossSize + 8;

        var g:Graphics = this.cross.graphics;
        g.lineStyle(3, 0xFFFFFF);
        g.lineTo(crossSize, crossSize);
        g.moveTo(crossSize, 0);
        g.lineTo(0, crossSize);
        g.lineStyle();

        this.cross.x = width + 3;
        this.cross.y = (HEIGHT - this.cross.height) / 2 + 1;
        this.crossBackground.x = this.cross.x - 4;
        this.crossBackground.y = this.cross.y - 4;
    }

    private function onCrossClick(e:Event):void {
        e.stopImmediatePropagation();

        (parent.parent as ObjectFilterOptionsView).removeOption(this);
    }
}