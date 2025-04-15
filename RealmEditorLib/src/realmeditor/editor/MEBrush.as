package realmeditor.editor {
import flash.events.Event;

import realmeditor.editor.ui.MainView;
import realmeditor.util.IntPoint;

public class MEBrush {

    public static const SHAPE_RANDOM:int = 1;
    public static const SHAPE_RANDOM_2:int = 2;

    public var shapeTiles:Vector.<IntPoint>;
    public var elementType:int;
    public var brushType:int;
    public var groundType:int = -1;
    public var objType:int = 0;
    public var regType:int = 0;
    private var brushShape_:int = 0;
    private var size_:int = 0;
    private var chance_:int = 25;
    private var replace_:Boolean = true;

    private var mainView:MainView;

    public function MEBrush(mainView:MainView, drawType:int, brushType:int) {
        this.elementType = drawType;
        this.brushType = brushType;
        this.mainView = mainView;
        this.shapeTiles = new Vector.<IntPoint>();
    }

    public function get size():int {
        return this.size_;
    }

    public function setSize(size:int):void {
        this.size_ = size;
        this.mainView.dispatchEvent(new Event(MEEvent.BRUSH_CHANGED));
    }

    public function get brushShape():int {
        return this.brushShape_;
    }

    public function setBrushShape(shape:int):void {
        this.brushShape_ = shape;
        this.mainView.dispatchEvent(new Event(MEEvent.BRUSH_CHANGED));
    }

    public function get chance():int {
        return this.chance_;
    }

    public function setChance(chance:int):void {
        this.chance_ = chance;
        this.mainView.dispatchEvent(new Event(MEEvent.BRUSH_CHANGED));
    }

    public function get replace():Boolean {
        return this.replace_;
    }

    public function setReplace(value:Boolean):void {
        this.replace_ = value;
        this.mainView.dispatchEvent(new Event(MEEvent.BRUSH_CHANGED));
    }

    public function setGroundType(groundType:int):void{
        this.groundType = groundType;
    }

    public function setObjectType(objType:int):void{
        this.objType = objType;
    }

    public function setRegionType(regType:int):void{
        this.regType = regType;
    }
}
}
