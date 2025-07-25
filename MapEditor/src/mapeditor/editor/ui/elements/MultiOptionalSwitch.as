package mapeditor.editor.ui.elements {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mapeditor.editor.MEEvent;
import mapeditor.util.FilterUtil;

public class MultiOptionalSwitch extends Sprite {

    private var background:SliceScalingBitmap;
    private var options:Vector.<SwitchOption>;
    private var nextOptionY:Number;
    public var selected:int;
    private var content:Sprite;

    public function MultiOptionalSwitch() {
        this.options = new Vector.<SwitchOption>();
        this.nextOptionY = 6;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "drawelementselector_background");
        this.background.alpha = 0.9;
        addChild(this.background);

        this.content = new Sprite();
        addChild(this.content);
    }

    public function addOption(title:String):void {
        var option:SwitchOption = new SwitchOption(title);
        option.x = 3;
        option.y = this.nextOptionY;
        option.filters = this.options.length == 0 ? null : FilterUtil.GREY_COLOR_FILTER_2;
        option.showBackground(this.options.length == 0);
        option.addEventListener(MouseEvent.CLICK, this.onOptionClick);
        this.content.addChild(option);

        this.nextOptionY = option.y + option.height;
        this.options.push(option);

        this.drawBackground();
    }

    private function drawBackground():void {
        this.background.width = this.content.width + 6;
        this.background.height = this.content.height + 8;
    }

    private function onOptionClick(e:Event):void {
        e.stopImmediatePropagation();

        for (var i:int = 0; i < this.options.length; i++){
            this.options[i].filters = FilterUtil.GREY_COLOR_FILTER_2;
            this.options[i].showBackground(false);
        }

        var option:SwitchOption = e.target as SwitchOption;
        option.filters = null;
        option.showBackground(true);

        this.selected = this.options.indexOf(option);

        this.dispatchEvent(new Event(MEEvent.OPTION_SWITCH));
    }

    public function selectNext():void {
        for (var i:int = 0; i < this.options.length; i++){
            this.options[i].filters = FilterUtil.GREY_COLOR_FILTER_2;
            this.options[i].showBackground(false);
        }

        var next:int = this.selected + 1;
        if (next >= this.options.length) {
            next = 0;
        }

        var option:SwitchOption = this.options[next];
        option.filters = null;
        option.showBackground(true);

        this.selected = next;

        this.dispatchEvent(new Event(MEEvent.OPTION_SWITCH));
    }

    public function select(id:int):void {
        if (id >= this.options.length || id < 0)
            return;

        for (var i:int = 0; i < this.options.length; i++){
            this.options[i].filters = FilterUtil.GREY_COLOR_FILTER_2;
            this.options[i].showBackground(false);
        }

        var option:SwitchOption = this.options[id];
        option.filters = null;
        option.showBackground(true);

        this.selected = id;

        this.dispatchEvent(new Event(MEEvent.OPTION_SWITCH));
    }
}
}

import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;

import flash.display.Sprite;

import mapeditor.editor.ui.Constants;
import mapeditor.editor.ui.elements.SimpleText;

class SwitchOption extends Sprite {

    private static const WIDTH:int = 92;

    private var background:SliceScalingBitmap;
    private var text:SimpleText;

    public function SwitchOption(title:String){
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "drawelementselector_selection");
        this.background.visible = false;
        addChild(this.background);

        this.text = new SimpleText(13, 0xB2B2B2);
        this.text.setText(title);
        this.text.updateMetrics();
        this.text.x = (WIDTH - this.text.width) / 2;
        this.text.filters = Constants.SHADOW_FILTER_1;
        addChild(this.text);

        this.background.width = WIDTH;
        this.background.height = text.height + 4;
        this.background.y = -2;
    }

    public function showBackground(val:Boolean):void {
        this.text.setColor(val ? 0xB9A960 : 0xB2B2B2);
        this.background.visible = val;
    }
}
