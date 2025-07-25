package mapeditor {
import common.assets.AnimatedChars;
import common.assets.AssetLibrary;
import common.assets.GroundLibrary;
import common.assets.ObjectLibrary;
import common.assets.RegionLibrary;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.utils.Dictionary;

import mapeditor.editor.Parameters;
import mapeditor.editor.ui.Keybinds;
import mapeditor.editor.ui.MainView;
import mapeditor.editor.ui.embed.Cursors;
import mapeditor.editor.ui.embed.EditorTools;
import mapeditor.editor.ui.embed.TextureParser;

public class EditorLoader {

    private static var readyCount:int = 0;

    public static function loadGround(xmls:Dictionary):void {
        GroundLibrary.load(xmls);
        readyCount++;
    }

    public static function loadObjects(xmls:Dictionary):void {
        ObjectLibrary.load(xmls);
        readyCount++;
    }

    public static function loadRegions(xmls:Dictionary):void {
        RegionLibrary.load(xmls);
        readyCount++;
    }

    public static function loadAssets(images:Dictionary, imageSets:Dictionary, imageLookup:Dictionary):void {
        AssetLibrary.load(images, imageSets, imageLookup);
        AssetLibrary.addImageSet("cursorsEmbed", new Cursors().bitmapData, 32, 32); // Editor assets
        AssetLibrary.addImageSet("editorTools", new EditorTools().bitmapData, 16, 16);
        readyCount++;
    }

    public static function loadAnimChars(chars:Dictionary):void {
        AnimatedChars.load(chars);
        readyCount++;
    }

    public static function load(main:Sprite, standalone:Boolean):Sprite {
        if (!standalone && readyCount < 5){
            throw new Error("RealmEditor: " + readyCount + " out of 5 asset libraries weren't loaded.");
        }

        if (standalone) { // Needed assets
            AssetLibrary.addImageSet("cursorsEmbed", new Cursors().bitmapData, 32, 32); // Editor assets
            AssetLibrary.addImageSet("editorTools", new EditorTools().bitmapData, 16, 16);
        }

        TextureParser.load();
        Parameters.load();
        Keybinds.loadKeys();

        var view:MainView = new MainView(main, standalone);
        main.addChild(view);
        return view;
    }
}
}
