package assetlab {
import assetlab.view.MainView;

import common.Parameters;
import common.assets.AnimatedChars;
import common.assets.AssetLibrary;
import common.assets.GroundLibrary;
import common.assets.ObjectLibrary;
import common.assets.RegionLibrary;
import common.ui.TextureParser;

import flash.display.Sprite;

import flash.utils.Dictionary;

public class AssetLabLoader {

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
        // Load needed assets
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
            // Nothing yet
        }

//        TextureParser.load(new UIAssets.UI(), new UIAssets.UI_CONFIG(), new UIAssets.UI_SLICE_CONFIG(), "UI");
        Parameters.load();

        var view:MainView = new MainView(main, standalone);
        main.addChild(view);
        return view;
    }
}
}
