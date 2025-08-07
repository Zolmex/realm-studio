package assetlab.view {
import assetlab.io.LabAssets;
import assetlab.view.elements.ContentView;
import assetlab.view.elements.ContentView3D;
import assetlab.view.elements.FileBrowser;
import assetlab.view.elements.VerticalListView;

import common.Global;

import flash.display.Sprite;
import flash.events.Event;

public class Model3DView extends Sprite {

    private var workspace:WorkspaceView;
    private var fileBrowser:FileBrowser;
    private var contentView:ContentView3D;

    public function Model3DView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.fileBrowser = new FileBrowser(LabAssets.model3dFiles);
        this.fileBrowser.addEventListener(FileBrowser.FILE_SELECTED, this.onFileSelected);
        addChild(this.fileBrowser);

        this.contentView = new ContentView3D(workspace);
        addChild(this.contentView);

        this.positionChildren();
    }

    private function positionChildren():void {
        this.contentView.x = this.fileBrowser.x + this.fileBrowser.width;
        this.contentView.y = this.fileBrowser.y;
    }

    private function onFileSelected(e:Event):void {
        this.contentView.displayModel3D(this.fileBrowser.selectedSlot.fileContent);
    }

    public function resize():void {
        this.fileBrowser.resize(VerticalListView.WIDTH, this.workspace.contentHeight);
        this.contentView.resize();
        this.positionChildren();
    }

    public function onAssetsLoaded():void {
        this.fileBrowser.repopulateFileList();
    }

    public override function set visible(val:Boolean):void {
        super.visible = val;
        this.contentView.visible = val;
    }
}
}
