package realmeditor.editor.ui {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import realmeditor.editor.MEEvent;
import realmeditor.editor.ui.elements.SimpleText;
import realmeditor.editor.ui.elements.SimpleTextButton;
import realmeditor.editor.ui.embed.SliceScalingBitmap;
import realmeditor.editor.ui.embed.TextureParser;

public class ClosePromptWindow extends Sprite {

    private var background:SliceScalingBitmap;
    private var title:SimpleText;
    private var goBackButton:SimpleTextButton;
    private var closeButton:SimpleTextButton;
    private var content:Sprite;

    public function ClosePromptWindow() {
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "tooltip_header_background");
        this.background.alpha = 0.8;
        this.background.x = -4;
        this.background.y = -4;
        addChild(this.background);

        this.content = new Sprite();
        addChild(this.content);

        this.title = new SimpleText(16, 0xFFFFFF);
        this.title.setText("You have unsaved changes");
        this.title.setBold(true);
        this.title.updateMetrics();
        this.title.filters = Constants.SHADOW_FILTER_1;
        this.content.addChild(this.title);

        this.goBackButton = new SimpleTextButton("Go back", 14);
        this.goBackButton.addEventListener(MouseEvent.CLICK, this.onSaveClick);
        this.content.addChild(this.goBackButton);

        this.closeButton = new SimpleTextButton("Close without saving", 14, 0x874646);
        this.closeButton.addEventListener(MouseEvent.CLICK, this.onExitClick);
        this.content.addChild(this.closeButton);

        this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);

        filters = Constants.SHADOW_FILTER_1;
    }

    private function onAddedToStage(e:Event):void {
        this.updatePositions();
        this.drawBackground();
    }

    protected virtual function drawBackground():void{
        this.background.width = this.content.width + 8;
        this.background.height = this.content.height + 8;
    }

    protected virtual function updatePositions():void {
        this.title.x = 0;
        this.goBackButton.x = 0;
        this.goBackButton.y = this.title.y + this.title.height + 5;
        this.closeButton.x = this.goBackButton.x + this.goBackButton.width + 10;
        this.closeButton.y = this.goBackButton.y;
    }

    private function onSaveClick(e:Event):void {
        // Can't actually save the maps automatically (fuck as3) so just let user save the maps manually
        this.visible = false;
    }

    private function onExitClick(e:Event):void {
        this.dispatchEvent(new Event(MEEvent.CLOSE_NO_SAVE));
    }
}
}
