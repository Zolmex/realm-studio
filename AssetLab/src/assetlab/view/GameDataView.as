package assetlab.view {
import assetlab.io.LabAssets;
import assetlab.view.elements.ContentView;
import assetlab.view.elements.FileBrowser;
import assetlab.view.elements.GameDataEditView;

import common.Global;
import common.ui.elements.SimpleScrollbar;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

public class GameDataView extends Sprite {

    private var workspace:WorkspaceView;
    private var fileBrowser:FileBrowser;
    private var listView:GameDataListView;
    private var mouseTriggerArea:Shape;

    private var editViews:Dictionary = new Dictionary();
    private var currentEditView:GameDataEditView;

    public function GameDataView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.mouseTriggerArea = new Shape();
        this.mouseTriggerArea.graphics.beginFill(0, 0);
        this.mouseTriggerArea.graphics.drawRect(0, 0, workspace.contentWidth, workspace.contentHeight);
        this.mouseTriggerArea.graphics.endFill();
        addChild(this.mouseTriggerArea);

        this.fileBrowser = new FileBrowser(LabAssets.gameDataFiles);
        this.fileBrowser.addEventListener(FileBrowser.FILE_SELECTED, this.onFileSelected);
        addChild(this.fileBrowser);

        this.listView = new GameDataListView(this, workspace);
        addChild(this.listView);

        this.positionChildren();
    }

    private function positionChildren():void {
        this.listView.x = this.fileBrowser.x + this.fileBrowser.width;
        this.listView.y = this.fileBrowser.y;

        if (this.currentEditView) {
            this.currentEditView.x = this.workspace.contentWidth - GameDataEditView.WIDTH;
        }
    }

    private function onFileSelected(e:Event):void {
        if (!this.listView.visible){
            this.listView.visible = true;
        }

        this.listView.repopulate(this.fileBrowser.selectedSlot.file.name);
    }

    public function resize():void {
        this.fileBrowser.resize(FileBrowser.WIDTH, this.workspace.contentHeight);
        this.listView.resize();
        for each (var editView:GameDataEditView in this.editViews){
            editView.resize();
        }

        this.mouseTriggerArea.graphics.clear();
        this.mouseTriggerArea.graphics.beginFill(0, 0);
        this.mouseTriggerArea.graphics.drawRect(0, 0, workspace.contentWidth, workspace.contentHeight);
        this.mouseTriggerArea.graphics.endFill();

        this.positionChildren();
    }

    public function onAssetsLoaded():void {
        this.fileBrowser.repopulateFileList();
    }

    public function onObjectSelected(xml:XML):void {
        var editView:GameDataEditView;
        if (xml in this.editViews) {
            editView = this.editViews[xml];
            if (editView == this.currentEditView) {
                return;
            }
        }
        else {
            editView = new GameDataEditView(this.workspace, xml);
            this.editViews[xml] = editView;
            addChild(editView);
        }

        if (this.currentEditView) {
            this.currentEditView.visible = false;
        }

        this.currentEditView = editView;
        this.currentEditView.visible = true;
        this.positionChildren();
    }
}
}
