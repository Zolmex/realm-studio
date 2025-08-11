package assetlab.view {
import assetlab.io.AssetFolderLoader;
import assetlab.io.LabAssets;
import assetlab.view.embed.Background;

import common.Global;
import common.ui.NotificationView;
import common.ui.elements.SimpleTextButton;
import common.ui.elements.SimpleTextInput;
import common.ui.elements.TextTooltip;
import common.ui.text.SimpleText;
import common.util.Constants;
import common.util.DictionaryUtil;
import common.util.TimedAction;
import common.util.TimerRunner;

import flash.display.BlendMode;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.getTimer;

public class MainView extends Sprite {

    public static var Instance:MainView;

    private var background:Background;
    public var timers:TimerRunner;
    private var lastUpdate:int;

    private var openButton:SimpleTextButton;
    public var notifications:NotificationView;
    private var projectPathText:SimpleText;
    private var workspace:WorkspaceView;
    private var saveButton:SimpleTextButton;
    private var saveTooltip:TextTooltip;

    public function MainView(main:Sprite, embedded:Boolean) {
        Instance = this;
        Global.Setup(main);
        Global.Main.stage.addEventListener(Event.RESIZE, onStageResize);

        this.timers = new TimerRunner();

        this.background = new Background();
        addChild(this.background);

        this.openButton = new SimpleTextButton("Open");
        this.openButton.addEventListener(MouseEvent.CLICK, onOpenClick);
        addChild(this.openButton);

        this.saveButton = new SimpleTextButton("Save");
        this.saveButton.addEventListener(MouseEvent.ROLL_OVER, this.onSaveRollOver);
        this.saveButton.addEventListener(MouseEvent.CLICK, this.onSaveClick);
        this.saveButton.visible = false;
        addChild(this.saveButton);

        this.projectPathText = new SimpleText(12, Constants.TEXT_UI_COLOR);
        addChild(this.projectPathText);

        this.workspace = new WorkspaceView(this);
        addChild(this.workspace);

        this.notifications = new NotificationView();
        addChild(this.notifications);

        Global.Main.stage.addEventListener(Event.ENTER_FRAME, this.update);

        this.updateScale();
        this.updatePositions();
    }

    private function onStageResize(e:Event):void {
        this.workspace.onStageResize();
        this.updateScale();
        this.updatePositions();
    }

    private function updateScale():void {
        this.background.scaleX = Global.ScaleX;
        this.background.scaleY = Global.ScaleY;
    }

    private function updatePositions():void {
        this.openButton.x = 10;
        this.openButton.y = 10;

        this.saveButton.x = Global.StageWidth - this.saveButton.width - 10;
        this.saveButton.y = 10;

        this.updateProjectPathPosition();

        this.workspace.x = (Global.StageWidth - this.workspace.width) / 2;
        this.workspace.y = (Global.StageHeight - this.workspace.height) / 2;
    }

    public function onAssetsLoaded(path:String):void {
        this.workspace.onAssetsLoaded();
        this.projectPathText.setText(path);
        this.projectPathText.updateMetrics();
        this.updateProjectPathPosition();
    }

    private function updateProjectPathPosition():void{
        this.projectPathText.x = this.openButton.x + this.openButton.width + 6;
        this.projectPathText.y = this.openButton.y + (this.openButton.height - this.projectPathText.height) / 2;
    }

    private function update(e:Event):void {
        var time:int = getTimer();
        var deltaTime:int = time - this.lastUpdate;
        this.lastUpdate = time;

        this.timers.update(deltaTime);
    }

    private function onSaveClick(e:MouseEvent):void {
        this.saveChangedFiles();

        this.hideSaveButton();
    }

    private function onSaveRollOver(e:MouseEvent):void {
        var numFiles:int = DictionaryUtil.length(this.workspace.gameDataView.filesChanged);
        var text:String = "Save " + numFiles + " files";
        if (this.saveTooltip == null){
            this.saveTooltip = new TextTooltip(this.saveButton, text);
            Global.Main.stage.addChild(this.saveTooltip);
        }
        else{
            this.saveTooltip.setTitle(text);
        }
    }

    private function saveChangedFiles():void {
        var fs:FileStream = new FileStream();
        var filesChanged:Dictionary = this.workspace.gameDataView.filesChanged;
        for (var file:File in filesChanged){
            fs.open(file, FileMode.READ);

            var fileContent:String = fs.readUTFBytes(fs.bytesAvailable); // Safety measure against unexpected errors, I don't want this app to delete entire XML files...

            fs.close();

            fs.open(file, FileMode.WRITE); // Because this thing deletes the entire file content if you close and don't write anything to it...

            try {
                fileContent = (LabAssets.gameDataXMLs[file.name] as XMLList).parent().toString(); // The GameData XML is already updated, so we just parse it as a string
            }
            catch (e:Error){
                trace("ERROR:", e);
            }

            fs.writeUTFBytes(fileContent);

            fs.close();

        }
        this.workspace.gameDataView.onAllFilesSaved();
    }

    public function showSaveButton():void {
        this.saveButton.visible = true;
    }

    public function hideSaveButton():void {
        this.saveButton.visible = false;
    }

    private static function onOpenClick(e:Event):void {
        AssetFolderLoader.open();
    }
}
}
