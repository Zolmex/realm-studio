package mapeditor.editor.tools {
import mapeditor.editor.MapHistory;
import mapeditor.editor.ui.MainView;
import mapeditor.util.IntPoint;

public class MELineTool extends METool {

    public function MELineTool(view:MainView) {
        super(METool.LINE_ID, view);
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
}
}
