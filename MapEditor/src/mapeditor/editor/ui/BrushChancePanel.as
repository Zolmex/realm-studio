package mapeditor.editor.ui {
import common.ui.text.SimpleText;

import flash.events.Event;

import mapeditor.editor.MEBrush;

public class BrushChancePanel extends BrushOptionPanel {

    private var input:SimpleText;

    public function BrushChancePanel(main:MainView) {
        super("Chance: ", main);
        this.input = new SimpleText(12, 0xB2B2B2, true, 22, 18, false, true);
        this.input.restrict = "0-9";
        this.input.maxChars = 2;
        this.input.addEventListener(Event.CHANGE, onChange);
        addChild(this.input);
        fixPositions();
    }

    public override function update(brush:MEBrush):void {
        this.input.text = brush.chance.toString();
        fixPositions();
    }

    private function fixPositions():void {
        this.input.x = this.titleText.x + this.titleText.width;
        this.input.y = 0;
    }

    private function onChange(e:Event):void {
        var newChance:int = int(this.input.text);
        if (newChance <= 0)
            return;
        mainView.userBrush.setChance(newChance);
    }
}
}
