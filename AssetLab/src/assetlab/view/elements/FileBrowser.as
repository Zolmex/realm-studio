package assetlab.view.elements {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.elements.SimpleScrollbar;
import common.ui.text.SimpleText;
import common.util.MoreColorUtil;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.text.TextFieldAutoSize;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class FileBrowser extends Sprite {

    public static const WIDTH:int = 164;
    public static const HEIGHT:int = 492;
    public static const FILE_SELECTED:String = "FileSelected";

    private var files:Dictionary; // Key: File; Value: File content (ByteArray)
    private var background:SliceScalingBitmap;
    private var fileContainer:Sprite;
    private var fileContainerMask:Shape;
    private var fileSlots:Vector.<FileBrowserSlot> = new <FileBrowserSlot>[];
    private var scrollbar:SimpleScrollbar;
    public var selectedSlot:FileBrowserSlot;

    private const listYLimit:int = 3;
    private var viewHeight:int = HEIGHT - 2;

    public function FileBrowser(files:Dictionary, width:int = WIDTH, height:int = HEIGHT) {
        this.files = files;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "search_input_background");
        this.background.width = width;
        this.background.height = height;
        addChild(this.background);

        this.fileContainer = new Sprite();
        this.fileContainer.x = 2;
        this.fileContainer.y = this.listYLimit;
        addChild(this.fileContainer);

        this.fileContainerMask = new Shape();
        this.fileContainerMask.graphics.beginFill(0);
        this.fileContainerMask.graphics.drawRect(2, this.listYLimit, width - 4, height - 4);
        this.fileContainerMask.graphics.endFill();
        this.fileContainer.mask = this.fileContainerMask;
        addChild(this.fileContainerMask);

        this.scrollbar = new SimpleScrollbar();
        this.scrollbar.setup(this.viewHeight - 4, 0, 0);
        this.scrollbar.x = WIDTH - this.scrollbar.width - 3;
        this.scrollbar.y = this.listYLimit;
        this.scrollbar.addEventListener(Event.CHANGE, this.onScrollbarChange);
        addChild(this.scrollbar);

        addEventListener(MouseEvent.MOUSE_WHEEL, this.onScroll);
    }

    private function onScrollbarChange(e:Event):void {
        this.fileContainer.y = -this.scrollbar.cursorPos + this.listYLimit;
        this.fixListPosition();
    }

    private function onScroll(e:MouseEvent):void {
        e.stopImmediatePropagation();
        var scroll:Number = e.delta * 10;
        this.fileContainer.y += scroll;
        this.fixListPosition();
        this.scrollbar.update(this.fileContainer.y - this.listYLimit);
    }

    private function fixListPosition():void {
        if (this.fileContainer.y > this.listYLimit) { // Top limit
            this.fileContainer.y = this.listYLimit;
        }
        if (this.fileContainer.height < this.viewHeight) { // If the elements container is smaller than the view, don't scroll
            this.fileContainer.y = this.listYLimit;
        } else if (this.fileContainer.y < -this.fileContainer.height + this.viewHeight) { // Bottom limit
            this.fileContainer.y = -this.fileContainer.height + this.viewHeight;
        }
    }

    private function onFileSlotClicked(e:MouseEvent):void {
        if (this.selectedSlot != null) {
            this.selectedSlot.setSelected(false);
        }

        var fileSlot:FileBrowserSlot = e.target as FileBrowserSlot;
        fileSlot.setSelected(true);
        this.selectedSlot = fileSlot;

        dispatchEvent(new Event(FILE_SELECTED));
    }

    public function repopulateFileList():void {
        this.fileContainer.removeChildren(); // Clear before re-adding file slots
        this.fileSlots.length = 0;

        var i:int = 0;
        for (var file:File in this.files) { // Iterate dictionary keys
            var content:ByteArray = this.files[file]; // Get value
            var fileSlot:FileBrowserSlot = new FileBrowserSlot(file, content);
            fileSlot.setSelected(this.fileSlots.length == 0);
            fileSlot.x = 2;
            fileSlot.y = 2 + (FileBrowserSlot.HEIGHT * i);
            fileSlot.addEventListener(MouseEvent.CLICK, this.onFileSlotClicked);

            if (fileSlot.selected) {
                this.selectedSlot = fileSlot;
            }

            this.fileContainer.addChild(fileSlot);
            this.fileSlots.push(fileSlot);
            i++;
        }

        this.scrollbar.setup(this.viewHeight - 4, this.fileContainer.y - this.listYLimit, this.fileContainer.height - this.viewHeight + this.listYLimit);
    }

    public function resize(width:Number, height:Number):void {
        this.viewHeight = height - 2;
        this.fixListPosition();
        this.scrollbar.setup(this.viewHeight - 4, this.fileContainer.y - this.listYLimit, this.fileContainer.height - this.viewHeight + this.listYLimit);

        this.background.width = width;
        this.background.height = height;

        this.fileContainerMask.graphics.clear();
        this.fileContainerMask.graphics.beginFill(0);
        this.fileContainerMask.graphics.drawRect(2, this.listYLimit, width - 4, height - 4);
        this.fileContainerMask.graphics.endFill();
    }
}
}

import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.text.SimpleText;
import common.util.Constants;
import common.util.MoreColorUtil;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.text.TextFieldAutoSize;
import flash.utils.ByteArray;
import flash.utils.getTimer;

class FileBrowserSlot extends Sprite {

    public static const WIDTH:int = 144;
    public static const HEIGHT:int = 25;

    public var file:File;
    public var fileContent:ByteArray;

    private var background:SliceScalingBitmap;
    private var nameText:SimpleText;
    public var selected:Boolean;

    function FileBrowserSlot(file:File, content:ByteArray) {
        this.file = file;
        this.fileContent = content;
        var fileFullName:String = file.name;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "drawelementselector_selection");
        this.background.width = WIDTH;
        this.background.height = HEIGHT;
        addChild(this.background);

        this.nameText = new SimpleText(14, Constants.TEXT_UI_COLOR, false, WIDTH - 4);
        this.nameText.setText(fileFullName);
        this.nameText.updateMetrics();
        this.nameText.x = (WIDTH - this.nameText.width) / 2;
        this.nameText.y = (HEIGHT - this.nameText.height) / 2;
        addChild(this.nameText);

        addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    private function onRollOver(e:Event):void {
        this.nameText.scrollingEnabled = true;
        if (!this.selected) {
            transform.colorTransform = MoreColorUtil.identity;
        }
    }

    private function onRollOut(e:Event):void {
        this.nameText.scrollingEnabled = false;
        if (!this.selected) {
            transform.colorTransform = MoreColorUtil.darkCT;
        }
    }

    public function setSelected(val:Boolean):void {
        this.selected = val;
        this.nameText.setColor(val ? Constants.TITLE_COLOR : Constants.TEXT_UI_COLOR);
        transform.colorTransform = val ? MoreColorUtil.identity : MoreColorUtil.darkCT;
    }
}