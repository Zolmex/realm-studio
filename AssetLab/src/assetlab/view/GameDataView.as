package assetlab.view {
import flash.display.Sprite;

public class GameDataView extends Sprite {

    private var mainView:MainView;

    public function GameDataView(mainView:MainView) {
        this.mainView = mainView;

        graphics.beginFill(0x0000FF);
        graphics.drawRect(0, 0, 1000, 1000);
        graphics.endFill();
    }
}
}
