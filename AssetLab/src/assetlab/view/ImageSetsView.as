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

        this.contentView = new ContentView();
        addChild(this.contentView);

        this.positionChildren();
    }

    private function onFileSelected(e:Event):void {
        // Temporary, only work with model 3d
        this.contentView.displayModel3D(this.fileBrowser.selectedSlot.fileContent);
    }

    private function positionChildren():void {
        this.contentView.x = this.fileBrowser.x + this.fileBrowser.width;
        this.contentView.y = this.fileBrowser.y;
    }

    public function resize():void {
        this.fileBrowser.resize(FileBrowser.WIDTH, FileBrowser.HEIGHT * Global.ScaleY);
        this.positionChildren();
    }

    public function onAssetsLoaded():void {
        this.fileBrowser.repopulateFileList();
    }
}
}
