package common.ui {
import common.ui.embed.UIAssets;

public class UIAssetAtlas {

    public static function load():void {
        TextureParser.load(new UIAssets.UI(), new UIAssets.UI_CONFIG(), new UIAssets.UI_SLICE_CONFIG(), "UI");
    }
}
}
