package mapeditor.editor.tools {
import common.util.IntPoint;

import mapeditor.editor.MEBrush;
import mapeditor.editor.MapHistory;
import mapeditor.editor.MapTileData;
import mapeditor.editor.ui.MainView;

public class MEPickerTool extends METool {

    public function MEPickerTool(view:MainView) {
        super(METool.PICKER_ID, view);
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

        var userBrush:MEBrush = this.mainView.userBrush;
        var tileData:MapTileData = this.mainView.mapView.tileMap.getTileData(tilePos.x_, tilePos.y_);
        if (tileData == null) {
            return;
        }

        if (tileData.groundType != -1) {
            userBrush.setGroundType(tileData.groundType);
        }
        if (tileData.objType != 0) {
            userBrush.setObjectType(tileData.objType);
        }
        if (tileData.regType != 0) {
            userBrush.setRegionType(tileData.regType);
        }

        this.mainView.updateDrawElements();
    }
}
}
