package realmeditor.editor.ui {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

import realmeditor.editor.actions.data.MapSelectData;
import realmeditor.editor.ui.elements.SimpleText;

public class SelectionInfoPanel extends Sprite {

    private var background:Shape;

    private var dimensionText:SimpleText;

    public function SelectionInfoPanel() {
        this.background = new Shape();
        addChild(this.background);

        this.dimensionText = new SimpleText(12, 0xFFFFFF);
        this.dimensionText.filters = Constants.SHADOW_FILTER_1;
        addChild(this.dimensionText);

        filters = Constants.SHADOW_FILTER_1;
    }

    public function setInfo(selection:MapSelectData):void {
        this.dimensionText.setText("Selection: \nW: " + selection.width.toString() + " H: " + selection.height.toString());
        this.dimensionText.useTextDimensions();

        this.fixPositions();
        this.drawBackground();
    }

    private function fixPositions():void {
        dimensionText.x = 0;
        dimensionText.y = 0;
    }

    private function drawBackground():void {
        var g:Graphics = this.background.graphics;
        g.clear();
        g.beginFill(Constants.BACK_COLOR_2, 0.8);
        g.drawRoundRect(-4, -4, width + 8, height + 8, 10, 10);
        g.endFill();
    }
}
}