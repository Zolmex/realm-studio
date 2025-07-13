package realmeditor.editor.ui.embed {
import flash.display.Bitmap;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import io.decagames.rotmg.ui.assets.UIAssets;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;

import kabam.lib.json.JsonParser;
import kabam.rotmg.core.StaticInjectorContext;

public class TextureParser {

    private static var instance:TextureParser;

    private var textures:Dictionary;

    function TextureParser() {
        this.textures = new Dictionary();
        this.registerTexture(new UIAssets.UI(), new UIAssets.UI_CONFIG(), new UIAssets.UI_SLICE_CONFIG(), "UI");
    }

    public static function load():void {
        if (instance == null) {
            instance = new TextureParser();
        }
    }

    public function registerTexture(atlas:Bitmap, config:String, sliceRects:String, atlasName:String):void {
        var configJson:Object = JSON.parse(config);
        var sliceConfigs:Object = JSON.parse(sliceRects);
        if (configJson.hasOwnProperty("meta") && configJson.meta.hasOwnProperty("slices")) { // Aseprite's slices output
            configJson = TranslateConfigJson(configJson);
            sliceConfigs = GenerateDefaultSlices(configJson); // Generate new config for slices based on the new assets config
            this.saveNewConfigJson(configJson, false);
            this.saveNewConfigJson(sliceConfigs, true);
        }
        this.textures[atlasName] = {
            "texture": atlas,
            "configuration": configJson,
            "sliceRectangles": sliceConfigs
        };
    }

    private function getConfiguration(atlasName:String, assetName:String):Object {
        if (!this.textures[atlasName]) {
            throw new Error("Can\'t find set name " + atlasName);
        }
        if (!this.textures[atlasName].configuration.frames[assetName + ".png"]) {
            throw new Error("Can\'t find config for " + assetName);
        }
        return this.textures[atlasName].configuration.frames[assetName + ".png"];
    }

    private function getBitmapUsingConfig(atlasName:String, json:Object):BitmapData {
        var atlas:Bitmap = this.textures[atlasName].texture;
        var assetPixelData:ByteArray = atlas.bitmapData.getPixels(new Rectangle(json.frame.x, json.frame.y, json.frame.w, json.frame.h));
        assetPixelData.position = 0;
        var _loc5_:BitmapData = new BitmapData(json.frame.w, json.frame.h);
        _loc5_.setPixels(new Rectangle(0, 0, json.frame.w, json.frame.h), assetPixelData);
        return _loc5_;
    }

    public function getTexture(atlasName:String, assetName:String):Bitmap {
        var json:Object = this.getConfiguration(atlasName, assetName);
        return new Bitmap(this.getBitmapUsingConfig(atlasName, json));
    }

    public function getTextureData(atlasName:String, assetName:String):BitmapData {
        var json:Object = this.getConfiguration(atlasName, assetName);
        return this.getBitmapUsingConfig(atlasName, json);
    }

    public function getSliceScalingBitmap(atlasName:String, assetName:String, width:int = 0):SliceScalingBitmap {
        var sliceRect:Rectangle = null;
        var atlas:Bitmap = this.getTexture(atlasName, assetName);
        var sliceConfig:Object = this.textures[atlasName].sliceRectangles.slices[assetName + ".png"];
        var scaleType:String = SliceScalingBitmap.SCALE_TYPE_NONE;
        if (sliceConfig) {
            sliceRect = new Rectangle(sliceConfig.rectangle.x, sliceConfig.rectangle.y, sliceConfig.rectangle.w, sliceConfig.rectangle.h);
            scaleType = sliceConfig.type;
        }
        var slicedBitmap:SliceScalingBitmap = new SliceScalingBitmap(atlas.bitmapData, scaleType, sliceRect);
        slicedBitmap.sourceBitmapName = assetName;
        if (width != 0) {
            slicedBitmap.width = width;
        }
        return slicedBitmap;
    }

    private static function TranslateConfigJson(asepriteJson:Object):Object{
        trace("Translating aseprite config...")
        var ret:Object = {};
        ret.frames = {};
        for each (var sliceJson:Object in asepriteJson.meta.slices) {
            var name:String = sliceJson.name + ".png";
            var frame:Object = sliceJson.keys[0].bounds;
            ret.frames[name] = {};
            ret.frames[name]["frame"] = frame; // frame is the only relevant property
        }
        trace("Finished translating aseprite config.")
        return ret;
    }

    private static function GenerateDefaultSlices(configJson:Object):Object {
        trace("Generating default slices...");
        var ret:Object = {};
        ret.slices = {};
        for (var assetName:String in configJson.frames){
            var assetConfig:Object = configJson.frames[assetName];
            var rect:Object = {
                "x": assetConfig.frame.w / 2, // Center x axis
                "y": 0,
                "w": 1,
                "h": assetConfig.frame.h // Full height slice
            };
            ret.slices[assetName] = {};
            ret.slices[assetName]["type"] = "3grid"; // By default they will all be 3grid, have to manually change the ones you want with 9grid slicing
            ret.slices[assetName]["rectangle"] = rect;
        }
        trace("Finished generating default slices.");
        return ret;
    }

    private function saveNewConfigJson(configJson:Object, slices:Boolean):void {
        var saveFolder:File = File.workingDirectory.resolvePath("assetsConfig");
        saveFolder.createDirectory(); // This will create the directory if it doesn't exist already

        var file:File = saveFolder.resolvePath("UIAssets_UI" + (slices ? "_SLICE" : "") + "_CONFIG.json");
        var fs:FileStream = new FileStream();
        fs.open(file, FileMode.WRITE);
        var output:String = JSON.stringify(configJson);
        fs.writeUTFBytes(output);
        fs.close();
        trace(output)
    }
}
}
