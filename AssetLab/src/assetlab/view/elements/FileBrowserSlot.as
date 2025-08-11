package assetlab.view.elements {
import common.util.Constants;

import flash.filesystem.File;
import flash.utils.ByteArray;

public class FileBrowserSlot extends VerticalListSlot {

    public var file:File;
    public var fileContent:ByteArray;

    private var changed:Boolean;

    function FileBrowserSlot(file:File, content:ByteArray) {
        this.file = file;
        this.fileContent = content;
        var cleanFileName:String = getCleanFileName(file.name);
        super(cleanFileName);
    }

    public function setChanged(val:Boolean):void {
        this.changed = val;
        this.normalColor = val ? 0x5680bf : Constants.TEXT_UI_COLOR;
        this.nameText.setColor(this.selected ? Constants.TITLE_COLOR : this.normalColor);
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
}
