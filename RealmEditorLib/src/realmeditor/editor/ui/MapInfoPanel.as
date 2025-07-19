package realmeditor.editor.ui {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;

import realmeditor.assets.AssetLibrary;
import realmeditor.editor.ui.elements.SimpleText;
import realmeditor.editor.ui.embed.SliceScalingBitmap;
import realmeditor.editor.ui.embed.TextureParser;

public class MapInfoPanel extends Sprite {

    private static const IMAGE_SIZE:int = 20;

    private var background:SliceScalingBitmap;
    private var content:Sprite;

    private var dimensionText:SimpleText;
    private var pencilButton:Bitmap;
    private var pencilTexture:BitmapData;

    public function MapInfoPanel() {
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "tooltip_header_background");
        this.background.alpha = 0.8;
        this.background.x = -4;
        this.background.y = -4;
        addChild(this.background);

        this.content = new Sprite();
        addChild(this.content);

        this.dimensionText = new SimpleText(12, 0xFFFFFF);
        this.dimensionText.filters = Constants.SHADOW_FILTER_1;
        this.content.addChild(this.dimensionText);

        this.pencilButton = new Bitmap(null);
        this.content.addChild(this.pencilButton);

        filters = Constants.SHADOW_FILTER_1;
    }

    public function setInfo(x:int, y:int):void {
        this.dimensionText.setText("W: " + x.toString() + " H: " + y.toString());
        this.dimensionText.useTextDimensions();

        this.fixPositions();
        this.drawBackground();
    }

    private function fixPositions():void {
        dimensionText.x = 0;
        dimensionText.y = 0;

        if (this.pencilTexture == null) {
            var pencilTex:BitmapData = AssetLibrary.getImageFromSet("editorTools", 1)
            var matrix:Matrix = new Matrix();
            matrix.scale(IMAGE_SIZE / pencilTex.width, IMAGE_SIZE / pencilTex.height);
            this.pencilTexture = new BitmapData(IMAGE_SIZE, IMAGE_SIZE, true, 0);
            this.pencilTexture.draw(pencilTex, matrix);
            this.pencilButton.bitmapData = this.pencilTexture;
        }

        pencilButton.x = dimensionText.x + dimensionText.width + 4;
        pencilButton.y = 0;
    }

    private function drawBackground():void {
        this.background.width = this.content.width + 8;
        this.background.height = this.content.height + 8;
    }
}
}