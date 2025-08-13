package assetlab.view.elements {
import assetlab.view.UIAssetsView;
import assetlab.view.WorkspaceView;

import common.Global;

import common.assets.AnimatedChar;

import common.assets.AnimatedChars;

import common.assets.ImageSet;
import common.ui.TextureParser;
import common.ui.elements.SimpleCheckBox;
import common.ui.elements.SimpleTextInput;
import common.ui.elements.SimplestCheckBox;
import common.util.IntPoint;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.display.BitmapData;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;

public class ContentViewUI extends Sprite { // Visualizer for UI Atlas and cut/slice configuration tool

    private static const MAX_ZOOM:Number = 500;

    [Embed("../embed/CheckboardBackground.png")]
    private static const CheckboardBackground:Class;
    private var checkboardTexture:BitmapData;

    private var view:UIAssetsView;
    private var workspace:WorkspaceView;
    private var content:Sprite;
    private var contentBackground:Shape;
    private var bitmapLayer:Sprite;
    private var outlineLayer:Sprite;
    private var contentMask:Shape;
    private var contentInput:InputHandler;
    private var zoomLevel:int = 100;
    private var zoomInput:SimpleTextInput;
    private var contentOffset:Point = new Point();
    private var mouseTriggerArea:Shape;

    private var selecting:Boolean;
    private var selectionStartPos:Point;
    private var selectionOutline:Shape;
    private var selectionRect:Rectangle = new Rectangle();
    private var allowSelection:Boolean = true;

    private var atlasName:String;
    private var cutConfigs:Object; // JSON objects
    private var gridConfigs:Object;

    public function ContentViewUI(view:UIAssetsView, workspace:WorkspaceView) {
        this.view = view;
        this.workspace = workspace;

        this.checkboardTexture = (new CheckboardBackground() as Bitmap).bitmapData;
        this.contentBackground = new Shape();

        this.mouseTriggerArea = new Shape();
        this.mouseTriggerArea.graphics.beginFill(0, 0);
        this.mouseTriggerArea.graphics.drawRect(0, 0, workspace.contentWidth - VerticalListView.WIDTH, workspace.contentHeight);
        this.mouseTriggerArea.graphics.endFill();
        addChild(this.mouseTriggerArea);

        this.bitmapLayer = new Sprite();
        this.outlineLayer = new Sprite();
        this.selectionOutline = new Shape();
        this.outlineLayer.addChild(this.selectionOutline);

        this.content = new Sprite();
        this.content.addChild(this.contentBackground);
        this.content.addChild(this.bitmapLayer);
        this.content.addChild(this.outlineLayer);
        addChild(this.content);

        this.contentMask = new Shape();
        this.contentMask.graphics.beginFill(0);
        this.contentMask.graphics.drawRect(0, 0, workspace.contentWidth - VerticalListView.WIDTH - 1, workspace.contentHeight);
        this.contentMask.graphics.endFill();
        this.content.mask = this.contentMask;
        addChild(this.contentMask);

        this.zoomInput = new SimpleTextInput("Zoom", false, "100");
        this.zoomInput.inputText.restrict = "0-9";
        this.zoomInput.inputText.maxChars = 3;
        this.zoomInput.inputText.addEventListener(Event.CHANGE, this.onZoomInputChange);
        addChild(this.zoomInput);

        this.contentInput = new InputHandler(this.content);
        this.contentInput.addEventListener(InputHandler.MOUSE_DRAG, this.onMouseDrag);
        this.contentInput.addEventListener(InputHandler.MOUSE_DRAG_END, this.onMouseDragEnd);
        this.contentInput.addEventListener(InputHandler.MIDDLE_MOUSE_DRAG, this.onContentDrag);

        addEventListener(MouseEvent.MOUSE_WHEEL, this.onScroll);

        this.positionChildren();
    }

    private function positionChildren():void {
        this.fixContentPosition();
    }

    private function fixContentPosition():void {
        this.content.x = 0;
        this.content.y = 0;
        this.content.x += this.contentOffset.x * this.zoomLevel / MAX_ZOOM;
        this.content.y += this.contentOffset.y * this.zoomLevel / MAX_ZOOM;

        var viewWidth:int = this.workspace.contentWidth - VerticalListView.WIDTH;
        if (this.content.width > viewWidth) { // Bigger than visible space
            if (this.content.x > 0) { // Left limit
                this.content.x = 0;
            }
            if (this.content.x + this.content.width < viewWidth) { // Right limit
                this.content.x = viewWidth - this.content.width;
            }
        }
        else {
            if (this.content.x < 0) { // Left limit
                this.content.x = 0;
            }
            if (this.content.x + this.content.width > viewWidth) { // Right limit
                this.content.x = viewWidth - this.content.width;
            }
        }

        if (this.content.height > this.workspace.contentHeight) {
            if (this.content.y > 0) { // Up limit
                this.content.y = 0;
            }
            if (this.content.y + this.content.height < this.workspace.contentHeight) { // Bottom limit
                this.content.y = this.workspace.contentHeight - this.content.height;
            }
        }
        else {
            if (this.content.y < 0) { // Up limit
                this.content.y = 0;
            }
            if (this.content.y + this.content.height > this.workspace.contentHeight) { // Bottom limit
                this.content.y = this.workspace.contentHeight - this.content.height;
            }
        }
    }

    private function onZoomInputChange(e:Event):void {
        var zoomLevel:int = int(this.zoomInput.inputText.text);
        if (this.zoomLevel == zoomLevel) {
            return;
        }

        this.zoomLevel = zoomLevel;
        this.updateZoomLevel();
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
            this.contentOffset.x += deltaX * zoom;
            this.contentOffset.y += deltaY * zoom;

            this.updateZoomLevel();
        }
    }

    private function updateZoomLevel():void {
        this.zoomInput.inputText.setText(this.zoomLevel.toString());

        this.content.scaleX = this.zoomLevel / 100;
        this.content.scaleY = this.zoomLevel / 100;
        if (this.content.scaleX < 0.01 || this.content.scaleY < 0.01) {
            this.content.scaleX = 0.01;
            this.content.scaleY = 0.01;
        }

        this.fixContentPosition();
    }

    private function onContentDrag(e:InputHandlerEvent):void {
        var delta:Point = e.value as Point;
        var zoom:Number = Math.max(1, Math.min(MAX_ZOOM, MAX_ZOOM / this.zoomLevel));
        this.contentOffset.x += delta.x * zoom;
        this.contentOffset.y += delta.y * zoom;
        this.fixContentPosition();
    }

    private function onMouseDrag(e:InputHandlerEvent):void {
        if (!this.allowSelection){
            return;
        }

        var cursorTexturePos:Point = this.getCursorPixel();
        if (!this.selecting) {
            this.selecting = true;
            this.selectionStartPos = new Point(cursorTexturePos.x, cursorTexturePos.y);
            return;
        }

        var x:int = this.selectionStartPos.x;
        var y:int = this.selectionStartPos.y;
        var w:int = cursorTexturePos.x - this.selectionStartPos.x;
        var h:int = cursorTexturePos.y - this.selectionStartPos.y;
        if (w < 0){
            w *= -1; // Make the width positive
            x -= w; // Move back the x origin of the outline rectangle by the width
        }
        if (h < 0){
            h *= -1;
            y -= h;
        }

        this.selectionRect.x = x;
        this.selectionRect.y = y;
        this.selectionRect.width = w;
        this.selectionRect.height = h;

        this.selectionOutline.graphics.clear();
        this.selectionOutline.graphics.lineStyle(1, 0xFF0000, 0.9);
        this.selectionOutline.graphics.drawRect(0, 0, w, h);
        this.selectionOutline.graphics.lineStyle();
        this.selectionOutline.x = x;
        this.selectionOutline.y = y;
    }

    private function onMouseDragEnd(e:InputHandlerEvent):void {
        if (!this.selecting) {
            return;
        }

        this.allowSelection = false;
        this.selecting = false;
        this.selectionStartPos = null;
        this.showCreateCutWindow();
    }

    private function showCreateCutWindow():void {
        this.view.showCreateCutWindow(true, this.selectionRect);
    }

    private function getCursorPixel():Point {
        var mousePos:Point = new Point(Global.Main.stage.mouseX, Global.Main.stage.mouseY);
        var bitmapPos:Point = this.localToGlobal(new Point(this.content.x, this.content.y));
        var pixelWidth:Number = this.content.scaleX;
        var pixelHeight:Number = this.content.scaleY;

        var yDiff:Number = mousePos.y - bitmapPos.y; // These numbers should always be positive
        var xDiff:Number = mousePos.x - bitmapPos.x;
        var x:int = xDiff / pixelWidth;
        var y:int = yDiff / pixelHeight;
        return new Point(x, y);
    }

    public function displayAtlas(atlasName:String):void {
        var atlasObj:Object;
        if (atlasName in TextureParser.instance.textures) {
            atlasObj = TextureParser.instance.textures[atlasName];
        }
        else {
            trace("Invalid atlas name:", atlasName);
            return;
        }

        var atlas:Bitmap = atlasObj["texture"];
        this.atlasName = atlasName;
        this.cutConfigs = atlasObj["configuration"];
        this.gridConfigs = atlasObj["sliceRectangles"];

        this.bitmapLayer.removeChildren();
        this.bitmapLayer.addChild(atlas);

        this.outlineLayer.removeChildren();
        this.outlineLayer.addChild(this.selectionOutline);

        this.contentBackground.graphics.clear();
        this.contentBackground.graphics.beginBitmapFill(this.checkboardTexture);
        this.contentBackground.graphics.drawRect(0, 0, atlas.width, atlas.height);
        this.contentBackground.graphics.endFill();
    }

    public function resize():void {
        this.contentMask.graphics.clear();
        this.contentMask.graphics.beginFill(0);
        this.contentMask.graphics.drawRect(0, 0, this.workspace.contentWidth - VerticalListView.WIDTH - 1, this.workspace.contentHeight);
        this.contentMask.graphics.endFill();
        this.mouseTriggerArea.graphics.clear();
        this.mouseTriggerArea.graphics.beginFill(0, 0);
        this.mouseTriggerArea.graphics.drawRect(0, 0, workspace.contentWidth - VerticalListView.WIDTH, workspace.contentHeight);
        this.mouseTriggerArea.graphics.endFill();
        this.positionChildren();
    }

    public function onCutCreated(cutRect:Rectangle):void {
        this.allowSelection = true;
        // TODO: add new cut to cuts list and draw it
    }
}
}
