package assetlab.view {
import assetlab.io.LabAssets;
import assetlab.view.elements.ContentView;
import assetlab.view.elements.ContentViewUI;
import assetlab.view.elements.CreateCutWindow;
import assetlab.view.elements.FileBrowser;
import assetlab.view.elements.SliceEditorWindow;
import assetlab.view.elements.UISliceView;
import assetlab.view.elements.VerticalListSlot;
import assetlab.view.elements.VerticalListView;

import common.assets.AnimatedChars;
import common.ui.TextureParser;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class UIAssetsView extends Sprite {

    private var workspace:WorkspaceView;
    private var atlasList:VerticalListView;
    public var contentView:ContentViewUI;

    private var windowBackground:Shape;
    private var sliceEditorWindow:SliceEditorWindow;

    public function UIAssetsView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.atlasList = new VerticalListView();
        this.atlasList.addEventListener(VerticalListView.SLOT_SELECTED, this.onUIAtlasSelected);
        addChild(this.atlasList);

        this.contentView = new ContentViewUI(this, workspace);
        addChild(this.contentView);

        this.windowBackground = new Shape();
        this.windowBackground.graphics.beginFill(0, 0.8);
        this.windowBackground.graphics.drawRect(0, 0, workspace.contentWidth, workspace.contentHeight);
        this.windowBackground.graphics.endFill();
        this.windowBackground.visible = false;
        addChild(this.windowBackground);

        this.sliceEditorWindow = new SliceEditorWindow(this);
        this.sliceEditorWindow.visible = false;
        addChild(this.sliceEditorWindow);

        this.positionChildren();
    }

    private function positionChildren():void {
        this.contentView.x = this.atlasList.x + this.atlasList.width;
        this.contentView.y = this.atlasList.y;

        this.sliceEditorWindow.x = (this.workspace.contentWidth - this.sliceEditorWindow.width) / 2;
        this.sliceEditorWindow.y = (this.workspace.contentHeight - this.sliceEditorWindow.height) / 2;
    }

    private function onUIAtlasSelected(e:Event):void {
        this.contentView.displayAtlas(this.atlasList.selectedSlot.titleName);
    }

    public function onAssetsLoaded():void {
        this.atlasList.clear();
        for (var key:String in TextureParser.instance.textures) {
            this.atlasList.addSlot(new VerticalListSlot(key));
        }
    }

    public function resize():void {
        this.windowBackground.graphics.clear();
        this.windowBackground.graphics.beginFill(0, 0.9);
        this.windowBackground.graphics.drawRect(0, 0, workspace.contentWidth, workspace.contentHeight);
        this.windowBackground.graphics.endFill();
        this.atlasList.resize(VerticalListView.WIDTH, this.workspace.contentHeight);
        this.contentView.resize();
        this.sliceEditorWindow.resize();
        this.positionChildren();
    }

    public function saveCut(cutName:String, cutRect:Rectangle, sliceType:String, sliceRect:Rectangle):void {
        this.showSliceEditor(false, cutName, cutRect, sliceType, sliceRect);
        this.contentView.saveCut(cutName, cutRect, sliceType, sliceRect);
    }

    public function showSliceEditor(val:Boolean, cutName:String, cutRect:Rectangle, sliceType:String, sliceRect:Rectangle):void {
        this.windowBackground.visible = val;
        this.sliceEditorWindow.visible = val;
        if (val) {
            this.sliceEditorWindow.setSliceData(cutName, cutRect, sliceType, sliceRect);
        }
        else{
            this.contentView.saveCut(null, null, null, null);
        }
    }
}
}
