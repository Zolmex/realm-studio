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

    public static const FILE_SELECTED:String = "FileSelected"

    private var files:Dictionary; // Key: File; Value: File content (ByteArray)
    public var list:VerticalListView;
    public var selectedSlot:FileBrowserSlot;

    public function FileBrowser(files:Dictionary) {
        this.files = files;
        this.list = new VerticalListView();
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