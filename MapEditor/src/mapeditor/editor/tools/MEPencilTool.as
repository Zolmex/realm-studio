package mapeditor.editor.tools {
import mapeditor.editor.MEBrush;
import mapeditor.editor.MapHistory;
import mapeditor.editor.actions.MapActionSet;
import mapeditor.editor.actions.MapReplaceTileAction;
import mapeditor.editor.ui.MainView;
import mapeditor.util.IntPoint;

public class MEPencilTool extends METool {

    public function MEPencilTool(view:MainView) {
        super(METool.PENCIL_ID, view);
    }

    public override function init(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.mainView.mapView.moveBrushOverlay(tilePos.x_, tilePos.y_, this.mainView.userBrush, false, true);
    }

    public override function mouseDrag(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.usePencil(tilePos, history);
    }

    public override function tileClick(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.usePencil(tilePos, history);
    }

    public override function mouseMoved(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.mainView.mapView.moveBrushOverlay(tilePos.x_, tilePos.y_, this.mainView.userBrush);
    }

    private function usePencil(tilePos:IntPoint, history:MapHistory):void {
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
        var brushRadius:int = (1 + (brush.size * 2)) / 2;
        for (var y:int = mapY - brushRadius; y <= mapY + brushRadius; y++) {
            for (var x:int = mapX - brushRadius; x <= mapX + brushRadius; x++) {
                var dx:int = x - mapX;
                var dy:int = y - mapY;
                var distSq:int = dx * dx + dy * dy;
                if (distSq > brush.size * brush.size || !this.mainView.mapView.isInsideSelection(x, y)) {
                    continue;
                }

                action = this.paintTile(x, y);
                if (action != null) {
                    actions.push(action);
                }
            }
        }

        history.recordSet(actions);
    }
}
}
