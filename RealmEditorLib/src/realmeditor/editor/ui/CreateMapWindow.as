package realmeditor.editor.ui {
import flash.events.Event;

import realmeditor.editor.MEEvent;
import realmeditor.editor.ui.elements.SimpleTextInput;

public class CreateMapWindow extends MEWindow {

    public var mapName:String;
    public var mapWidth:int;
    public var mapHeight:int;

    private var inputName:SimpleTextInput;
    private var inputWidth:SimpleTextInput;
    private var inputHeight:SimpleTextInput;

    public function CreateMapWindow() {
        super("New Map");

        this.inputName = new SimpleTextInput("Name:", true, "", 13, 0xB2B2B2, 13, 0x777777, true);
        this.inputName.setWidth(110);
        this.inputName.inputText.restrict = "a-z A-Z 0-9"; // lowercase, uppercase, and numbers allowed
        this.content.addChild(this.inputName);

        this.inputWidth = new SimpleTextInput("Width:", true, "", 13, 0xB2B2B2, 13, 0x777777, true);
        this.inputWidth.inputText.restrict = "0-9";
        this.content.addChild(this.inputWidth);

        this.inputHeight = new SimpleTextInput("Height:", true, "", 13, 0xB2B2B2, 13, 0x777777, true);
        this.inputHeight.inputText.restrict = "0-9";
        this.content.addChild(this.inputHeight);
    }

    protected override function updatePositions():void {
        super.updatePositions();

        this.inputName.x = 5;
        this.inputName.y = this.title.y + this.title.height + 5;
        this.inputWidth.x = this.inputName.x;
        this.inputWidth.y = this.inputName.y + this.inputName.height + 5;
        this.inputHeight.x = this.inputWidth.x;
        this.inputHeight.y = this.inputWidth.y + this.inputWidth.height + 5;

        this.okButton.x = this.inputWidth.x;
        this.okButton.y = this.inputHeight.y + this.inputHeight.height + 5;
        this.closeButton.x = this.okButton.x + this.okButton.width + 10;
        this.closeButton.y = this.okButton.y;
    }

    protected override function onOkClick(e:Event):void {
        super.onOkClick(e);

        this.mapName = this.inputName.inputText.text;
        this.mapWidth = int(this.inputWidth.inputText.text);
        this.mapHeight = int(this.inputHeight.inputText.text);

        if (this.mapName == "" || this.mapWidth == 0 || this.mapHeight == 0){
            return;
        }

        this.dispatchEvent(new Event(MEEvent.MAP_CREATE));

        this.visible = false;
    }

    protected override function onCloseClick(e:Event):void {
        super.onCloseClick(e);

        this.visible = false;
    }
}
}
