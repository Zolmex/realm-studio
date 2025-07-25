package mapeditor.editor.ui {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;

import flash.display.Sprite;

import mapeditor.editor.actions.data.MapSelectData;
import mapeditor.editor.ui.elements.SimpleText;

public class SelectionInfoPanel extends Sprite {

    private var background:SliceScalingBitmap;

    private var dimensionText:SimpleText;

    public function SelectionInfoPanel() {
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "tooltip_header_background");
        this.background.alpha = 0.8;
        this.background.x = -4;
        this.background.y = -4;
        addChild(this.background);

        this.dimensionText = new SimpleText(12, 0xB2B2B2);
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
        this.dimensionText.x = 0;
        this.dimensionText.y = 0;
    }

    private function drawBackground():void {
        this.background.width = this.dimensionText.width + 8;
        this.background.height = this.dimensionText.height + 8;
    }
}
}