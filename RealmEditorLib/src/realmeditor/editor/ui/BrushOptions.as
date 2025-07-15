package realmeditor.editor.ui {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

import realmeditor.editor.MEBrush;
import realmeditor.editor.tools.METool;

public class BrushOptions extends Sprite {

    private var options:Vector.<BrushOptionPanel>;
    private var mainView:MainView;
    private var background:Shape;

    public function BrushOptions(mainView:MainView) {
        this.mainView = mainView;
        this.options = new Vector.<BrushOptionPanel>();
        this.background = new Shape();
        addChild(this.background);
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
            removeChild(old);
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
            addChild(opt);
            this.options.push(opt);
        }
        updatePositions();
        drawBackground();
    }

    private function drawBackground():void {
        var g:Graphics = this.background.graphics;
        if (this.options.length == 0) {
            g.clear();
            return;
        }
        g.clear();
        g.beginFill(Constants.BACK_COLOR_2, 0.8);
        g.drawRoundRect(0, 0, width + 10, height + 12, 5, 5);
        g.endFill();
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