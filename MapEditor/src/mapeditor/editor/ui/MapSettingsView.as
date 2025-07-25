package mapeditor.editor.ui {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;

import flash.display.Sprite;

import mapeditor.editor.ui.elements.SimpleText;

public class MapSettingsView extends Sprite {

    private var title:SimpleText;
    private var background:SliceScalingBitmap;
    private var mainView:MainView;
    private var settings:Vector.<Sprite>;
    private var contentWidth:Number;
    private var contentHeight:Number;

    public function MapSettingsView(mainView:MainView) {
        this.mainView = mainView;
        this.settings = new Vector.<Sprite>();
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "settings_background");
        addChild(this.background);

        this.title = new SimpleText(9, 0xB9A960);
        this.title.text = "Settings";
        this.title.updateMetrics();
        this.title.y = 2;
        addChild(this.title);
    }

    public function addSettings(...args):void {
        for each (var setting:Sprite in args){
            this.settings.push(setting);
            addChild(setting);
        }
        this.positionSettings();
        this.drawBackground();

        this.title.x = (this.background.width - this.title.width) / 2;
    }

    private function positionSettings():void {
        var width:Number = 0;
        var xOffset:Number = 7; // We're not actually changing this one
        var yOffset:Number = 20;

        for each (var setting:Sprite in this.settings){
            setting.x = xOffset;
            setting.y = yOffset;
            yOffset += setting.height + 6;
            width = Math.max(setting.x + setting.width, width);
        }

        this.contentWidth = width;
        this.contentHeight = yOffset;
    }

    private function drawBackground():void {
        this.background.width = this.contentWidth + 6;
        this.background.height = this.contentHeight + 3;
    }
}
}
