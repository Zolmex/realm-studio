package assetlab.view {
import assetlab.view.elements.ContentView;

import flash.events.Event;

public class TextureSelectedEvent extends Event {

    public var File:String;
    public var Index:String;
    public var Animated:Boolean;

    public function TextureSelectedEvent(file:String, index:String, animated:Boolean) {
        super(ContentView.TEXTURE_SELECTED);
        this.File = file;
        this.Index = index;
        this.Animated = animated;
    }
}
}
