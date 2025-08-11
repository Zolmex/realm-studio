package assetlab.view.elements {
import assetlab.io.LabAssets;
import assetlab.view.GameDataView;
import assetlab.view.ImageSetsView;
import assetlab.view.MainView;
import assetlab.view.TextureSelectedEvent;
import assetlab.view.WorkspaceView;
import assetlab.view.elements.GameDataEditView;

import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.text.SimpleText;
import common.util.Constants;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.text.TextFieldAutoSize;

public class GameDataEditView extends Sprite {

    public static const WIDTH:int = 200;

    private var xml:XML;
    private var workspace:WorkspaceView;
    private var view:GameDataView;
    private var background:SliceScalingBitmap;
    private var title:SimpleText;

    private var textureProperties:TextureProperties;

    public function GameDataEditView(workspace:WorkspaceView, view:GameDataView, xml:XML) {
        this.workspace = workspace;
        this.xml = xml;
        this.view = view;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "settings_background");
        this.background.width = WIDTH;
        this.background.height = workspace.contentHeight;
        addChild(this.background);

        this.title = new SimpleText(10, Constants.TEXT_UI_COLOR, false, WIDTH - 8);
        this.title.setAutoSize(TextFieldAutoSize.LEFT);
        this.title.htmlText = "<b>" + xml.@id + "</b> (#" + int(xml.@type) + ")";
        this.title.updateMetrics();
        addChild(this.title);

        this.textureProperties = new TextureProperties(xml);
        this.textureProperties.addEventListener(TextureProperties.SELECT_TEXTURE, this.onSelectTexture);
        addChild(this.textureProperties);

        this.positionChildren();
    }

    private function onSelectTexture(e:Event):void {
        this.workspace.window.selectTab("ImageSets"); // Go to image sets tab
        this.workspace.imageSetsView.contentView.addEventListener(ContentView.TEXTURE_SELECTED, this.textureProperties.onTextureSelected);
        this.workspace.imageSetsView.contentView.addEventListener(ContentView.TEXTURE_SELECTED, this.onTextureChanged);
        this.workspace.imageSetsView.contentView.listenToTextureSelection();
    }

    private function positionChildren():void {
        var titleWidth:int = Math.min(this.title.width, this.title.actualWidth_);
        this.title.x = (WIDTH - titleWidth) / 2;
        this.title.y = (18 - this.title.height) / 2;

        this.textureProperties.x = 2;
        this.textureProperties.y = 20;
    }

    private function onTextureChanged(e:TextureSelectedEvent):void {
        var file:File = this.view.fileBrowser.selectedSlot.file;
        if (!(file in this.view.filesChanged)) {
            this.view.filesChanged[file] = new Vector.<XML>();
            var xmlList:Vector.<XML> = this.view.filesChanged[file];
            if (xmlList.indexOf(this.xml) == -1) {
                xmlList.push(this.xml);
            }
        }

        this.view.fileBrowser.selectedSlot.setChanged(true); // Mark file as changed
        MainView.Instance.showSaveButton();

        this.view.onGameDataChanged(this.xml);
    }

    public function resize():void {
        this.background.height = this.workspace.contentHeight;
    }
}
}
