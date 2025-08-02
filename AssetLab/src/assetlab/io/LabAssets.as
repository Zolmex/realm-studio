package assetlab.io {
import common.util.TimedAction;

import flash.filesystem.File;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class LabAssets {

    // We keep track of the file names and their content to compare with embedded assets to
    // properly know which asset file we're dealing with. So that we can save the changes to disk later

    public static const imageFiles:Dictionary = new Dictionary(); // Key: File, Value: Content (png ByteArray)
    public static const gameDataFiles:Dictionary = new Dictionary(); // Value: String content (UTF8 ByteArray)
    public static const model3dFiles:Dictionary = new Dictionary(); // Value: String content (UTF8 ByteArray)

    public static function addImageFile(pngFile:File, content:ByteArray):void {
        if (pngFile in imageFiles){
            trace("DUPLICATE PNG ASSET FILE", pngFile.name);
            return;
        }

        imageFiles[pngFile] = content;
    }

    public static function addXMLFile(xmlFile:File, content:String):void {
        if (xmlFile in gameDataFiles){
            trace("DUPLICATE XML ASSET FILE", xmlFile.name);
            return;
        }

        var bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(content);
        gameDataFiles[xmlFile] = bytes;
    }

    public static function add3dObjectFile(object3D:File, content:String):void {
        if (object3D in model3dFiles){
            trace("DUPLICATE 3D MODEL ASSET FILE", object3D.name);
            return;
        }

        content = content.replace("mtllib", "#") // mtllib is broken!!! and it's not used so just make lines that have this a comment ;)

        var bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(content);
        model3dFiles[object3D] = bytes;
    }
}
}
