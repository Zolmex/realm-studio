package assetlab.view.elements {
import assetlab.view.UIAssetsView;

import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.elements.SimpleTextButton;
import common.ui.elements.SimpleTextInput;
import common.ui.text.SimpleText;
import common.util.Constants;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class CreateCutWindow extends Sprite {

    private static const WIDTH:int = 160;
    private static const HEIGHT:int = 180;

    private var view:UIAssetsView;
    private var background:SliceScalingBitmap;
    private var title:SimpleText;
    private var cutNameInput:SimpleTextInput;
    private var xInput:SimpleTextInput;
    private var yInput:SimpleTextInput;
    private var widthInput:SimpleTextInput;
    private var heightInput:SimpleTextInput;

    private var saveButton:SimpleTextButton;
    private var cancelButton:SimpleTextButton;

    public function CreateCutWindow(view:UIAssetsView) {
        this.view = view;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "maplist_background");
        this.background.width = WIDTH;
        this.background.height = HEIGHT;
        addChild(this.background);

        this.title = new SimpleText(12, Constants.TEXT_UI_COLOR);
        this.title.setText("Create new cut");
        this.title.setBold(true);
        this.title.updateMetrics();
        addChild(this.title);

        this.cutNameInput = new SimpleTextInput("Cut name", true);
        this.cutNameInput.inputText.restrict = "a-z A-Z 0-9";
        this.cutNameInput.setWidth(60);
        addChild(this.cutNameInput);

        this.xInput = new SimpleTextInput("X", true);
        this.xInput.inputText.restrict = "0-9";
        this.xInput.setWidth(115);
        addChild(this.xInput);

        this.yInput = new SimpleTextInput("Y", true);
        this.yInput.inputText.restrict = "0-9";
        this.yInput.setWidth(115);
        addChild(this.yInput);

        this.widthInput = new SimpleTextInput("Width", true);
        this.widthInput.inputText.restrict = "0-9";
        this.widthInput.setWidth(85);
        addChild(this.widthInput);

        this.heightInput = new SimpleTextInput("Height", true);
        this.heightInput.inputText.restrict = "0-9";
        this.heightInput.setWidth(80);
        addChild(this.heightInput);

        this.saveButton = new SimpleTextButton("Save", 12);
        this.saveButton.addEventListener(MouseEvent.CLICK, this.onSaveClick);
        addChild(this.saveButton);

        this.cancelButton = new SimpleTextButton("Cancel", 12, 0xAA0000);
        this.cancelButton.addEventListener(MouseEvent.CLICK, this.onCancelClick);
        addChild(this.cancelButton);

        this.positionChildren();
    }

    private function positionChildren():void {
        this.title.y = 1;
        this.title.x = (WIDTH - this.title.width) / 2;

        this.cutNameInput.x = 6;
        this.cutNameInput.y = this.title.y + this.title.height + 8;
        this.xInput.x = this.cutNameInput.x;
        this.xInput.y = this.cutNameInput.y + this.cutNameInput.height + 4;
        this.yInput.x = this.cutNameInput.x;
        this.yInput.y = this.xInput.y + this.xInput.height + 4;
        this.widthInput.x = this.cutNameInput.x;
        this.widthInput.y = this.yInput.y + this.yInput.height + 4;
        this.heightInput.x = this.cutNameInput.x;
        this.heightInput.y = this.widthInput.y + this.widthInput.height + 4;

        var btnsWidth:int = this.saveButton.width + this.cancelButton.width + 5;
        this.saveButton.x = (WIDTH - btnsWidth) / 2;
        this.saveButton.y = this.heightInput.y + this.heightInput.height + 5;
        this.cancelButton.x = (WIDTH - btnsWidth) / 2 + this.saveButton.width + 5;
        this.cancelButton.y = this.saveButton.y;
    }

    private function onCancelClick(e:MouseEvent):void {
        this.view.showCreateCutWindow(false, null);
    }

    private function onSaveClick(e:MouseEvent):void {
        var x:Number = Number(this.xInput.inputText);
        var y:Number = Number(this.yInput.inputText);
        var width:Number = Number(this.widthInput.inputText);
        var height:Number = Number(this.heightInput.inputText);
        this.view.saveCut(new Rectangle(x, y, width, height));
    }

    public function setCut(cutRect:Rectangle):void{
        this.xInput.inputText.setText(cutRect.x.toFixed());
        this.yInput.inputText.setText(cutRect.y.toFixed());
        this.widthInput.inputText.setText(cutRect.width.toFixed());
        this.heightInput.inputText.setText(cutRect.height.toFixed());
    }
}
}
