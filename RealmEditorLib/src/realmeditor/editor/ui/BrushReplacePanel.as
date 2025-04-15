package realmeditor.editor.ui {
import flash.events.Event;

import realmeditor.editor.MEBrush;
import realmeditor.editor.ui.elements.SimplestCheckBox;

public class BrushReplacePanel extends BrushOptionPanel {

    private var checkbox:SimplestCheckBox;

    public function BrushReplacePanel(main:MainView) {
        super("Replace: ", main);
        this.checkbox = new SimplestCheckBox("", true);
        this.checkbox.addEventListener(Event.CHANGE, this.onChange);
        addChild(this.checkbox);
        fixPositions();
    }

    public override function update(brush:MEBrush):void {
        this.checkbox.setValue(brush.replace);
        fixPositions();
    }

    private function fixPositions():void {
        this.checkbox.x = this.titleText.x + this.titleText.width;
        this.checkbox.y = this.titleText.y + this.titleText.height / 2 - this.checkbox.height / 2;
    }

    private function onChange(e:Event):void {
        mainView.userBrush.setReplace(this.checkbox.value);
    }
}
}
