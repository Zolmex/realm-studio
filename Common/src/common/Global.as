package common {
import flash.display.Sprite;
import flash.events.Event;

public class Global {

    public static var Main:Sprite;
    public static var StageWidth:int;
    public static var StageHeight:int;
    public static var ScaleX:Number;
    public static var ScaleY:Number;

    public static function Setup(main:Sprite):void {
        Main = main;
        Main.stage.addEventListener(Event.RESIZE, onStageResize);
        StageWidth = Main.stage.stageWidth;
        StageHeight = Main.stage.stageHeight;
        ScaleX = Main.stage.stageWidth / 800;
        ScaleY = Main.stage.stageHeight / 600;
    }

    private static function onStageResize(e:Event):void {
        StageWidth = Main.stage.stageWidth;
        StageHeight = Main.stage.stageHeight;
        ScaleX = Main.stage.stageWidth / 800;
        ScaleY = Main.stage.stageHeight / 600;
    }
}
}
