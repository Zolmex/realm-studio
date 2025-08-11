package assetlab.view {
import common.Global;
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.util.Constants;

import flash.display.Sprite;

public class WorkspaceView extends Sprite {

    private static const WIDTH:int = 700;
    private static const HEIGHT:int = 500;

    private var mainView:MainView;
    public var imageSetsView:ImageSetsView;
    public var model3DView:Model3DView;
    public var gameDataView:GameDataView;
    public var window:TabbedWindow;

    public function WorkspaceView(mainView:MainView) {
        this.mainView = mainView;

        this.imageSetsView = new ImageSetsView(this);
        this.model3DView = new Model3DView(this);
        this.gameDataView = new GameDataView(this);

        this.window = new TabbedWindow(WIDTH, HEIGHT);
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
        this.window.resize(width, height);
        this.imageSetsView.resize();
        this.model3DView.resize();
        this.gameDataView.resize();
    }

    override public function get width():Number { // I need these property overrides cus the tab contents may be bigger than what is actually visible
        return WIDTH * Global.ScaleX;
    }

    override public function get height():Number {
        return HEIGHT * Global.ScaleY;
    }

    public function get contentWidth():Number {
        return width - 8;
    }

    public function get contentHeight():Number {
        return height - 8;
    }
}
}
