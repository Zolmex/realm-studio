package realmeditor.editor.tools {

import flash.utils.Dictionary;

import realmeditor.editor.MEBrush;
import realmeditor.editor.MEDrawType;

import realmeditor.editor.MEEvent;

import realmeditor.editor.MapHistory;
import realmeditor.editor.MapTileData;
import realmeditor.editor.actions.MapReplaceTileAction;

import realmeditor.editor.ui.MainView;
import realmeditor.editor.ui.TileMapView;
import realmeditor.util.IntPoint;

public class METool {

    public static const SELECT_ID:int = 0;
    public static const PENCIL_ID:int = 1;
    public static const LINE_ID:int = 2;
    public static const SHAPE_ID:int = 3;
    public static const BUCKET_ID:int = 4;
    public static const PICKER_ID:int = 5;
    public static const ERASER_ID:int = 6;
    public static const EDIT_ID:int = 7;
    public static const SELECT:String = "Select";
    public static const PENCIL:String = "Pencil";
    public static const LINE:String = "Line";
    public static const SHAPE:String = "Shape";
    public static const BUCKET:String = "Bucket";
    public static const PICKER:String = "Picker";
    public static const ERASER:String = "Eraser";
    public static const EDIT:String = "Edit";

    public var id:int;
    protected var mainView:MainView;

    public function METool(id:int, view:MainView) {
        this.id = id;
        this.mainView = view;
    }

    public virtual function init(tilePos:IntPoint, history:MapHistory):void { }
    public virtual function reset():void { }

    public virtual function mouseDrag(tilePos:IntPoint, history:MapHistory):void { }
    public virtual function mouseDragEnd(tilePos:IntPoint, history:MapHistory):void { }
    public virtual function tileClick(tilePos:IntPoint, history:MapHistory):void { }
    public virtual function mouseMoved(tilePos:IntPoint, history:MapHistory):void { }
    public virtual function brushChanged(tilePos:IntPoint, history:MapHistory):void { }

    protected function paintTile(mapX:int, mapY:int):MapReplaceTileAction {
        var brush:MEBrush = this.mainView.userBrush;
        var tileMap:TileMapView = this.mainView.mapView.tileMap;
        var prevData:MapTileData = tileMap.getTileData(mapX, mapY);
        if (prevData == null){
            return null;
        }
        else {
            prevData = prevData.clone();
        }

        switch (brush.elementType) {
            case MEDrawType.GROUND:
                if (brush.groundType == -1 || prevData.groundType == brush.groundType) { // Don't update tile data if it's already the same. Also don't draw empty textures
                    return null;
                }
                if (!brush.replace && prevData.groundType != -1) {
                    return null;
                }
                tileMap.setTileGround(mapX, mapY, brush.groundType);
                break;
            case MEDrawType.OBJECTS:
                if (brush.objType == 0 || prevData.objType == brush.objType) {
                    return null;
                }
                if (!brush.replace && prevData.objType != 0) {
                    return null;
                }
                tileMap.setTileObject(mapX, mapY, brush.objType);
                break;
            case MEDrawType.REGIONS:
                if (brush.regType == 0 || prevData.regType == brush.regType) {
                    return null;
                }
                if (!brush.replace && prevData.regType != 0) {
                    return null;
                }
                tileMap.setTileRegion(mapX, mapY, brush.regType);
                break;
        }

        tileMap.drawTile(mapX, mapY);
        return new MapReplaceTileAction(mapX, mapY, prevData, tileMap.getTileData(mapX, mapY).clone());
    }

    private static const TOOLS:Dictionary = new Dictionary();

    public static function GetTool(toolId:int, view:MainView):METool{
        var tool:METool = TOOLS[toolId] as METool;
        if (tool == null){
            tool = CreateTool(toolId, view);
            TOOLS[toolId] = tool;
        }

        return tool;
    }

    private static function CreateTool(toolId:int, view:MainView):METool{
        switch (toolId){
            case SELECT_ID:
                return new MESelectTool(view);
            case PENCIL_ID:
                return new MEPencilTool(view);
            case LINE_ID:
                return new MELineTool(view);
            case SHAPE_ID:
                return new MEShapeTool(view);
            case BUCKET_ID:
                return new MEBucketTool(view);
            case ERASER_ID:
                return new MEEraserTool(view);
            case PICKER_ID:
                return new MEPickerTool(view);
            case EDIT_ID:
                return new MEEditTool(view);
            default:
                return null;
        }
    }

    public static function ToolEventToId(eventStr:String):int {
        switch (eventStr){
            case MEEvent.TOOL_SWITCH_SELECT:
                return SELECT_ID;
            case MEEvent.TOOL_SWITCH_PENCIL:
                return PENCIL_ID;
            case MEEvent.TOOL_SWITCH_LINE:
                return LINE_ID;
            case MEEvent.TOOL_SWITCH_SHAPE:
                return SHAPE_ID;
            case MEEvent.TOOL_SWITCH_BUCKET:
                return BUCKET_ID;
            case MEEvent.TOOL_SWITCH_PICKER:
                return PICKER_ID;
            case MEEvent.TOOL_SWITCH_ERASER:
                return ERASER_ID;
            case MEEvent.TOOL_SWITCH_EDIT:
                return EDIT_ID;
            default:
                trace("Unknown tool id for tool event:", eventStr);
                return -1;
        }
    }

    public static function ToolIdToName(id:int):String {
        switch (id){
            case SELECT_ID:
                return SELECT;
            case PENCIL_ID:
                return PENCIL;
            case LINE_ID:
                return LINE;
            case SHAPE_ID:
                return SHAPE;
            case BUCKET_ID:
                return BUCKET;
            case PICKER_ID:
                return PICKER;
            case ERASER_ID:
                return ERASER;
            case EDIT_ID:
                return EDIT;
            default:
                trace("Unknown tool name for tool id:", id.toString());
                return null;
        }
    }

    public static function ToolTextureIdToName(id:int):String {
        switch (id){
            case 0:
                return SELECT;
            case 1:
                return PENCIL;
            case 2:
                return ERASER;
            case 3:
                return PICKER;
            case 5:
                return BUCKET;
            case 6:
                return LINE;
            case 7:
                return SHAPE;
            case 9:
                return EDIT;
            default:
                trace("Unknown tool name for tool id:", id.toString());
                return null;
        }
    }

    public static function GetToolDescription(name:String):String {
        switch (name){
            case SELECT:
                return "Keybind: <b>S</b>\n" +
                        "Hold <b>Shift</b> while dragging to activate.\n" +
                        "<b>Escape</b> to unselect.\n" +
                        "<b>Delete</b> to delete tiles in selection.";
            case PENCIL:
                return "Keybind: <b>D</b>\n" +
                        "Ctrl + Scroll to change brush size.";
            case ERASER:
                return "Keybind: <b>E</b>\n" +
                        "Ctrl + Scroll to change brush size.";
            case PICKER:
                return "Keybind: <b>A</b>\n";
            case BUCKET:
                return "Keybind: <b>F</b>\n";
            case LINE:
                return "Keybind: <b>L</b>\n" +
                        "Not implemented";
            case SHAPE:
                return "Keybind: <b>U</b>\n" +
                        "Draw shapes with your brush.";
            case EDIT:
                return "Keybind: <b>I</b>\n" +
                        "Can only edit names of objects for now... (useful for Signs)";
            default:
                trace("Unknown tool name for tool name:", name.toString());
                return null;
        }
    }
}
}
