package common.assets {
import flash.display.BitmapData;
import flash.utils.Dictionary;

public class AnimatedChars {

    public static var nameMap_:Dictionary = new Dictionary();

    public function AnimatedChars() {
        super();
    }

    public static function load(dict:Dictionary):void {
        for (var key:* in dict){
            var value:Object = dict[key]; // We know this is a vector of animated char
            var chars:Vector.<AnimatedChar> = new Vector.<AnimatedChar>();
            for each (var animChar:Object in value){
                var image:MaskedImage = new MaskedImage(animChar.origImage_.image_, animChar.origImage_.mask_);
                chars.push(new AnimatedChar(image,animChar.width_,animChar.height_,animChar.firstDir_));
            }
            nameMap_[key] = chars;
        }
    }

    public static function clear():void {
        nameMap_ = new Dictionary();
    }

    public static function getAnimatedChar(name:String, id:int):AnimatedChar {
        var chars:Vector.<AnimatedChar> = nameMap_[name];
        if (chars == null || id >= chars.length) {
            return null;
        }
        return chars[id];
    }

    public static function add(name:String, images:BitmapData, masks:BitmapData, charWidth:int, charHeight:int, sheetWidth:int, sheetHeight:int, firstDir:int):void {
        var image:MaskedImage = null;
        var chars:Vector.<AnimatedChar> = new Vector.<AnimatedChar>();
        var charImages:MaskedImageSet = new MaskedImageSet();
        charImages.addFromBitmapData(images, masks, sheetWidth, sheetHeight);
        for each(image in charImages.images_) {
            chars.push(new AnimatedChar(image, charWidth, charHeight, firstDir));
        }
        nameMap_[name] = chars;
    }
}
}
