package mapeditor.editor.ui {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mapeditor.editor.ui.elements.SimpleCloseButton;
import mapeditor.editor.ui.elements.SimpleOkButton;
import mapeditor.editor.ui.elements.SimpleText;
import mapeditor.editor.ui.embed.SliceScalingBitmap;
import mapeditor.editor.ui.embed.TextureParser;

public class MEWindow extends Sprite {

    protected var background:SliceScalingBitmap;
    protected var title:SimpleText;
    protected var okButton:SimpleOkButton;
    protected var closeButton:SimpleCloseButton;
    protected var content:Sprite;

    public function MEWindow(title:String) {
        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "maplist_background");
        this.background.x = -4;
        this.background.y = -4;
        addChild(this.background);

        this.content = new Sprite();
        addChild(this.content);

        this.title = new SimpleText(10, 0xB9A960);
        this.title.setText(title);
        this.title.updateMetrics();
        this.title.y = -2;
        this.title.filters = Constants.SHADOW_FILTER_1;
        this.content.addChild(this.title);

        this.okButton = new SimpleOkButton();
        this.okButton.addEventListener(MouseEvent.CLICK, this.onOkClick);
        this.content.addChild(this.okButton);

        this.closeButton = new SimpleCloseButton();
        this.closeButton.addEventListener(MouseEvent.CLICK, this.onCloseClick);
        this.content.addChild(this.closeButton);

        this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);

        filters = Constants.SHADOW_FILTER_1;
    }

    protected virtual function onAddedToStage(e:Event):void {
        this.updatePositions();
        this.drawBackground();
    }

    protected virtual function drawBackground():void{
        this.background.width = this.content.width + 15;
        this.background.height = this.content.height + 7;
    }

    protected virtual function updatePositions():void {
        this.title.x = 0;
        this.okButton.x = 0;
        this.okButton.y = this.title.y + this.title.height + 5;
        this.closeButton.x = this.okButton.x + this.okButton.width + 10;
        this.closeButton.y = this.okButton.y;
    }

    protected virtual function onOkClick(e:Event):void {
        e.stopImmediatePropagation();
    }

    protected virtual  function onCloseClick(e:Event):void {
        e.stopImmediatePropagation();
    }
}
}
