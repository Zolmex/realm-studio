package assetlab.view {
import common.Global;
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.util.Constants;

import flash.display.Sprite;

public class WorkspaceView extends Sprite {

    private static const WINDOW_WIDTH_SCALE_X:Number = 700.0 / 800.0;
    private static const WINDOW_HEIGHT_SCALE_Y:Number = 500.0 / 600.0;

    private var mainView:MainView;
    private var imageSetsView:ImageSetsView;
    private var model3DView:Model3DView;
    private var gameDataView:GameDataView;
    private var window:TabbedWindow;

    public function WorkspaceView(mainView:MainView) {
        this.mainView = mainView;

        this.imageSetsView = new ImageSetsView(mainView);
        this.model3DView = new Model3DView(mainView);
        this.gameDataView = new GameDataView(mainView);

        this.window = new TabbedWindow(700, 500);
        this.window.addTab("ImageSets", this.imageSetsView);
        this.window.addTab("3D Models", this.model3DView);
        this.window.addTab("GameData", this.gameDataView);
        addChild(this.window);

        filters = Constants.SHADOW_FILTER_1;
    }

    public function onStageResize():void {
        this.window.resize(Global.StageWidth * WINDOW_WIDTH_SCALE_X, Global.StageHeight * WINDOW_HEIGHT_SCALE_Y);
    }

    override public function get width():Number { // I need these property overrides cus the tab contents may be bigger than what is actually visible
        return Global.StageWidth * WINDOW_WIDTH_SCALE_X + 55;
    }

    override public function get height():Number {
        return Global.StageHeight * WINDOW_HEIGHT_SCALE_Y + 30;
    }
}
}
