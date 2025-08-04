package assetlab.view.elements {
import assetlab.io.LabAssets;
import assetlab.view.WorkspaceView;

import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.text.SimpleText;
import common.util.Constants;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

public class GameDataEditView extends Sprite {

    public static const WIDTH:int = 200;

    private var workspace:WorkspaceView;
    private var background:SliceScalingBitmap;
    private var title:SimpleText;

    private var textureProperties:TextureProperties;

    public function GameDataEditView(workspace:WorkspaceView, xml:XML) {
        this.workspace = workspace;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "settings_background");
        this.background.width = WIDTH;
        this.background.height = workspace.contentHeight;
        addChild(this.background);

        this.title = new SimpleText(10, Constants.TEXT_UI_COLOR, false, WIDTH - 8);
        this.title.setAutoSize(TextFieldAutoSize.LEFT);
        this.title.htmlText = "<b>" + xml.@id + "</b> (#" + int(xml.@type) + ")";
        this.title.updateMetrics();
        addChild(this.title);

        this.textureProperties = new TextureProperties(xml);
        addChild(this.textureProperties);

        this.positionChildren();
    }

    private function positionChildren():void {
        var titleWidth:int = Math.min(this.title.width, this.title.actualWidth_);
        this.title.x = (WIDTH - titleWidth) / 2;
        this.title.y = (18 - this.title.height) / 2;

        this.textureProperties.x = 2;
        this.textureProperties.y = 20;
    }

    public function resize():void {
        this.background.height = this.workspace.contentHeight;
    }
}
}
