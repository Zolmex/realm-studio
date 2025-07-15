package realmeditor.editor.tools {
import realmeditor.editor.MEBrush;
import realmeditor.editor.MEDrawType;
import realmeditor.editor.MapHistory;
import realmeditor.editor.MapTileData;
import realmeditor.editor.actions.MapActionSet;
import realmeditor.editor.actions.MapReplaceTileAction;
import realmeditor.editor.actions.data.MapSelectData;
import realmeditor.editor.ui.MainView;
import realmeditor.editor.ui.TileMapView;
import realmeditor.util.IntPoint;

public class MEEraserTool extends METool {

    public function MEEraserTool(view:MainView) {
        super(METool.ERASER_ID, view);
    }

    public override function init(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.mainView.mapView.moveBrushOverlay(tilePos.x_, tilePos.y_, this.mainView.userBrush, true, true);
    }

    public override function mouseDrag(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.useEraser(tilePos, history);
    }

    public override function tileClick(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.useEraser(tilePos, history);
    }

    public override function mouseMoved(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.mainView.mapView.moveBrushOverlay(tilePos.x_, tilePos.y_, this.mainView.userBrush, true);
    }

    private function useEraser(tilePos:IntPoint, history:MapHistory):void {
        if (!this.mainView.mapView.isInsideSelection(tilePos.x_, tilePos.y_)){
            return;
        }

        var brush:MEBrush = this.mainView.userBrush;
        var mapX:int = tilePos.x_;
        var mapY:int = tilePos.y_;

        var action:MapReplaceTileAction = null;
        if (brush.size == 0) {
            action = eraseTile(this.mainView.userBrush, this.mainView.mapView.tileMap, mapX, mapY);
            if (action != null) {
                history.record(action);
            }
            return;
        }

        var actions:MapActionSet = new MapActionSet();
        var brushRadius:int = (1 + (brush.size * 2)) / 2;
        for (var y:int = mapY - brushRadius; y <= mapY + brushRadius; y++) {
            for (var x:int = mapX - brushRadius; x <= mapX + brushRadius; x++) {
                var dx:int = x - mapX;
                var dy:int = y - mapY;
                var distSq:int = dx * dx + dy * dy;
                if (distSq > brush.size * brush.size || !this.mainView.mapView.isInsideSelection(x, y)) {
                    continue;
                }

                action = eraseTile(this.mainView.userBrush, this.mainView.mapView.tileMap, x, y);
                if (action != null) {
                    actions.push(action);
                }
            }
        }

        history.recordSet(actions);
    }

    public static function eraseSelection(mainView:MainView, selection:MapSelectData, history:MapHistory):void {
        var brush:MEBrush = mainView.userBrush;
        var tileMap:TileMapView = mainView.mapView.tileMap;

        var action:MapReplaceTileAction = null;
        var actions:MapActionSet = new MapActionSet();

        for (var y:int = selection.startY; y <= selection.endY; y++) {
            for (var x:int = selection.startX; x <= selection.endX; x++) {
                if (!mainView.mapView.isInsideSelection(x, y)) {
                    continue;
                }

                action = eraseTile(brush, tileMap, x, y);
                if (action != null) {
                    actions.push(action);
                }
            }
        }

        history.recordSet(actions);
    }

    public static function eraseTile(brush:MEBrush, tileMap:TileMapView, mapX:int, mapY:int):MapReplaceTileAction {
        var prevData:MapTileData = tileMap.getTileData(mapX, mapY);
        if (prevData == null){
            return null;
        }
        else {
            prevData = prevData.clone();
        }

        switch (brush.elementType) {
            case MEDrawType.GROUND:
                if (prevData.groundType == -1) { // Don't update tile data if it's already default value
                    return null;
                }
                tileMap.clearGround(mapX, mapY); // No need to call drawTile after these
                break;
            case MEDrawType.OBJECTS:
                if (prevData.objType == 0) {
                    return null;
                }
                tileMap.clearObject(mapX, mapY);
                break;
            case MEDrawType.REGIONS:
                if (prevData.regType == 0) {
                    return null;
                }
                tileMap.clearRegion(mapX, mapY);
                break;
        }

        return new MapReplaceTileAction(mapX, mapY, prevData, tileMap.getTileData(mapX, mapY).clone());
    }
}
}
