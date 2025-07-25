package assetlab.view {
import assetlab.view.embed.Background;

import common.Global;

import flash.display.Sprite;
import flash.events.Event;

public class MainView extends Sprite {

    public static var Instance:MainView;

    private var background:Background;

    public function MainView(main:Sprite, embedded:Boolean) {
        Instance = this;
        Global.Setup(main);
        Global.Main.stage.addEventListener(Event.RESIZE, onStageResize);

        this.background = new Background();
        addChild(this.background);
    }

    private function onStageResize(e:Event):void {
        this.updateScale();
        this.updatePositions();
    }

    private function updateScale():void {
        this.background.scaleX = Global.ScaleX;
        this.background.scaleY = Global.ScaleY;
    }

    private function updatePositions():void {

    }
}
}
