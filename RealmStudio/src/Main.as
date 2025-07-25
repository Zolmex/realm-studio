package {

import assetlab.AssetLabLoader;

import assets.AssetLoader;

import common.assets.AnimatedChars;
import common.assets.AssetLibrary;
import common.assets.GroundLibrary;
import common.assets.ObjectLibrary;
import common.assets.RegionLibrary;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import mapeditor.EditorLoader;
import mapeditor.editor.Parameters;
import mapeditor.editor.ui.Keybinds;

[SWF(frameRate="60", backgroundColor="#000000", width="800", height="600")]
public class Main extends Sprite {

    public static var STAGE:Stage;
    private var editorView:Sprite;
    private var assetLabView:Sprite;

    public function Main() {
        if (stage) {
            this.setup();
        }
        else {
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        }
    }

    private function onAddedToStage(e:Event):void {
        stage.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.setup();
    }

    private function setup():void {
        STAGE = stage;

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        AssetLoader.load();

//        this.loadRealmEditor();
        this.loadAssetLab();
    }

    private function loadRealmEditor():void {
        // These methods are only required to use with a game client, AssetLibrary is shared in this standalone version
//        EditorLoader.loadAssets(
//                AssetLibrary.images_,
//                AssetLibrary.imageSets_,
//                AssetLibrary.imageLookup_
//        );
//        EditorLoader.loadAnimChars(AnimatedChars.nameMap_);
//        EditorLoader.loadGround(GroundLibrary.xmlLibrary_);
//        EditorLoader.loadObjects(ObjectLibrary.xmlLibrary_);
//        EditorLoader.loadRegions(RegionLibrary.xmlLibrary_);
        this.editorView = EditorLoader.load(this, true);
        this.editorView.addEventListener(Event.REMOVED_FROM_STAGE, onAppExit);
        this.editorView.addEventListener(Event.CONNECT, onMapTest);
    }

    private function loadAssetLab():void {
        this.assetLabView = AssetLabLoader.load(this, true);
        this.assetLabView.addEventListener(Event.REMOVED_FROM_STAGE, onAppExit);
    }

    private static function onAppExit(e:Event):void {
        NativeApplication.nativeApplication.exit();
    }

    private static function onMapTest(e:Event):void {
        trace("Not available on Realm Studio. Use a regular Realm client to test maps in-game");
    }
}
}