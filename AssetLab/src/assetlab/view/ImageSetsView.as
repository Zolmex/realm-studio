package assetlab.view {
import flash.display.Sprite;

public class ImageSetsView extends Sprite {

    private var mainView:MainView;

    public function ImageSetsView(mainView:MainView) {
        this.mainView = mainView;

        graphics.beginFill(0xFF0000);
        graphics.drawRect(0, 0, 1000, 1000);
        graphics.endFill();
    }
}
}
