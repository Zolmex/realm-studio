package assetlab.view.elements {
import assetlab.view.UIAssetsView;

import common.Global;

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

public class SliceEditorWindow extends Sprite {

    private static const WIDTH:int = 355;
    private static const HEIGHT:int = 400;

    public static const EDITOR_WIDTH:int = WIDTH - 10;
    public static const EDITOR_HEIGHT:int = 290;
    private static const EDITOR_HEIGHT_ROOM:int = HEIGHT - EDITOR_HEIGHT;

    private var view:UIAssetsView;
    private var background:SliceScalingBitmap;
    private var title:SimpleText;
    private var cutNameInput:SimpleTextInput;
    private var sliceTypeInput:SimpleTextInput;
    private var editor:SliceEditor;
    private var editorMask:Shape;

    private var cutRect:Rectangle;
    private var sliceRect:Rectangle;

    private var saveButton:SimpleTextButton;
    private var cancelButton:SimpleTextButton;

    public function SliceEditorWindow(view:UIAssetsView) {
        this.view = view;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "maplist_background");
        this.background.width = WIDTH;
        this.background.height = HEIGHT;
        addChild(this.background);

        this.title = new SimpleText(12, Constants.TEXT_UI_COLOR);
        this.title.setText("Slice editor");
        this.title.updateMetrics();
        addChild(this.title);

        this.cutNameInput = new SimpleTextInput("Cut name", true);
        this.cutNameInput.inputText.restrict = "a-z A-Z 0-9";
        this.cutNameInput.setWidth(270);
        addChild(this.cutNameInput);

        this.sliceTypeInput = new SimpleTextInput("Slice type", true);
        this.sliceTypeInput.inputText.restrict = "a-z A-Z 0-9";
        this.sliceTypeInput.setWidth(160);
        addChild(this.sliceTypeInput);

        this.editor = new SliceEditor(this);
        addChild(this.editor);

        this.editorMask = new Shape();
        this.editorMask.graphics.beginFill(0);
        this.editorMask.graphics.drawRect(0, 0, EDITOR_WIDTH, EDITOR_HEIGHT);
        this.editorMask.graphics.endFill();
        this.editor.mask = this.editorMask;
        addChild(this.editorMask);

        this.saveButton = new SimpleTextButton("Save", 12, 0x00A700);
        this.saveButton.addEventListener(MouseEvent.CLICK, this.onSaveClick);
        addChild(this.saveButton);

        this.cancelButton = new SimpleTextButton("Cancel", 12);
        this.cancelButton.addEventListener(MouseEvent.CLICK, this.onCancelClick);
        addChild(this.cancelButton);

        this.positionChildren();
    }

    private function positionChildren():void {
        this.title.y = 1;
        this.title.x = (this.width - this.title.width) / 2;

        this.cutNameInput.x = 6;
        this.cutNameInput.y = this.title.y + this.title.height + 8;

        this.sliceTypeInput.x = this.cutNameInput.x;
        this.sliceTypeInput.y = this.cutNameInput.y + this.cutNameInput.height + 4;

        this.editorMask.x = (this.width - this.editorWidth) / 2;
        this.editorMask.y = this.sliceTypeInput.y + this.sliceTypeInput.height + 4;

        this.editor.x = this.editorMask.x;
        this.editor.y = this.editorMask.y;

        var btnsWidth:int = this.saveButton.width + this.cancelButton.width + 5;
        this.saveButton.x = (this.width - btnsWidth) / 2;
        this.saveButton.y = this.height - this.saveButton.height - 6;
        this.cancelButton.x = (this.width - btnsWidth) / 2 + this.saveButton.width + 5;
        this.cancelButton.y = this.saveButton.y;
    }

    private function onCancelClick(e:MouseEvent):void {
        this.view.showSliceEditor(false, null, null, null, null);
    }

    private function onSaveClick(e:MouseEvent):void {
        this.sliceRect = this.editor.sliceRect; // Editor's slice rect may have changed by the user
        this.view.saveCut(this.cutNameInput.inputText.text, this.cutRect, this.sliceTypeInput.inputText.text, this.sliceRect);
    }

    public function setSliceData(cutName:String, cutRect:Rectangle, sliceType:String, sliceRect:Rectangle):void{
        this.cutNameInput.inputText.setText(cutName || "");
        this.sliceTypeInput.inputText.setText(sliceType || "3grid");
        this.cutRect = cutRect;
        this.sliceRect = sliceRect;

        this.editor.displayTexture(this.view.contentView.atlas, cutRect, sliceRect);
    }

    public function resize():void {
        this.background.width = width;
        this.background.height = height;
        this.editorMask.graphics.clear();
        this.editorMask.graphics.beginFill(0);
        this.editorMask.graphics.drawRect(0, 0, this.editorWidth, this.editorHeight);
        this.editorMask.graphics.endFill();
        this.editor.resize();
        this.positionChildren();
    }

    public override function get width():Number {
        return WIDTH * Global.ScaleX;
    }

    public override function get height():Number {
        return HEIGHT * Global.ScaleY;
    }

    public function get editorWidth():Number {
        return width - 10;
    }

    public function get editorHeight():Number {
        return height - EDITOR_HEIGHT_ROOM;
    }
}
}
