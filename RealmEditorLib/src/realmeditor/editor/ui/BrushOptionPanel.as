package realmeditor.editor.ui {
import flash.display.Sprite;

import realmeditor.editor.MEBrush;
import realmeditor.editor.ui.elements.SimpleText;

public class BrushOptionPanel extends Sprite {

    protected var mainView:MainView;
    protected var titleText:SimpleText;

    public function BrushOptionPanel(title:String, main:MainView) {
        this.mainView = main;
        this.titleText = new SimpleText(12, 0xB2B2B2);
        this.titleText.setText(title);
        this.titleText.updateMetrics();
        addChild(this.titleText);
    }

    public function update(brush:MEBrush):void {

    }
}
}