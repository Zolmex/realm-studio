package assetlab.view {
import assetlab.io.LabAssets;
import assetlab.view.elements.ContentView;
import assetlab.view.elements.FileBrowser;
import assetlab.view.elements.VerticalListSlot;
import assetlab.view.elements.VerticalListView;

import common.Global;
import common.assets.AnimatedChars;
import common.assets.AssetLibrary;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.Event;
import flash.filesystem.File;

public class ImageSetsView extends Sprite { // Used for visualizing and working with sprite sheets (static or animated)

    private var workspace:WorkspaceView;
    private var imageSetList:VerticalListView;
    private var contentView:ContentView;
    private var mouseTriggerArea:Shape;

    public function ImageSetsView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.mouseTriggerArea = new Shape();
        this.mouseTriggerArea.graphics.beginFill(0, 0);
        this.mouseTriggerArea.graphics.drawRect(0, 0, workspace.contentWidth, workspace.contentHeight);
        this.mouseTriggerArea.graphics.endFill();
        addChild(this.mouseTriggerArea);

        this.imageSetList = new VerticalListView();
        this.imageSetList.addEventListener(VerticalListView.SLOT_SELECTED, this.onImageTypeSelected);
        addChild(this.imageSetList);

        this.contentView = new ContentView(workspace);
        addChild(this.contentView);

        this.positionChildren();
    }

    private function onImageTypeSelected(e:Event):void {
        this.contentView.displayContent(this.imageSetList.selectedSlot.titleName);
    }

    private function positionChildren():void {
        this.contentView.x = this.imageSetList.x + this.imageSetList.width;
        this.contentView.y = this.imageSetList.y;
    }

    public function resize():void {
        this.imageSetList.resize(VerticalListView.WIDTH, this.workspace.contentHeight);
        this.contentView.resize();
        this.positionChildren();

        this.mouseTriggerArea.graphics.clear();
        this.mouseTriggerArea.graphics.beginFill(0, 0);
        this.mouseTriggerArea.graphics.drawRect(0, 0, workspace.contentWidth, workspace.contentHeight);
        this.mouseTriggerArea.graphics.endFill();
    }

    public function onAssetsLoaded():void {
        this.imageSetList.clear();
        var key:String;
        for (key in AssetLibrary.images_) {
            this.imageSetList.addSlot(new VerticalListSlot(key));
        }
        for (key in AnimatedChars.nameMap_) {
            this.imageSetList.addSlot(new VerticalListSlot(key));
        }
    }
}
}
