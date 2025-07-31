package assetlab.view {
import flash.display.Sprite;

public class Model3DView extends Sprite {

    private var mainView:MainView;

    public function Model3DView(mainView:MainView) {
        this.mainView = mainView;

        graphics.beginFill(0x00FF00);
        graphics.drawRect(0, 0, 1000, 1000);
        graphics.endFill();
    }
}
}
