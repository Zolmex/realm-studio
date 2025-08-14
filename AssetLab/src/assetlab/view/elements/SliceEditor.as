package assetlab.view.elements {
import common.Global;
import common.util.BitmapUtil;
import common.util.TextureRedrawer;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.JointStyle;
import flash.display.PixelSnapping;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

public class SliceEditor extends Sprite {

    private static const MAX_ZOOM:int = 1500;

    private var checkboardTexture:BitmapData;

    private var window:SliceEditorWindow;
    private var background:Shape;
    private var canvas:Sprite;
    private var outlineLayer:Shape;

    private var atlas:Bitmap;
    private var cutRect:Rectangle;
    private var sliceRect:Rectangle;
    private var zoomLevel:int = 200;
    private var canvasOffset:Point = new Point();
    private var input:InputHandler;
    private var mouseTriggerArea:Shape;

    public function SliceEditor(window:SliceEditorWindow) {
        this.window = window;

        this.checkboardTexture = (new ContentViewUI.CheckboardBackground() as Bitmap).bitmapData;
        this.background = new Shape();
        this.background.graphics.clear();
        this.background.graphics.beginBitmapFill(this.checkboardTexture);
        this.background.graphics.drawRect(0, 0, SliceEditorWindow.EDITOR_WIDTH, SliceEditorWindow.EDITOR_HEIGHT);
        this.background.graphics.endFill();
        addChild(this.background);

        this.mouseTriggerArea = new Shape();
        this.mouseTriggerArea.graphics.beginFill(0, 0);
        this.mouseTriggerArea.graphics.drawRect(0, 0, SliceEditorWindow.EDITOR_WIDTH, SliceEditorWindow.EDITOR_HEIGHT);
        this.mouseTriggerArea.graphics.endFill();
        addChild(this.mouseTriggerArea);

        this.canvas = new Sprite();
        this.canvas.scaleX = 2;
        this.canvas.scaleY = 2;
        addChild(this.canvas);

        this.outlineLayer = new Shape();
        addChild(this.outlineLayer);

        this.input = new InputHandler(this);
        this.input.addEventListener(InputHandler.MIDDLE_MOUSE_DRAG, this.onContentDrag);

        addEventListener(MouseEvent.MOUSE_WHEEL, this.onScroll);
    }

    private function onScroll(e:MouseEvent):void { // Recycling code from MapEditor.MainView :))
        var zoomLevel:int = this.zoomLevel + (this.zoomLevel / e.delta + 1); // + 1 for divisions that result in less than 1
        zoomLevel = Math.max(1, Math.min(zoomLevel, MAX_ZOOM));

        if (this.zoomLevel != zoomLevel) {
            this.zoomLevel = zoomLevel;
            var deltaX:Number = Global.StageWidth / 2 - Global.Main.stage.mouseX; // Figure out how far from the middle the mouse is
            var deltaY:Number = Global.StageHeight / 2 - Global.Main.stage.mouseY;
            if (e.delta < 0) { // Invert the order if we're zooming out
                deltaX *= -1;
                deltaY *= -1;
            }

            var zoom:Number = Math.max(1, Math.min(MAX_ZOOM, MAX_ZOOM / this.zoomLevel));
            this.canvasOffset.x += deltaX * zoom;
            this.canvasOffset.y += deltaY * zoom;

            this.updateScale();
        }
    }

    private function updateScale():void {
        this.canvas.scaleX = this.zoomLevel / 100;
        this.canvas.scaleY = this.zoomLevel / 100;
        if (this.canvas.scaleX < 0.1 || this.canvas.scaleY < 0.1) {
            this.canvas.scaleX = 0.1;
            this.canvas.scaleY = 0.1;
        }

        this.drawSliceLines();

        this.positionChildren();
    }

    private function onContentDrag(e:InputHandlerEvent):void {
        var delta:Point = e.value as Point;
        var zoom:Number = Math.max(1, Math.min(MAX_ZOOM, MAX_ZOOM / this.zoomLevel));
        this.canvasOffset.x += delta.x * zoom;
        this.canvasOffset.y += delta.y * zoom;
        this.positionChildren();
    }

    private function drawSliceLines():void {
        if (this.sliceRect == null){
            return;
        }

        this.outlineLayer.graphics.clear();
        this.outlineLayer.graphics.lineStyle(2, 0x0000FF, 0.8, false, "normal", null, JointStyle.MITER);

        var sliceX:Number = this.sliceRect.x;
        var sliceY:Number = this.sliceRect.y;
        var sliceWidth:Number = this.sliceRect.width;
        var sliceHeight:Number = this.sliceRect.height;

        sliceX *= this.canvas.scaleX;
        sliceY *= this.canvas.scaleY;
        sliceWidth *= this.canvas.scaleX;
        sliceHeight *= this.canvas.scaleY;

        if (sliceX != 0) {
            this.outlineLayer.graphics.moveTo(sliceX, 0); // Horizontal lines
            this.outlineLayer.graphics.lineTo(sliceX, this.canvas.height);
            this.outlineLayer.graphics.moveTo(sliceX + sliceWidth, 0);
            this.outlineLayer.graphics.lineTo(sliceX + sliceWidth, this.canvas.height);
        }

        if (sliceY != 0) {
            this.outlineLayer.graphics.moveTo(0, sliceY); // Vertical lines
            this.outlineLayer.graphics.lineTo(this.canvas.width, sliceY);
            this.outlineLayer.graphics.moveTo(0, sliceY + sliceHeight);
            this.outlineLayer.graphics.lineTo(this.canvas.width, sliceY + sliceHeight);
        }

        this.outlineLayer.graphics.lineStyle();
    }

    private function positionChildren():void {
        this.canvas.x = (this.window.editorWidth - this.canvas.width) / 2;
        this.canvas.y = (this.window.editorHeight - this.canvas.height) / 2;
        this.canvas.x += this.canvasOffset.x * this.zoomLevel / MAX_ZOOM;
        this.canvas.y += this.canvasOffset.y * this.zoomLevel / MAX_ZOOM;
        this.outlineLayer.x = this.canvas.x;
        this.outlineLayer.y = this.canvas.y;
    }

    public function displayTexture(atlas:Bitmap, cutRect:Rectangle, sliceRect:Rectangle):void { // Slice type is irrelevant here, the slice lines are drawn exactly the same
        if (this.atlas != atlas || this.cutRect != cutRect) { // Texture update
            this.canvas.removeChildren();
            this.outlineLayer.graphics.clear();

            var cropped:BitmapData = BitmapUtil.cropToBitmapData(atlas.bitmapData, cutRect.x, cutRect.y, cutRect.width, cutRect.height);
            var tex:Bitmap = new Bitmap(cropped, PixelSnapping.ALWAYS);
            this.canvas.addChild(tex);
        }

        this.sliceRect = sliceRect.clone();

        this.drawSliceLines();
        this.positionChildren();
    }

    public function resize():void {
        this.background.graphics.clear();
        this.background.graphics.beginBitmapFill(this.checkboardTexture);
        this.background.graphics.drawRect(0, 0, this.window.editorWidth, this.window.editorHeight);
        this.background.graphics.endFill();
        this.mouseTriggerArea.graphics.clear();
        this.mouseTriggerArea.graphics.beginFill(0, 0);
        this.mouseTriggerArea.graphics.drawRect(0, 0, this.window.editorWidth, this.window.editorHeight);
        this.mouseTriggerArea.graphics.endFill();
        this.positionChildren();
    }
}
}
