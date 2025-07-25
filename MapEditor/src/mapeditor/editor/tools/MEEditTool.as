package mapeditor.editor.tools {
import common.util.IntPoint;

import mapeditor.editor.MapHistory;
import mapeditor.editor.MapTileData;
import mapeditor.editor.ui.MainView;

public class MEEditTool extends METool {

    public function MEEditTool(view:MainView) {
        super(METool.EDIT_ID, view);
    }

    public override function init(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.mainView.mapView.highlightTile(tilePos.x_, tilePos.y_);
    }

    public override function mouseMoved(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        this.mainView.mapView.highlightTile(tilePos.x_, tilePos.y_);
    }

    public override function tileClick(tilePos:IntPoint, history:MapHistory):void {
        if (tilePos == null){
            return;
        }

        var tileData:MapTileData = this.mainView.mapView.tileMap.getTileData(tilePos.x_, tilePos.y_);
        if (tileData == null || tileData.objType == 0) {
            return;
        }

        this.mainView.showEditNameView(tilePos.x_, tilePos.y_, tileData.objCfg);
    }
}
}
