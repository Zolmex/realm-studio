package assetlab.view.elements {
import common.assets.MaskedImage;
import common.assets.MaskedImage;
import common.assets.TextureData;
import common.util.TextureRedrawer;
import common.util.TextureRedrawer;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;
import flash.utils.getTimer;

public class GameDataTextureDisplay extends Sprite {

    private static const SIZE:Number = 120.0;

    private var textureData:TextureData;
    private var staticTexture:Bitmap;
    private var animatedTexture:Bitmap;
    private var animationFrames:Dictionary;
    private var finalSize:int;

    private var nextAnimationFrame:int;
    private var currentFrameIndex:int; // 0 - 1
    private var currentDirectionIndex:int; // 0 - 4 (Right, Left, Down, Up)
    private var currentActionIndex:int; // 0 - 2 (Stand, Walk, Attack)

    public function GameDataTextureDisplay(textureData:TextureData) {
        this.textureData = textureData;

        var texture:BitmapData = textureData.getTexture();
        var staticTexture:BitmapData = null;
        if (texture != null) {
            var textureSize:int = Math.max(texture.width, texture.height);
            this.finalSize = SIZE * (8.0 / textureSize);
            staticTexture = TextureRedrawer.redraw(texture, this.finalSize, true, 0);
        }
        this.staticTexture = new Bitmap(staticTexture);
        addChild(this.staticTexture);

        this.animatedTexture = new Bitmap(staticTexture);
        addChild(this.animatedTexture);

        if (textureData.animatedChar_ != null) {
            this.staticTexture.visible = false;
            this.animationFrames = textureData.animatedChar_.dict_;
        }
    }

    public function setTexture(textureData:TextureData):void {
        removeChildren();
        this.animationFrames = null;
        removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);

        this.textureData = textureData;

        var texture:BitmapData = textureData.getTexture();
        var staticTexture:BitmapData = null;
        if (texture != null) {
            var textureSize:int = Math.max(texture.width, texture.height);
            this.finalSize = SIZE * (8.0 / textureSize);
            staticTexture = TextureRedrawer.redraw(texture, this.finalSize, true, 0);
        }
        this.staticTexture = new Bitmap(staticTexture);
        addChild(this.staticTexture);

        this.animatedTexture = new Bitmap(staticTexture);
        addChild(this.animatedTexture);

        if (textureData.animatedChar_ != null) {
            this.staticTexture.visible = false;
            this.animationFrames = textureData.animatedChar_.dict_;
        }
    }

    public function startAnimation():void {
        if (this.animationFrames != null) {
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
    }

    public function pauseAnimation():void {
        if (this.animationFrames != null){
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
    }

    public function onEnterFrame(e:Event):void { // Animate the 4 walking animations and after that animate the 2 attack animations
        var time:int = getTimer();
        if (time < this.nextAnimationFrame) {
            return;
        }

        this.renderAnimation(time);
    }

    private function renderAnimation(time:int):void {
        var actionDict:Dictionary = this.animationFrames[this.currentDirectionIndex];
        if (actionDict == null){
            this.advanceAnimation();
            return;
        }

        var frames:Vector.<MaskedImage> = actionDict[this.currentActionIndex];
        var frameIndex:int = Math.min(this.currentFrameIndex, frames.length - 1);
        var texture:BitmapData = TextureRedrawer.removeTransparentPixels(MaskedImage(frames[frameIndex]).image_);
        this.animatedTexture.bitmapData = TextureRedrawer.redraw(texture, this.finalSize, true, 0);

        this.animatedTexture.x = (this.staticTexture.width - this.animatedTexture.width) / 2;
        this.animatedTexture.y = (this.staticTexture.height - this.animatedTexture.height) / 2;

        this.advanceAnimation();
        this.nextAnimationFrame = time + 300;
    }

    private function advanceAnimation():void {
        if (++this.currentFrameIndex >= 2) {
            this.currentFrameIndex = 0;
            if (++this.currentDirectionIndex >= 4) {
                this.currentDirectionIndex = 0;
                if (++this.currentActionIndex >= 3) {
                    this.currentActionIndex = 0;
                }
            }
        }
    }
}
}
