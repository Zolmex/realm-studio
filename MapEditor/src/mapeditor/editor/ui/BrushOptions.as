package mapeditor.editor.ui {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;

import flash.display.Sprite;
import flash.events.Event;

import mapeditor.editor.MEBrush;
import mapeditor.editor.tools.METool;

public class BrushOptions extends Sprite {

    private var options:Vector.<BrushOptionPanel>;
    private var mainView:MainView;
    private var background:SliceScalingBitmap;
    private var content:Sprite;

    public function BrushOptions(mainView:MainView) {
        this.mainView = mainView;
        this.options = new Vector.<BrushOptionPanel>();
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "tooltip_header_background");
        this.background.alpha = 0.8;
        this.background.visible = false;
        addChild(this.background);

        this.content = new Sprite();
        addChild(this.content);

        updateBrush(mainView.userBrush);
    }

    public function updateBrush(brush:MEBrush):void {
        for each (var option:BrushOptionPanel in options) {
            option.update(brush);
        }
        updatePositions();
    }

    public function onToolChanged(tool:METool):void {
        for each (var old:BrushOptionPanel in this.options) {
            this.content.removeChild(old);
        }
        this.options.length = 0;

        var newOptions:Vector.<BrushOptionPanel> = new Vector.<BrushOptionPanel>();
        switch (tool.id) {
            case METool.PENCIL_ID:
            case METool.ERASER_ID:
                newOptions.push(new BrushReplacePanel(mainView));
                newOptions.push(new BrushSizePanel(mainView));
                break;
            case METool.SHAPE_ID:
                newOptions.push(new BrushShapePanel(mainView));
                newOptions.push(new BrushChancePanel(mainView));
                newOptions.push(new BrushReplacePanel(mainView));
                newOptions.push(new BrushSizePanel(mainView));
                break;
        }

        for each(var opt:BrushOptionPanel in newOptions) {
            opt.update(this.mainView.userBrush);
            opt.addEventListener(Event.CHANGE, this.onChange);
            this.content.addChild(opt);
            this.options.push(opt);
        }
        updatePositions();
        drawBackground();
    }

    private function drawBackground():void {
        if (this.options.length == 0) {
            this.background.visible = false;
            return;
        }
        this.background.visible = true;
        this.background.width = this.content.width + 10;
        this.background.height = this.content.height + 12;
    }

    private function updatePositions():void {
        var w:int = 5;
        var h:int = 6;
        for each (var option:BrushOptionPanel in this.options) {
            option.x = w;
            option.y = h;

            w += option.width + 2;
        }
    }

    private function onChange(e:Event):void {
        updatePositions();
        drawBackground();
        dispatchEvent(e);
    }
}
}