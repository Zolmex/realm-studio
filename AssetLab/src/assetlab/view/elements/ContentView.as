package assetlab.view.elements {
import assetlab.io.LabAssets;
import assetlab.view.MainView;
import assetlab.view.WorkspaceView;

import away3d.containers.ObjectContainer3D;

import away3d.containers.View3D;
import away3d.core.base.Geometry;
import away3d.core.base.Object3D;
import away3d.core.pick.PickingColliderType;
import away3d.core.pick.PickingType;
import away3d.entities.Mesh;
import away3d.events.AssetEvent;
import away3d.events.MouseEvent3D;
import away3d.events.ParserEvent;
import away3d.loaders.Loader3D;
import away3d.loaders.parsers.OBJParser;
import away3d.loaders.parsers.Parsers;
import away3d.materials.TextureMaterial;
import away3d.primitives.PlaneGeometry;
import away3d.utils.Cast;

import common.Global;
import common.assets.AnimatedChar;
import common.assets.AnimatedChars;
import common.assets.AssetLibrary;
import common.assets.ImageSet;
import common.ui.elements.SimpleScrollbar;
import common.ui.elements.SimpleTextInput;
import common.ui.elements.TextTooltip;
import common.util.BitmapUtil;
import common.util.PointUtil;
import common.util.TextureRedrawer;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.display.BlendMode;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class ContentView extends Sprite { // Visualizer for .png images and 3D models

    private static const ROW_SIZE:int = 16;

    private var workspace:WorkspaceView;
    private var content:Sprite;
    private var bitmapContainer:Sprite;
    private var outlineLayer:Shape;
    private var contentMask:Shape;
    private var scrollbar:SimpleScrollbar;
    private var scaleInput:SimpleTextInput;
    private var tooltip:TextTooltip;
    private var mouseTriggerArea:Shape;
    private var assetTitle:String;
    private var animated:Boolean;

    private const contentCache:Dictionary = new Dictionary(); // Save loaded image sets here

    public function ContentView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.bitmapContainer = new Sprite();
        this.outlineLayer = new Shape();
        this.mouseTriggerArea = new Shape();

        this.content = new Sprite();
        this.content.scaleX = 2;
        this.content.scaleY = 2;
        this.content.addChild(this.mouseTriggerArea)
        this.content.addChild(this.bitmapContainer); // Bitmap layer
        this.content.addChild(this.outlineLayer);
        this.content.addEventListener(MouseEvent.ROLL_OVER, this.onMouseOverContent);
        this.content.addEventListener(MouseEvent.ROLL_OUT, this.onMouseOutContent);
        addChild(this.content);

        this.contentMask = new Shape();
        this.contentMask.graphics.beginFill(0);
        this.contentMask.graphics.drawRect(0, 0, workspace.contentWidth - VerticalListView.WIDTH - 1, workspace.contentHeight);
        this.contentMask.graphics.endFill();
        this.content.mask = this.contentMask;
        addChild(this.contentMask);

        this.scrollbar = new SimpleScrollbar();
        this.scrollbar.setup(workspace.contentHeight, 0, 0);
        this.scrollbar.addEventListener(Event.CHANGE, this.onScrollbarChange);
        addChild(this.scrollbar);

        this.scaleInput = new SimpleTextInput("Scale", false, "2");
        this.scaleInput.inputText.restrict = "0-9";
        this.scaleInput.inputText.maxChars = 2;
        this.scaleInput.inputText.addEventListener(Event.CHANGE, this.onScaleChange);
        addChild(this.scaleInput);

        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);

        this.positionChildren();
    }

    private function onAddedToStage(e:Event):void {
        parent.addEventListener(MouseEvent.MOUSE_WHEEL, this.onScroll);
    }

    private function onScaleChange(e:Event):void {
        var scale:int = int(this.scaleInput.inputText.text);
        this.content.scaleX = scale;
        this.content.scaleY = scale;
        this.fixListPosition();
        this.scrollbar.setup(this.workspace.contentHeight, this.content.y, this.content.height - this.workspace.contentHeight);
    }

    private function positionChildren():void {
        this.scrollbar.x = this.workspace.contentWidth - VerticalListView.WIDTH - 1 - this.scrollbar.width - 1;
        this.scaleInput.x = this.scrollbar.x - this.scaleInput.width - 3;
        this.fixListPosition();
    }

    private function onScrollbarChange(e:Event):void {
        this.content.y = -this.scrollbar.cursorPos;
        this.fixListPosition();
    }

    private function onScroll(e:MouseEvent):void {
        e.stopImmediatePropagation();
        var scroll:Number = e.delta * 10;
        this.content.y += scroll;
        this.fixListPosition();
        this.scrollbar.update(this.content.y);
    }

    private function fixListPosition():void {
        if (this.content.y > 0) { // Top limit
            this.content.y = 0;
        }
        if (this.content.height < this.workspace.contentHeight) { // If the elements container is smaller than the view, don't scroll
            this.content.y = 0;
        } else if (this.content.y < -this.content.height + this.workspace.contentHeight) { // Bottom limit
            this.content.y = -this.content.height + this.workspace.contentHeight;
        }
    }

    public function resize():void {
        this.contentMask.graphics.clear();
        this.contentMask.graphics.beginFill(0);
        this.contentMask.graphics.drawRect(0, 0, this.workspace.contentWidth - VerticalListView.WIDTH - 1, this.workspace.contentHeight);
        this.contentMask.graphics.endFill();
        this.scrollbar.setup(this.workspace.contentHeight, this.content.y, this.content.height - this.workspace.contentHeight);
        this.positionChildren();
    }

    public function displayContent(titleName:String):void {
        var animated:Boolean = false;
        var imageDatas:Vector.<BitmapData>; // Get the list of images in this sprite sheet
        if (titleName in AssetLibrary.images_) {
            imageDatas = (AssetLibrary.imageSets_[titleName] as ImageSet).images_;
        }
        else if (titleName in AnimatedChars.nameMap_) {
            animated = true;
            imageDatas = new Vector.<BitmapData>();
            for each (var chr:AnimatedChar in AnimatedChars.nameMap_[titleName]){
                imageDatas.push(chr.origImage_.image_);
            }
        }
        else {
            trace("Invalid content", titleName);
            return;
        }

        this.assetTitle = titleName;
        this.animated = animated;

        this.addImages(titleName, imageDatas, animated);

        this.mouseTriggerArea.graphics.clear();
        this.mouseTriggerArea.graphics.beginFill(0, 0); // Redraw mouse area
        this.mouseTriggerArea.graphics.drawRect(0, 0, this.bitmapContainer.width, this.bitmapContainer.height);
        this.mouseTriggerArea.graphics.endFill();

        this.fixListPosition();
        this.scrollbar.setup(this.workspace.contentHeight, this.content.y, this.content.height - this.workspace.contentHeight);
    }

    private function addImages(titleName:String, imageDatas:Vector.<BitmapData>, animated:Boolean):void {
        var bmp:Bitmap;
        this.bitmapContainer.removeChildren();

        if (titleName in this.contentCache){ // Load from cache to avoid allocating new bitmaps
            for each (bmp in this.contentCache[titleName]){
                this.insertBitmap(bmp, animated);
            }
            return;
        }

        this.contentCache[titleName] = new Vector.<Bitmap>();
        for each (var image:BitmapData in imageDatas){ // Load the redrawn textures into bitmaps
            bmp = new Bitmap(image);
            bmp.scaleX = 2.5;
            bmp.scaleY = 2.5;
            this.insertBitmap(bmp, animated);
            this.contentCache[titleName].push(bmp);
        }
    }

    private function insertBitmap(bmp:Bitmap, animated:Boolean):void {
        var i:int = this.bitmapContainer.numChildren;
        if (!animated) {
            bmp.x = bmp.width * int(i % ROW_SIZE);
            bmp.y = bmp.height * int(i / ROW_SIZE);
        }
        else{
            bmp.y = bmp.height * i;
        }
        this.bitmapContainer.addChild(bmp);
    }

    private function onMouseOverContent(e:MouseEvent):void {
        this.addEventListener(Event.ENTER_FRAME, this.update);
        if (this.tooltip == null) {
            this.tooltip = new TextTooltip(this.content, "none");
            this.tooltip.setSubText("none");
            Global.Main.stage.addChild(this.tooltip);
        }

        this.updateTooltipText();
    }

    private function onMouseOutContent(e:MouseEvent):void {
        this.removeEventListener(Event.ENTER_FRAME, this.update);
    }

    private function update(e:Event):void {
        if (!this.tooltip.visible){
            return;
        }

        this.updateTooltipText();
    }

    private function updateTooltipText():void {
        var i:int; // Find index based on position
        var mousePos:Point = new Point(Global.Main.stage.mouseX, Global.Main.stage.mouseY);
        var bitmapPos:Point = this.content.localToGlobal(new Point(this.bitmapContainer.x, this.bitmapContainer.y));
        var texture:Bitmap = this.contentCache[this.assetTitle][0] as Bitmap;
        var texWidth:int = texture.width * 2;
        var texHeight:int = texture.height * 2;

        var yDiff:Number = mousePos.y - bitmapPos.y; // These numbers should always be positive
        var xDiff:Number = mousePos.x - bitmapPos.x;
        if (this.animated){ // Animated sheets' textures are put one below the other
            i = int(yDiff / texHeight);
        }
        else {
            var row:int = int(yDiff / texHeight);
            var column:int = int(xDiff / texWidth);
            i = row * ROW_SIZE + column;
        }

        this.tooltip.setTitle(this.assetTitle);
        this.tooltip.setSubText("0x" + i.toString(16));
    }
}
}
