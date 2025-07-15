package realmeditor.editor.ui {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class TileHotkeys  extends Sprite {

    private var hotkeys:Vector.<MapDrawElement>;
    private var hotkeyElements:Vector.<TileHotkeyElement>; // null for default
    private var background:Shape;
    private var selectSquare:Shape;
    private var selected:int = -1;

    public function TileHotkeys() {
        this.hotkeys = new Vector.<MapDrawElement>(10);
        this.hotkeyElements = new Vector.<TileHotkeyElement>(10);
        this.background = new Shape();
        addChild(this.background);

        this.selectSquare = new Shape();
        var g:Graphics = this.selectSquare.graphics;
        g.lineStyle(2, 0xFFFFFF);
        g.drawRect(0, 0, 20, 20);
        this.selectSquare.visible = false;
        this.selectSquare.x = 5;
        this.selectSquare.y = 5;
        addChild(this.selectSquare);

        filters = Constants.SHADOW_FILTER_1;
    }

    public function getElement(number:int):MapDrawElement {
        return hotkeys[number];
    }

    public function setHotkey(number:int, element:MapDrawElement):void {
        this.hotkeys[number] = element;
        removeChild(this.selectSquare);
        this.updatePositions();
        this.drawBackground();
        addChild(this.selectSquare);
    }

    public function switchTo(number:int):void {
        var element:MapDrawElement = this.hotkeys[number];
        if (element == null)
            return;

        this.selected = number;
        this.selectSquare.y = hotkeyElements[number].y - 2;
    }

    private function updatePositions():void {
        var i:int;
        for (i = 0; i < this.hotkeyElements.length; i++) {
            var old:TileHotkeyElement = this.hotkeyElements[i];
            if (old == null)
                continue;
            old.removeEventListener(MouseEvent.CLICK, this.onElementClick);
            removeChild(old);
            this.hotkeyElements[i] = null;
        }

        var x:int = 7;
        var y:int = 7;
        for (i = 1; i < this.hotkeys.length + 1; i++) {
            var index:int = i % this.hotkeys.length; // makes 0 drawn last
            var element:MapDrawElement = this.hotkeys[index];
            if (element == null)
                continue;

            var tileElement:TileHotkeyElement = new TileHotkeyElement(index, element.elementType, element.drawType, element.texture);
            tileElement.addEventListener(MouseEvent.CLICK, this.onElementClick);
            this.hotkeyElements[index] = tileElement;
            tileElement.x = x;
            tileElement.y = y;
            addChild(tileElement);

            y += tileElement.height + 6;
        }

        this.selectSquare.visible = y > 7;
    }

    private function onElementClick(e:MouseEvent):void {
        var element:TileHotkeyElement = e.currentTarget as TileHotkeyElement;
        var index:int = this.hotkeyElements.indexOf(element);
        if (index == -1)
            return;

        this.switchTo(index);
        this.dispatchEvent(new TileHotkeyEvent(index));
    }

    private function drawBackground():void {
        var g:Graphics = this.background.graphics;
        if (this.hotkeys.length == 0) {
            g.clear();
            return;
        }
        g.clear();
        g.beginFill(Constants.BACK_COLOR_2, 0.8);
        g.drawRoundRect(0, 0, 30, height + 14, 5, 5);
        g.endFill();
    }
}
}