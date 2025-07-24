package mapeditor.editor.ui {
import flash.events.Event;

import mapeditor.editor.MEEvent;
import mapeditor.editor.ui.elements.SimpleTextInput;

public class MapDimensionsWindow extends MEWindow {

    public var mapWidth:int;
    public var mapHeight:int;

    private var inputWidth:SimpleTextInput;
    private var inputHeight:SimpleTextInput;

    public function MapDimensionsWindow() {
        super("Change map dimensions");

        this.inputWidth = new SimpleTextInput("Width:", true, "", 14, 0xB2B2B2, 12, 0x777777, true);
        this.inputWidth.inputText.restrict = "0-9";
        this.content.addChild(this.inputWidth);

        this.inputHeight = new SimpleTextInput("Height:", true, "", 14, 0xB2B2B2, 12, 0x777777, true);
        this.inputHeight.inputText.restrict = "0-9";
        this.content.addChild(this.inputHeight);
    }

    protected override function updatePositions():void {
        super.updatePositions();

        this.inputWidth.x = 5;
        this.inputWidth.y = this.title.y + this.title.height + 5;
        this.inputHeight.x = this.inputWidth.x;
        this.inputHeight.y = this.inputWidth.y + this.inputWidth.height + 5;

        this.okButton.x = this.inputWidth.x;
        this.okButton.y = this.inputHeight.y + this.inputHeight.height + 5;
        this.closeButton.x = this.okButton.x + this.okButton.width + 10;
        this.closeButton.y = this.okButton.y;
    }

    protected override function onOkClick(e:Event):void {
        super.onOkClick(e);

        this.mapWidth = int(this.inputWidth.inputText.text);
        this.mapHeight = int(this.inputHeight.inputText.text);
        if (this.mapWidth == 0 || this.mapHeight == 0){
            return;
        }

        this.dispatchEvent(new Event(MEEvent.MAP_DIMENSIONS_CHANGE));

        this.visible = false;
    }

    protected override function onCloseClick(e:Event):void {
        super.onCloseClick(e);

        this.visible = false;
    }
}
}
