package assetlab.view.elements {
import assetlab.view.WorkspaceView;

import common.assets.AnimatedChar;

import common.assets.AnimatedChars;

import common.assets.ImageSet;
import common.ui.TextureParser;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.display.BitmapData;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.MouseEvent;

public class ContentViewUI extends Sprite { // Visualizer for UI Atlas and cut/slice configuration tool

    [Embed("../embed/CheckboardBackground.png")]
    private static const CheckboardBackground:Class;
    private var checkboardTexture:BitmapData;

    private var workspace:WorkspaceView;
    private var content:Sprite;
    private var contentBackground:Shape;
    private var bitmapLayer:Sprite;
    private var outlineLayer:Sprite;
    private var contentMask:Shape;

    private var atlasName:String;
    private var cutConfigs:Object; // JSON objects
    private var gridConfigs:Object;

    public function ContentViewUI(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.checkboardTexture = (new CheckboardBackground() as Bitmap).bitmapData;
        this.contentBackground = new Shape();

        this.bitmapLayer = new Sprite();
        this.outlineLayer = new Sprite();

        this.content = new Sprite();
        this.content.addChild(this.contentBackground);
        this.content.addChild(this.bitmapLayer);
        this.content.addChild(this.outlineLayer);
        addChild(this.content);

        this.contentMask = new Shape();
        this.contentMask.graphics.beginFill(0);
        this.contentMask.graphics.drawRect(0, 0, workspace.contentWidth - VerticalListView.WIDTH - 1, workspace.contentHeight);
        this.contentMask.graphics.endFill();
        this.content.mask = this.contentMask;
        addChild(this.contentMask);
    }

    public function displayAtlas(atlasName:String):void {
        var atlasObj:Object;
        if (atlasName in TextureParser.instance.textures) {
            atlasObj = TextureParser.instance.textures[atlasName];
        }
        else {
            trace("Invalid atlas name:", atlasName);
            return;
        }

        var atlas:Bitmap = atlasObj["texture"];
        this.atlasName = atlasName;
        this.cutConfigs = atlasObj["configuration"];
        this.gridConfigs = atlasObj["sliceRectangles"];

        this.bitmapLayer.removeChildren();
        this.bitmapLayer.addChild(atlas);

        this.outlineLayer.removeChildren();
        this.outlineLayer.x = 0;
        this.outlineLayer.y = 0;

        this.contentBackground.graphics.clear();
        this.contentBackground.graphics.beginBitmapFill(this.checkboardTexture);
        this.contentBackground.graphics.drawRect(0, 0, atlas.width, atlas.height);
        this.contentBackground.graphics.endFill();
    }

    public function resize():void {
        this.contentMask.graphics.clear();
        this.contentMask.graphics.beginFill(0);
        this.contentMask.graphics.drawRect(0, 0, this.workspace.contentWidth - VerticalListView.WIDTH - 1, this.workspace.contentHeight);
        this.contentMask.graphics.endFill();
    }
}
}
