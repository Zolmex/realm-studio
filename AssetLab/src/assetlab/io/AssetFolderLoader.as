package assetlab.io {
import air.media.FileSource;

import assetlab.view.MainView;

import common.util.TimedAction;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.utils.ByteArray;

public class AssetFolderLoader {

    private static const VALID_FILE_EXTENSIONS:Array = ["png", "dat", "xml"];

    private static var openDialog:File;
    private static var selectedDirectory:File;

    public static function open():void {
        if (openDialog != null){
            trace("PENDING SELECT FOLDER OPERATION");
            return;
        }

        openDialog = new File();
        openDialog.addEventListener(Event.SELECT, onFileBrowseSelect);
        openDialog.browseForDirectory("Select your assets directory");
    }

    private static function onFileBrowseSelect(e:Event):void {
        if (selectedDirectory != null){
            trace("PENDING LOAD ASSET DIRECTORY OPERATION");
            return;
        }

        selectedDirectory = e.target as File;
        MainView.Instance.notifications.showNotification("Loading assets" + selectedDirectory.name + "...");
        MainView.Instance.timers.push(new TimedAction(100, finishLoadAssets));
    }

    private static function finishLoadAssets():void {
        LabAssets.reset(); // Reset cache and game data

        var files:Array = selectedDirectory.getDirectoryListing();
        for(var i:uint = 0; i < files.length; i++) {
            loadAssetFileOrDirectory(files[i]);
        }

//        trace("Finished loading files.");

        LabAssets.constructGameData();

        MainView.Instance.onAssetsLoaded(selectedDirectory.nativePath);
    }

    private static function loadSubDirectoryFiles(directory:File):void {
        var files:Array = directory.getDirectoryListing();
        for(var i:uint = 0; i < files.length; i++) {
            loadAssetFileOrDirectory(files[i]);
        }
    }

    private static function loadAssetFileOrDirectory(file:File):void {
//        trace(file.name, file.extension);
        if (file.isDirectory){
            loadSubDirectoryFiles(file);
            return;
        }

        if (VALID_FILE_EXTENSIONS.indexOf(file.extension) == -1){
            return;
        }

        var fs:FileStream = new FileStream();
        fs.open(file, FileMode.READ);
        var content:Object;
        switch (file.extension){
            case "png":
                content = new ByteArray();
                fs.readBytes(content as ByteArray);
                LabAssets.addImageFile(file, content as ByteArray);
                break;
            case "dat":
                content = fs.readUTFBytes(fs.bytesAvailable);
                if (content.indexOf("Tutorial") != -1){
                    fs.close();
                    return;
                }

                if (content.indexOf("Ground") != -1 || content.indexOf("GroundTypes") != -1 || content.indexOf("Regions") != -1 || content.indexOf("Objects") != -1){
//                    trace(file.name, "XML PARSED")
                    LabAssets.addXMLFile(file, content as String);
                }
                else {
//                    trace(file.name, "3D OBJECT PARSED")
                    LabAssets.add3dObjectFile(file, content as String);
                }
                break;
            case "xml":
                content = fs.readUTFBytes(fs.bytesAvailable);
                LabAssets.addXMLFile(file, content as String);
                break;
        }
        fs.close();
    }
}
}
