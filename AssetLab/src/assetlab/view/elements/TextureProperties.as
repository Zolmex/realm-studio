package assetlab.view.elements {
import assetlab.io.LabAssets;
import assetlab.view.TextureSelectedEvent;
import assetlab.view.elements.GameDataEditView;

import common.assets.AssetLibrary;

import common.assets.TextureData;

import common.ui.TextureParser;

import common.ui.text.SimpleText;
import common.util.Constants;
import common.util.FilterUtil;
import common.util.MoreColorUtil;

import flash.display.Bitmap;

import flash.display.Bitmap;
import flash.display.PixelSnapping;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

public class TextureProperties extends Sprite {

    public static const SELECT_TEXTURE:String = "SelectTexture";
    private static const TEXT_WIDTH:int = 120;

    private var xml:XML;
    private var textureDisplay:GameDataTextureDisplay;
    private var fileText:SimpleText;
    private var indexText:SimpleText;
    private var editIcon:Bitmap;

    public function TextureProperties(xml:XML) {
        this.xml = xml;

        if (this.textureDisplay){
            removeChild(this.textureDisplay);
            this.textureDisplay = null;
        }

        var textureData:TextureData = LabAssets.getTextureData(xml);
        this.textureDisplay = new GameDataTextureDisplay(textureData);
        this.textureDisplay.addEventListener(MouseEvent.ROLL_OVER, this.onTextureRollOver);
        this.textureDisplay.addEventListener(MouseEvent.ROLL_OUT, this.onTextureRollOut);
        this.textureDisplay.addEventListener(MouseEvent.CLICK, this.onTextureClick);
        addChild(this.textureDisplay);

        this.editIcon = new Bitmap(AssetLibrary.getImageFromSet("editorTools", 1));
        this.editIcon.scaleX = 1.5;
        this.editIcon.scaleY = 1.5;
        this.editIcon.smoothing = true;
        this.editIcon.pixelSnapping = PixelSnapping.ALWAYS;
        this.editIcon.visible = false;
        this.editIcon.filters = Constants.SHADOW_FILTER_1;
        this.editIcon.x = (this.textureDisplay.width - this.editIcon.width) / 2;
        this.editIcon.y = (this.textureDisplay.height - this.editIcon.height) / 2;
        addChild(this.editIcon);

        var textureXML:Object = getTextureXML(xml);
        if (textureXML == null){
            return;
        }

        this.fileText = new SimpleText(10, Constants.TEXT_UI_COLOR, false, TEXT_WIDTH);
        this.fileText.setAutoSize(TextFieldAutoSize.LEFT);
        this.fileText.setText(textureXML.File);
        this.fileText.setBold(true);
        this.fileText.backgroundImage = TextureParser.instance.getSliceScalingBitmap("UI", "checkbox_title_background")
        this.fileText.updateMetrics();
        addChild(this.fileText);
        this.fileText.updateBackground();

        this.indexText = new SimpleText(10, Constants.TEXT_UI_COLOR, false, TEXT_WIDTH);
        this.indexText.setAutoSize(TextFieldAutoSize.LEFT);
        this.indexText.setText("0x" + int(textureXML.Index).toString(16));
        this.indexText.setBold(true);
        this.indexText.backgroundImage = TextureParser.instance.getSliceScalingBitmap("UI", "checkbox_title_background")
        this.indexText.updateMetrics();
        addChild(this.indexText);
        this.indexText.updateBackground();

        this.positionChildren();
    }

    private function positionChildren():void {
        this.fileText.x = this.textureDisplay.x + this.textureDisplay.width + 1;
        this.fileText.y = (this.textureDisplay.height - (this.fileText.height + this.indexText.height)) / 2;

        this.indexText.x = this.fileText.x;
        this.indexText.y = this.fileText.y + this.fileText.height + 5;
    }

    private function onTextureRollOver(e:MouseEvent):void {
        this.textureDisplay.startAnimation();
        this.textureDisplay.transform.colorTransform = MoreColorUtil.veryBrightCT;
        this.editIcon.visible = true;
    }

    private function onTextureRollOut(e:MouseEvent):void {
        this.textureDisplay.pauseAnimation();
        this.textureDisplay.transform.colorTransform = MoreColorUtil.identity;
        this.editIcon.visible = false;
    }

    private function onTextureClick(e:MouseEvent):void {
        this.textureDisplay.pauseAnimation();
        this.textureDisplay.transform.colorTransform = MoreColorUtil.identity;
        this.textureDisplay.removeEventListener(MouseEvent.ROLL_OVER, this.onTextureRollOver);
        this.textureDisplay.removeEventListener(MouseEvent.ROLL_OUT, this.onTextureRollOut);
        this.textureDisplay.alpha = 0.5;
        dispatchEvent(new Event(SELECT_TEXTURE));
    }

    private static function getTextureXML(xml:XML):Object {
        if (xml.hasOwnProperty("Texture")) {
            return xml.Texture;
        } else if (xml.hasOwnProperty("AnimatedTexture")) {
            return xml.AnimatedTexture;
        } else if (xml.hasOwnProperty("RandomTexture")) {
            return xml.RandomTexture;
        }
        return null;
    }

    public function onTextureSelected(e:TextureSelectedEvent):void {
        delete this.xml.Texture; // Delete all of the texture elements from the xml (AltTexture doesn't count)
        delete this.xml.AnimatedTexture;
        delete this.xml.RandomTexture;

        if (e.Animated){ // Re-add the correct texture element with updated
            this.xml.AnimatedTexture = new XML();
            this.xml.AnimatedTexture.File = e.File;
            this.xml.AnimatedTexture.Index = e.Index;
        }
        else{
            this.xml.Texture = new XML();
            this.xml.Texture.File = e.File;
            this.xml.Texture.Index = e.Index;
        }

        this.textureDisplay.setTexture(new TextureData(this.xml));

        this.textureDisplay.addEventListener(MouseEvent.ROLL_OVER, this.onTextureRollOver);
        this.textureDisplay.addEventListener(MouseEvent.ROLL_OUT, this.onTextureRollOut);
        this.textureDisplay.alpha = 1;
        this.editIcon.visible = false;

        this.fileText.setText(e.File);
        this.fileText.updateMetrics();

        this.indexText.setText(e.Index);
        this.indexText.updateMetrics();
    }
}
}
