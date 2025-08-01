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

        this.imageSetsView = new ImageSetsView(this);
        this.model3DView = new Model3DView(this);
        this.gameDataView = new GameDataView(this);

        this.window = new TabbedWindow(700, 500);
        this.window.addTab("ImageSets", this.imageSetsView);
        this.window.addTab("3D Models", this.model3DView);
        this.window.addTab("GameData", this.gameDataView);
        addChild(this.window);

        filters = Constants.SHADOW_FILTER_1;
    }

    public function onAssetsLoaded():void {
        this.imageSetsView.onAssetsLoaded();
        this.model3DView.onAssetsLoaded();
        this.gameDataView.onAssetsLoaded();
    }

    public function onStageResize():void {
        this.window.resize(Global.StageWidth * WINDOW_WIDTH_SCALE_X, Global.StageHeight * WINDOW_HEIGHT_SCALE_Y);
        this.imageSetsView.resize();
        this.model3DView.resize();
        this.gameDataView.resize();
    }

    override public function get width():Number { // I need these property overrides cus the tab contents may be bigger than what is actually visible
        return Global.StageWidth * WINDOW_WIDTH_SCALE_X;
    }

    override public function get height():Number {
        return Global.StageHeight * WINDOW_HEIGHT_SCALE_Y + 30;
    }

    public function get contentWidth():Number {
        return width - 8;
    }

    public function get contentHeight():Number {
        return height - 38;
    }
}
}
