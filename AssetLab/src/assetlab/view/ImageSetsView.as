package assetlab.view {
import assetlab.io.LabAssets;
import assetlab.view.elements.ContentView;
import assetlab.view.elements.FileBrowser;

import common.Global;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.Event;
import flash.filesystem.File;

public class ImageSetsView extends Sprite {

    private var workspace:WorkspaceView;
    private var fileBrowser:FileBrowser;
    private var contentView:ContentView;
    private var mouseTriggerArea:Shape;

    public function ImageSetsView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.mouseTriggerArea = new Shape();
        this.mouseTriggerArea.graphics.beginFill(0, 0);
        this.mouseTriggerArea.graphics.drawRect(0, 0, workspace.contentWidth, workspace.contentHeight);
        this.mouseTriggerArea.graphics.endFill();
        addChild(this.mouseTriggerArea);

        this.fileBrowser = new FileBrowser(LabAssets.imageFiles);
        this.fileBrowser.addEventListener(FileBrowser.FILE_SELECTED, this.onFileSelected);
        addChild(this.fileBrowser);

        this.contentView = new ContentView(workspace);
        addChild(this.contentView);

        this.positionChildren();
    }

    private function onFileSelected(e:Event):void {
        this.contentView.displayContent(this.fileBrowser.selectedSlot.file.name, this.fileBrowser.selectedSlot.fileContent);
    }

    private function positionChildren():void {
        this.contentView.x = this.fileBrowser.x + this.fileBrowser.width;
        this.contentView.y = this.fileBrowser.y;
    }

    public function resize():void {
        this.fileBrowser.resize(FileBrowser.WIDTH, this.workspace.contentHeight);
        this.contentView.resize();
        this.positionChildren();

        this.mouseTriggerArea.graphics.clear();
        this.mouseTriggerArea.graphics.beginFill(0, 0);
        this.mouseTriggerArea.graphics.drawRect(0, 0, workspace.contentWidth, workspace.contentHeight);
        this.mouseTriggerArea.graphics.endFill();
    }

    public function onAssetsLoaded():void {
        this.fileBrowser.repopulateFileList();
    }
}
}
