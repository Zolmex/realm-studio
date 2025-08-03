package assetlab.view {
import assetlab.io.LabAssets;
import assetlab.view.elements.ContentView;
import assetlab.view.elements.FileBrowser;

import common.Global;

import flash.display.Sprite;
import flash.events.Event;

public class ImageSetsView extends Sprite {

    private var workspace:WorkspaceView;
    private var fileBrowser:FileBrowser;
    private var contentView:ContentView;

    public function ImageSetsView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.fileBrowser = new FileBrowser(LabAssets.imageFiles);
        this.fileBrowser.addEventListener(FileBrowser.FILE_SELECTED, this.onFileSelected);
        addChild(this.fileBrowser);

        this.contentView = new ContentView(workspace);
        addChild(this.contentView);

        this.positionChildren();
    }

    private function onFileSelected(e:Event):void {

    }

    private function positionChildren():void {
        this.contentView.x = this.fileBrowser.x + this.fileBrowser.width;
        this.contentView.y = this.fileBrowser.y;
    }

    public function resize():void {
        this.fileBrowser.resize(FileBrowser.WIDTH, this.workspace.contentHeight);
        this.contentView.resize();
        this.positionChildren();
    }

    public function onAssetsLoaded():void {
        this.fileBrowser.repopulateFileList();
    }
}
}
