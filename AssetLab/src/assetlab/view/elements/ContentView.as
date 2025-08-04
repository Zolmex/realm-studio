package assetlab.view.elements {
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
import common.ui.elements.SimpleScrollbar;
import common.ui.elements.SimpleTextInput;

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

    protected var workspace:WorkspaceView;
    private var content:Sprite;
    private var contentMask:Shape;
    private var pngCache:Dictionary = new Dictionary();
    private var scrollbar:SimpleScrollbar;
    private var scaleInput:SimpleTextInput;

    public function ContentView(workspace:WorkspaceView, model3DContent:Boolean = false) {
        this.workspace = workspace;

        if (model3DContent){
            return;
        }

        this.content = new Sprite();
        this.content.scaleX = 5;
        this.content.scaleY = 5;
        addChild(this.content);

        this.contentMask = new Shape();
        this.contentMask.graphics.beginFill(0);
        this.contentMask.graphics.drawRect(0, 0, workspace.contentWidth - FileBrowser.WIDTH - 1, workspace.contentHeight);
        this.contentMask.graphics.endFill();
        this.content.mask = this.contentMask;
        addChild(this.contentMask);

        this.scrollbar = new SimpleScrollbar();
        this.scrollbar.setup(workspace.contentHeight, 0, 0);
        this.scrollbar.addEventListener(Event.CHANGE, this.onScrollbarChange);
        addChild(this.scrollbar);

        this.scaleInput = new SimpleTextInput("Scale", true, "5");
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
        this.scrollbar.x = this.workspace.contentWidth - FileBrowser.WIDTH - 1 - this.scrollbar.width - 1;
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

    public virtual function resize():void {
        this.contentMask.graphics.clear();
        this.contentMask.graphics.beginFill(0);
        this.contentMask.graphics.drawRect(0, 0, this.workspace.contentWidth - FileBrowser.WIDTH - 1, this.workspace.contentHeight);
        this.contentMask.graphics.endFill();
        this.scrollbar.setup(this.workspace.contentHeight, this.content.y, this.content.height - this.workspace.contentHeight);
        this.positionChildren();
    }

    public function displayContent(fileName:String, pngBytes:ByteArray):void {
        var pngImage:Bitmap;
        if (fileName in this.pngCache) {
            pngImage = this.pngCache[fileName];
        }
        else {
            pngImage = new Bitmap(BitmapData.decode(pngBytes));
            this.pngCache[fileName] = pngImage;
        }

        this.content.removeChildren();
        this.content.addChild(pngImage);

        this.fixListPosition();
        this.scrollbar.setup(this.workspace.contentHeight, this.content.y, this.content.height - this.workspace.contentHeight);
    }
}
}
