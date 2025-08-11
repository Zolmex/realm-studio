package assetlab.io {
import common.assets.GroundLibrary;
import common.assets.TextureData;
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

    public static const gameDataXMLs:Dictionary = new Dictionary(); // Key: File.name, Value: XMLList
    public static const gameDataTexts:Dictionary = new Dictionary(); // Key: File.name, Value: Dictionary (Key: XML, Value: XML String)

    private static const textureDataCache:Dictionary = new Dictionary();

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

    public static function constructGameData():void { // Creates a link between loaded game data files and the embedded xml content
//        trace("Constructing GameData content...");
        for (var file:File in gameDataFiles){
//            trace("Constructing", file.name)
            var xmlString:String = gameDataFiles[file];
            var contentXML:XML = XML(xmlString);
            if (contentXML.hasOwnProperty("Ground")){
                gameDataXMLs[file.name] = contentXML.Ground;
            }
            else if (contentXML.hasOwnProperty("Object")){
                gameDataXMLs[file.name] = contentXML.Object;
            }
            else if (contentXML.hasOwnProperty("Region")){
                gameDataXMLs[file.name] = contentXML.Region;
            }
            else {
                trace("Unknown XML type for:", file.name);
                continue;
            }

            gameDataTexts[file.name] = new Dictionary(); // Save every xml as string for the current file. This is needed for saving the files
            var dict:Dictionary = gameDataTexts[file.name];
            for each (var xml:XML in gameDataXMLs[file.name]){
                dict[xml] = xml.toString();
            }
        }

//        trace("Finished constructing GameData content.")
    }

    public static function getGameData(fileName:String):XMLList {
        if (!(fileName in gameDataXMLs)){
            return null;
        }

        return gameDataXMLs[fileName] as XMLList;
    }

    public static function getTextureData(xml:XML):TextureData { // TextureData cache
        var textureData:TextureData;
        if (!(xml in textureDataCache)){
            textureData = new TextureData(xml);
            textureDataCache[xml] = textureData;
        }
        else {
            textureData = textureDataCache[xml];
        }
        return textureData;
    }

    public static function reset():void {
        var key:*;
        for (key in textureDataCache){
            delete textureDataCache[key];
        }
        for (key in gameDataXMLs){
            delete gameDataXMLs[key];
        }
        textureDataCache.length = 0;
        gameDataXMLs.length = 0;
    }
}
}
