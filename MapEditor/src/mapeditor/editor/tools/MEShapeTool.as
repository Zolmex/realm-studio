package mapeditor.editor.tools {
import common.util.IntPoint;

import flash.utils.Dictionary;

import mapeditor.editor.MEBrush;
import mapeditor.editor.MapHistory;
import mapeditor.editor.actions.MapActionSet;
import mapeditor.editor.actions.MapReplaceTileAction;
import mapeditor.editor.ui.MainView;

public class MEShapeTool extends METool {

    private var size:int;
    private var chance:int;
    private var shape:int;
    private var tiles:Vector.<IntPoint>;

    public function MEShapeTool(view:MainView) {
        super(METool.SHAPE_ID, view);
        this.tiles = new Vector.<IntPoint>();
    }

    public override function init(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.mainView.mapView.moveBrushOverlay(tilePos.x_, tilePos.y_, this.mainView.userBrush, false, true);
        this.size = mainView.userBrush.size;
        this.chance = mainView.userBrush.chance;
        this.shape = mainView.userBrush.brushShape;
        this.makeRandomTiles();
    }

    public override function mouseMoved(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        if (this.tiles.length == 0) {
            this.updateBrush();
            this.makeRandomTiles();
        }
        this.mainView.userBrush.shapeTiles = this.tiles;
        this.mainView.mapView.moveBrushOverlay(tilePos.x_, tilePos.y_, this.mainView.userBrush);
    }

    public override function brushChanged(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.updateBrush();
        this.makeRandomTiles();

        this.mainView.userBrush.shapeTiles = this.tiles;
        this.mainView.mapView.moveBrushOverlay(tilePos.x_, tilePos.y_, this.mainView.userBrush);
    }

    public override function tileClick(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.placeTiles(tilePos, history);
        this.makeRandomTiles();
        this.mainView.mapView.moveBrushOverlay(tilePos.x_, tilePos.y_, this.mainView.userBrush);
    }

    private function placeTiles(tilePos:IntPoint, history:MapHistory):void {
        if (!this.mainView.mapView.isInsideSelection(tilePos.x_, tilePos.y_)){
            return;
        }

        var brush:MEBrush = this.mainView.userBrush;
        var mapX:int = tilePos.x_;
        var mapY:int = tilePos.y_;

        var action:MapReplaceTileAction = null;
        if (brush.size == 0) {
            action = this.paintTile(mapX, mapY);
            if (action != null) {
                history.record(action);
            }
            return;
        }

        var actions:MapActionSet = new MapActionSet();
        for each (var pos:IntPoint in this.tiles) {
            var x:int = pos.x + tilePos.x;
            var y:int = pos.y + tilePos.y;
            if (!this.mainView.mapView.isInsideSelection(x, y)) {
                continue;
            }

            action = this.paintTile(x, y);
            if (action != null) {
                actions.push(action);
            }
        }

        history.recordSet(actions);
    }

    private function updateBrush():void {
        this.size = mainView.userBrush.size;
        this.chance = mainView.userBrush.chance;
        this.shape = mainView.userBrush.brushShape;
    }

    private function makeRandomTiles():void {
        this.tiles.length = 0;
        var brush:MEBrush = this.mainView.userBrush;

        var maxTiles:int = 0;
        var brushRadius:int = (1 + (brush.size * 2)) / 2;
        for (var y:int = -brushRadius; y <= brushRadius; y++) {
            for (var x:int = -brushRadius; x <= brushRadius; x++) {
                var dx:int = x;
                var dy:int = y;
                var distSq:int = dx * dx + dy * dy;
                if (distSq > brush.size * brush.size) {
                    continue;
                }

                maxTiles++;
            }
        }

        var pos:IntPoint;
        var tileDict:Dictionary = new Dictionary();
        var tileX:int;
        var tileY:int;
        var totalTiles:int = this.chance / 100.0 * maxTiles;
        do {
            tileX = plusMinus(brushRadius);
            tileY = plusMinus(brushRadius);
            var dist:int = tileX * tileX + tileY * tileY;
            var key:int = tileX + tileY * (brushRadius * 2 + 1);
            if (dist > brush.size * brush.size || tileDict[key] != null) {
                continue;
            }

            pos = new IntPoint(tileX, tileY);
            this.tiles.push(pos);
            tileDict[key] = pos;

        } while(this.tiles.length < totalTiles);
    }

    private function plusMinus(range:Number):Number {
        return Math.random() * range * 2 - range;
    }
}
}
