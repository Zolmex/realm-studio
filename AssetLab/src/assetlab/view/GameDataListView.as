package assetlab.view {
import assetlab.io.LabAssets;
import assetlab.view.elements.FileBrowser;
import assetlab.view.elements.GameDataObjectCard;
import assetlab.view.elements.GameDataObjectCard;

import common.ui.elements.SimpleScrollbar;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.ByteArray;

public class GameDataListView extends Sprite {

    private var workspace:WorkspaceView;

    private var xmlList:Sprite;
    private var listMask:Shape;
    private var scrollbar:SimpleScrollbar;
    private var gameDataObjects:Vector.<GameDataObjectCard> = new Vector.<GameDataObjectCard>();

    public function GameDataListView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.xmlList = new Sprite();
        addChild(this.xmlList);

        this.listMask = new Shape();
        this.listMask.graphics.beginFill(0);
        this.listMask.graphics.drawRect(0, 0, width, workspace.contentHeight);
        this.listMask.graphics.endFill();
        this.xmlList.mask = this.listMask;
        addChild(this.listMask);

        this.scrollbar = new SimpleScrollbar();
        this.scrollbar.setup(workspace.contentHeight, 0, 0);
        this.scrollbar.addEventListener(Event.CHANGE, this.onScrollbarChange);
        addChild(this.scrollbar);

        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);

        this.positionChildren();
    }

    private function onAddedToStage(e:Event):void {
        parent.addEventListener(MouseEvent.MOUSE_WHEEL, this.onScroll);
    }

    public function repopulate(fileName:String):void {
        this.xmlList.removeChildren();
        this.gameDataObjects.length = 0;

        var xmls:XMLList = LabAssets.getGameData(fileName);
        if (xmls == null){
            trace("ERROR: No GameData content found for:", fileName);
            return;
        }

        var rowSize:int = getCardRowSize(this.workspace.contentWidth - FileBrowser.WIDTH - this.scrollbar.width);

        var i:int = 0;
        for each (var xml:XML in xmls){
            var gameDataObject:GameDataObjectCard = new GameDataObjectCard(xml);
            gameDataObject.x = 4 + int(i % rowSize) * (GameDataObjectCard.WIDTH + 4);
            gameDataObject.y = int(i / rowSize) * (GameDataObjectCard.HEIGHT + 4);
            this.xmlList.addChild(gameDataObject);
            this.gameDataObjects.push(gameDataObject);
            i++;
        }

        this.fixListPosition();
        this.scrollbar.setup(this.workspace.contentHeight, this.xmlList.y, this.xmlList.height - this.workspace.contentHeight);
    }

    private function positionChildren():void {
        this.scrollbar.x = width - this.scrollbar.width - 1;
        this.scrollbar.y = 0;

        var i:int = 0;
        var rowSize:int = getCardRowSize(this.workspace.contentWidth - FileBrowser.WIDTH - this.scrollbar.width);
        for each (var gameDataObject:GameDataObjectCard in this.gameDataObjects){
            gameDataObject.x = 4 + int(i % rowSize) * (GameDataObjectCard.WIDTH + 4);
            gameDataObject.y = int(i / rowSize) * (GameDataObjectCard.HEIGHT + 4);
            i++;
        }
    }

    private function onScrollbarChange(e:Event):void {
        this.xmlList.y = -this.scrollbar.cursorPos;
        this.fixListPosition();
    }

    private function onScroll(e:MouseEvent):void {
        e.stopImmediatePropagation();
        var scroll:Number = e.delta * 10;
        this.xmlList.y += scroll;
        this.fixListPosition();
        this.scrollbar.update(this.xmlList.y);
    }

    private function fixListPosition():void {
        if (this.xmlList.y > 0) { // Top limit
            this.xmlList.y = 0;
        }
        if (this.xmlList.height < this.workspace.contentHeight) { // If the elements container is smaller than the view, don't scroll
            this.xmlList.y = 0;
        } else if (this.xmlList.y < -this.xmlList.height + this.workspace.contentHeight) { // Bottom limit
            this.xmlList.y = -this.xmlList.height + this.workspace.contentHeight;
        }
    }

    public function resize():void {
        this.listMask.graphics.clear();
        this.listMask.graphics.beginFill(0);
        this.listMask.graphics.drawRect(0, 0, width, this.workspace.contentHeight);
        this.listMask.graphics.endFill();
        this.scrollbar.setup(this.workspace.contentHeight, this.xmlList.y, this.xmlList.height - this.workspace.contentHeight);

        this.positionChildren();
    }

    public override function get width():Number {
        return this.workspace.contentWidth - FileBrowser.WIDTH;
    }

    private static function getCardRowSize(width:Number):int {
        return Math.floor(width / (GameDataObjectCard.WIDTH + 4));
    }
}
}
