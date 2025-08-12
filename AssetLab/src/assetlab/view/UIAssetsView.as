package assetlab.view {
import assetlab.io.LabAssets;
import assetlab.view.elements.ContentView;
import assetlab.view.elements.ContentViewUI;
import assetlab.view.elements.FileBrowser;
import assetlab.view.elements.VerticalListSlot;
import assetlab.view.elements.VerticalListView;

import common.assets.AnimatedChars;
import common.ui.TextureParser;

import flash.display.Sprite;
import flash.events.Event;

public class UIAssetsView extends Sprite {

    private var workspace:WorkspaceView;
    private var atlasList:VerticalListView;
    private var contentView:ContentViewUI;

    public function UIAssetsView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.atlasList = new VerticalListView();
        this.atlasList.addEventListener(VerticalListView.SLOT_SELECTED, this.onUIAtlasSelected);
        addChild(this.atlasList);

        this.contentView = new ContentViewUI(workspace);
        addChild(this.contentView);

        this.positionChildren();
    }

    private function positionChildren():void {
        this.contentView.x = this.atlasList.x + this.atlasList.width;
        this.contentView.y = this.atlasList.y;
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
        this.atlasList.resize(VerticalListView.WIDTH, this.workspace.contentHeight);
        this.contentView.resize();
        this.positionChildren();
    }
}
}
