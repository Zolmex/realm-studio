package assetlab.view.elements {
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;
import common.ui.elements.SimpleScrollbar;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class VerticalListView extends Sprite {

    public static const SLOT_SELECTED:String = "SlotSelected";

    private var background:SliceScalingBitmap;
    private var fileContainer:Sprite;
    private var fileContainerMask:Shape;
    private var slots:Vector.<VerticalListSlot> = new <VerticalListSlot>[];
    private var scrollbar:SimpleScrollbar;
    public var selectedSlot:VerticalListSlot;

    private const listYLimit:int = 3;
    private var viewHeight:int;

    public function VerticalListView( width:int, height:int) {
        this.viewHeight = height - 2;

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "search_input_background");
        this.background.width = width;
        this.background.height = height;
        addChild(this.background);

        this.fileContainer = new Sprite();
        this.fileContainer.x = 2;
        this.fileContainer.y = this.listYLimit;
        addChild(this.fileContainer);

        this.fileContainerMask = new Shape();
        this.fileContainerMask.graphics.beginFill(0);
        this.fileContainerMask.graphics.drawRect(2, this.listYLimit, width - 4, height - 4);
        this.fileContainerMask.graphics.endFill();
        this.fileContainer.mask = this.fileContainerMask;
        addChild(this.fileContainerMask);

        this.scrollbar = new SimpleScrollbar();
        this.scrollbar.setup(this.viewHeight - 4, 0, 0);
        this.scrollbar.x = width - this.scrollbar.width - 3;
        this.scrollbar.y = this.listYLimit;
        this.scrollbar.addEventListener(Event.CHANGE, this.onScrollbarChange);
        addChild(this.scrollbar);

        addEventListener(MouseEvent.MOUSE_WHEEL, this.onScroll);
    }

    private function onScrollbarChange(e:Event):void {
        this.fileContainer.y = -this.scrollbar.cursorPos + this.listYLimit;
        this.fixListPosition();
    }

    private function onScroll(e:MouseEvent):void {
        e.stopImmediatePropagation();
        var scroll:Number = e.delta * 10;
        this.fileContainer.y += scroll;
        this.fixListPosition();
        this.scrollbar.update(this.fileContainer.y - this.listYLimit);
    }

    private function fixListPosition():void {
        if (this.fileContainer.y > this.listYLimit) { // Top limit
            this.fileContainer.y = this.listYLimit;
        }
        if (this.fileContainer.height < this.viewHeight) { // If the elements container is smaller than the view, don't scroll
            this.fileContainer.y = this.listYLimit;
        } else if (this.fileContainer.y < -this.fileContainer.height + this.viewHeight) { // Bottom limit
            this.fileContainer.y = -this.fileContainer.height + this.viewHeight;
        }
    }

    private function onFileSlotClicked(e:MouseEvent):void {
        if (this.selectedSlot != null) {
            this.selectedSlot.setSelected(false);
        }

        var fileSlot:VerticalListSlot = e.target as VerticalListSlot;
        fileSlot.setSelected(true);
        this.selectedSlot = fileSlot;

        dispatchEvent(new Event(SLOT_SELECTED));
    }

    public function clear():void {
        this.fileContainer.removeChildren(); // Clear before re-adding file slots
        this.slots.length = 0;

        this.scrollbar.setup(this.viewHeight - 4, this.fileContainer.y - this.listYLimit, this.fileContainer.height - this.viewHeight + this.listYLimit);
    }

    public function addSlot(slot:VerticalListSlot):void {
        slot.setSelected(this.slots.length == 0);
        slot.x = 2;
        slot.y = 2 + (VerticalListSlot.HEIGHT * this.slots.length);
        slot.addEventListener(MouseEvent.CLICK, this.onFileSlotClicked);

        if (slot.selected) {
            this.selectedSlot = slot;
            dispatchEvent(new Event(SLOT_SELECTED));
        }

        this.fileContainer.addChild(slot);
        this.slots.push(slot);

        this.scrollbar.setup(this.viewHeight - 4, this.fileContainer.y - this.listYLimit, this.fileContainer.height - this.viewHeight + this.listYLimit);
    }

    public function resize(width:Number, height:Number):void {
        this.viewHeight = height - 2;
        this.fixListPosition();
        this.scrollbar.setup(this.viewHeight - 4, this.fileContainer.y - this.listYLimit, this.fileContainer.height - this.viewHeight + this.listYLimit);

        this.background.width = width;
        this.background.height = height;

        this.fileContainerMask.graphics.clear();
        this.fileContainerMask.graphics.beginFill(0);
        this.fileContainerMask.graphics.drawRect(2, this.listYLimit, width - 4, height - 4);
        this.fileContainerMask.graphics.endFill();
    }
}
}
