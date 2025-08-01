package assetlab.view {
import assetlab.io.LabAssets;
import assetlab.view.elements.FileBrowser;

import common.Global;

import flash.display.Sprite;

public class Model3DView extends Sprite {

    private var workspace:WorkspaceView;
    private var fileBrowser:FileBrowser;

    public function Model3DView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.fileBrowser = new FileBrowser(LabAssets.model3dFiles);
        addChild(this.fileBrowser);
    }

    public function resize():void {
        this.fileBrowser.resize(FileBrowser.WIDTH, FileBrowser.HEIGHT * Global.ScaleY);
    }

    public function onAssetsLoaded():void {
        this.fileBrowser.repopulateFileList();
    }
}
}
