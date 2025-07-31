package assetlab.io {
import common.util.TimedAction;

import flash.filesystem.File;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class LabAssets {

    // We keep track of the file names and their content to compare with embedded assets to
    // properly know which asset file we're dealing with. So that we can save the changes to disk later

    private static const imageFiles:Dictionary = new Dictionary(); // Key: File, Value: Content (png bytes)
    private static const xmlFiles:Dictionary = new Dictionary(); // Value: String content
    private static const object3dFiles:Dictionary = new Dictionary(); // Value: String content

    public static function addImageFile(pngFile:File, content:ByteArray):void {
        if (pngFile in imageFiles){
            trace("DUPLICATE PNG ASSET FILE", pngFile.name);
            return;
        }

        imageFiles[pngFile] = content;
    }

    public static function addXMLFile(xmlFile:File, content:String):void {
        if (xmlFile in xmlFiles){
            trace("DUPLICATE XML ASSET FILE", xmlFile.name);
            return;
        }

        xmlFiles[xmlFile] = content;
    }

    public static function add3dObjectFile(object3D:File, content:String):void {
        if (object3D in object3dFiles){
            trace("DUPLICATE XML ASSET FILE", object3D.name);
            return;
        }

        object3dFiles[object3D] = content;
    }
}
}
