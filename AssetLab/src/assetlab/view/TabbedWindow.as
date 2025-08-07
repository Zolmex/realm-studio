package assetlab.view {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.MouseEvent;

public class TabbedWindow extends Sprite {

    private var background:SliceScalingBitmap;
    private var tabs:Vector.<TabElement>;
    private var container:Sprite;
    private var containerMask:Shape;

    public function TabbedWindow(width:int, height:int) {
        this.tabs = new <TabElement>[];

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "drawelement_background");
        this.background.alpha = 0.9;
        this.background.width = width;
        this.background.height = height;
        this.background.y = TabElement.HEIGHT;
        addChild(this.background);

        this.container = new Sprite(); // Content container
        this.container.x = 5;
        this.container.y = this.background.y + 4;
        addChild(this.container);

        this.containerMask = new Shape();
        this.containerMask.graphics.beginFill(0);
        this.containerMask.graphics.drawRect(this.container.x, this.container.y, width - this.container.x - 4, height - 8);
        this.containerMask.graphics.endFill();
        this.container.mask = this.containerMask;
        addChild(this.containerMask);
    }

    private function positionTabs():void {
        var i:int = 0;
        for each (var tab:TabElement in this.tabs) {
            tab.x = i * TabElement.WIDTH;
            i++;
        }
    }

    private function onTabClicked(e:MouseEvent):void {
        for each (var tab:TabElement in this.tabs){
            tab.setSelected(false);
        }

        tab = e.target as TabElement;
        tab.setSelected(true);
    }

    public function addTab(tabTitle:String, tabContent:Sprite):void {
        var tab:TabElement = new TabElement(tabTitle, tabContent);
        tab.addEventListener(MouseEvent.CLICK, this.onTabClicked);
        tab.setSelected(this.tabs.length == 0);

        this.tabs.push(tab);
        this.container.addChild(tabContent);
        addChild(tab);

        this.positionTabs();
    }

    public function selectTab(tabTitle:String):void {
        for each (var tab:TabElement in this.tabs){
            tab.setSelected(tab.title.text == tabTitle);
        }
    }

    public function resize(width:int, height:int):void {
        this.background.width = width;
        this.background.height = height;
        this.containerMask.graphics.clear();
        this.containerMask.graphics.beginFill(0);
        this.containerMask.graphics.drawRect(this.container.x, this.container.y, width - this.container.x - 4, height - 8);
        this.containerMask.graphics.endFill();
    }
}
}

import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.text.SimpleText;
import common.util.Constants;
import common.util.MoreColorUtil;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

class TabElement extends Sprite {

    public static const WIDTH:int = 55;
    public static const HEIGHT:int = 30;

    public var title:SimpleText;
    private var background:SliceScalingBitmap;
    private var content:Sprite;

    public function TabElement(title:String, content:Sprite) {
        this.content = content;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "tooltip_header_background");
        this.background.width = WIDTH;
        this.background.height = HEIGHT;
        addChild(this.background);

        this.title = new SimpleText(10, Constants.TEXT_UI_COLOR, false, WIDTH - 2);
        this.title.setAutoSize(TextFieldAutoSize.LEFT);
        this.title.setText(title);
        this.title.updateMetrics();
        this.title.x = (WIDTH - this.title.width) / 2;
        this.title.y = (HEIGHT - this.title.height) / 2;
        addChild(this.title);

        addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    private function onRollOver(e:Event):void {
        if (!this.content.visible) {
            transform.colorTransform = MoreColorUtil.identity;
        }
    }

    private function onRollOut(e:Event):void {
        if (!this.content.visible) {
            transform.colorTransform = MoreColorUtil.darkCT;
        }
    }

    public function setSelected(val:Boolean):void {
        this.content.visible = val;
        this.title.setColor(val ? Constants.TITLE_COLOR : Constants.TEXT_UI_COLOR);
        transform.colorTransform = val ? MoreColorUtil.identity : MoreColorUtil.darkCT;
    }
}
