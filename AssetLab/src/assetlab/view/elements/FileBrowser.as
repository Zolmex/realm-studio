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
    public static const FILE_SELECTED:String = "FileSelected"

    private var files:Dictionary; // Key: File; Value: File content (ByteArray)
    private var list:VerticalListView;
    public var selectedSlot:FileBrowserSlot;

    public function FileBrowser(files:Dictionary, width:int = WIDTH, height:int = HEIGHT) {
        this.files = files;
        this.list = new VerticalListView(width, height);
        this.list.addEventListener(VerticalListView.SLOT_SELECTED, this.onSlotSelected);
        addChild(this.list);
    }

    private function onSlotSelected(e:Event):void {
        this.selectedSlot = this.list.selectedSlot as FileBrowserSlot;
        dispatchEvent(new Event(FILE_SELECTED));
    }

    public function repopulateFileList():void {
        this.list.clear();
        for (var file:File in this.files) { // Iterate dictionary keys
            var content:ByteArray = this.files[file]; // Get value
            this.list.addSlot(new FileBrowserSlot(file, content));
        }
    }

    public function resize(width:Number, height:Number):void {
        this.list.resize(width, height);
    }
}
}

import assetlab.view.elements.VerticalListSlot;

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

class FileBrowserSlot extends VerticalListSlot {

    public var file:File;
    public var fileContent:ByteArray;

    function FileBrowserSlot(file:File, content:ByteArray) {
        this.file = file;
        this.fileContent = content;
        var cleanFileName:String = getCleanFileName(file.name);
        super(cleanFileName);

    }

    private static function getCleanFileName(fullName:String):String {
        var cleanName:String = fullName;
        cleanName = cleanName.replace("EmbeddedData_", "");
        cleanName = cleanName.replace("EmbeddedAssets_", "");
        cleanName = cleanName.replace("CXML", "");
        cleanName = cleanName.replace("Embed_", "");
        return cleanName;
    }
}