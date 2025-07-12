package {

import assets.AnimatedChars;
import assets.AssetLibrary;
import assets.AssetLoader;
import assets.ground.GroundLibrary;
import assets.objects.ObjectLibrary;
import assets.regions.RegionLibrary;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import realmeditor.EditorLoader;
import realmeditor.editor.Parameters;
import realmeditor.editor.ui.Keybinds;

[SWF(frameRate="60", backgroundColor="#000000", width="800", height="600")]
public class Main extends Sprite {

    public static var STAGE:Stage;
    private var editorView:Sprite;

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

        Parameters.load();
        Keybinds.loadKeys();
        AssetLoader.load();

        this.loadRealmEditor();
    }

    private function loadRealmEditor():void {
        EditorLoader.loadAssets(
                AssetLibrary.images_,
                AssetLibrary.imageSets_,
                AssetLibrary.imageLookup_
        );
        EditorLoader.loadAnimChars(AnimatedChars.nameMap_);
        EditorLoader.loadGround(GroundLibrary.xmlLibrary_);
        EditorLoader.loadObjects(ObjectLibrary.xmlLibrary_);
        EditorLoader.loadRegions(RegionLibrary.xmlLibrary_);
        this.editorView = EditorLoader.load(this);
        this.editorView.addEventListener(Event.REMOVED_FROM_STAGE, onEditorExit);
        this.editorView.addEventListener(Event.CONNECT, onMapTest);
    }

    private static function onEditorExit(e:Event):void {
        NativeApplication.nativeApplication.exit();
    }

    private static function onMapTest(e:Event):void {
        trace("Not available on Realm Studio. Use a regular Realm client to test maps in-game");
    }
}
}