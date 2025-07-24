package mapeditor.editor.ui {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import mapeditor.editor.MEEvent;
import mapeditor.editor.ui.elements.SimpleScrollbar;
import mapeditor.editor.ui.elements.SimpleText;
import mapeditor.editor.ui.embed.SliceScalingBitmap;
import mapeditor.editor.ui.embed.TextureParser;

public class MapSelectorView extends Sprite {

    public static const WIDTH:int = 150;
    private static const HEIGHT:int = 150;

    private var background:SliceScalingBitmap;
    private var mapSlotsContainer:Sprite;
    private var mapSlots:Dictionary;
    private var title:SimpleText;
    private var slotsContainerY:Number;
    private var scrollbar:SimpleScrollbar;

    public var selectedMap:int;

    public function MapSelectorView() {
        this.mapSlots = new Dictionary();

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "maplist_background");
        this.background.width = WIDTH;
        this.background.height = HEIGHT;
        addChild(this.background);

        this.title = new SimpleText(9, 0xB9A960);
        this.title.text = "Select map";
        this.title.setBold(true);
        this.title.updateMetrics();
        this.title.x = (WIDTH - this.title.width) / 2;
        this.title.y = 1;
        addChild(this.title);

        var slotsMask:Shape = new Shape();
        slotsMask.x = 1;
        slotsMask.y = this.title.y + this.title.actualHeight_ + 6;
        this.slotsContainerY = slotsMask.y;

        var g:Graphics = slotsMask.graphics;
        g.beginFill(0);
        g.drawRect(0, 0, WIDTH - 12, HEIGHT - slotsMask.y - 4);
        g.endFill();
        addChild(slotsMask);

        this.mapSlotsContainer = new Sprite();
        this.mapSlotsContainer.x = slotsMask.x;
        this.mapSlotsContainer.y = this.slotsContainerY;
        this.mapSlotsContainer.mask = slotsMask;
        addChild(this.mapSlotsContainer);

        this.scrollbar = new SimpleScrollbar();
        this.scrollbar.setup(HEIGHT - this.slotsContainerY - 4, 0, 0);
        this.scrollbar.x = WIDTH - this.scrollbar.width - 4;
        this.scrollbar.y = this.slotsContainerY;
        this.scrollbar.addEventListener(Event.CHANGE, this.onScrollbarChange);
        addChild(this.scrollbar);

        this.addEventListener(MouseEvent.MOUSE_WHEEL, this.onScroll);

        filters = Constants.SHADOW_FILTER_1;
    }

    private function onScrollbarChange(e:Event):void {
        this.mapSlotsContainer.y = -this.scrollbar.cursorPos + this.slotsContainerY;
        this.fixContainerPos();
    }

    private function onScroll(e:MouseEvent):void {
        e.stopImmediatePropagation(); // Make sure we don't zoom in/out the map

        var scroll:Number = e.delta * 10;
        this.mapSlotsContainer.y += scroll;
        this.fixContainerPos();
        this.scrollbar.update(this.mapSlotsContainer.y - this.slotsContainerY);
    }

    private function fixContainerPos():void {
        if (this.mapSlotsContainer.y > this.slotsContainerY) { // Top limit
            this.mapSlotsContainer.y = this.slotsContainerY;
        }
        if (this.mapSlotsContainer.height < HEIGHT - 5 - this.slotsContainerY) { // If the elements container is smaller than the view, don't scroll
            this.mapSlotsContainer.y = this.slotsContainerY;
        } else if (this.mapSlotsContainer.y < -this.mapSlotsContainer.height + HEIGHT - 5) { // Bottom limit
            this.mapSlotsContainer.y = -this.mapSlotsContainer.height + HEIGHT - 5;
        }
    }

    public function addMap(mapId:int, name:String):void {
        var slot:MapSelectorSlot = new MapSelectorSlot(mapId, name);
        slot.addEventListener(MouseEvent.CLICK, this.onSlotClick);
        this.mapSlotsContainer.addChild(slot);

        this.mapSlots[mapId] = slot;

        this.positionSlots();
    }

    public function removeMap(slot:MapSelectorSlot):void {
        slot.removeEventListener(MouseEvent.CLICK, this.onSlotClick);
        this.mapSlotsContainer.removeChild(slot);

        delete this.mapSlots[slot.mapId];

        this.positionSlots();

        this.dispatchEvent(new MapClosedEvent(MEEvent.MAP_CLOSED, slot.mapId));
    }

    private function positionSlots():void {
        var i:int = 0;
        for each (var mapSlot:MapSelectorSlot in this.mapSlots){
            mapSlot.y = i * mapSlot.height + i * 4; // 2 pixels separation between each slot
            i++;
        }

        this.fixContainerPos();

        this.scrollbar.setup(HEIGHT - this.slotsContainerY - 4, this.mapSlotsContainer.y - this.slotsContainerY, this.mapSlotsContainer.height - (HEIGHT - 5) + this.slotsContainerY);
        this.scrollbar.update(this.mapSlotsContainer.y - this.slotsContainerY);
    }

    private function onSlotClick(e:Event):void {
        for each (var mapSlot:MapSelectorSlot in this.mapSlots){
            mapSlot.setSelected(false);
        }

        var slot:MapSelectorSlot = e.target as MapSelectorSlot;
        slot.setSelected(true);

        this.selectedMap = slot.mapId;

        this.dispatchEvent(new Event(MEEvent.MAP_SELECT));
    }

    public function selectMap(mapId:int):void {
        if (mapId != -1 && this.mapSlots[mapId] == null){
            return;
        }

        if (this.mapSlots.length == 0){
            return;
        }

        for each (var mapSlot:MapSelectorSlot in this.mapSlots){
            mapSlot.setSelected(false);
        }

        if (mapId == -1) {
            for each (mapSlot in this.mapSlots){
                mapId = mapSlot.mapId;
                mapSlot.setSelected(true);
                break;
            }
        }
        else {
            this.mapSlots[mapId].setSelected(true);
        }
        this.selectedMap = mapId;
    }
}
}

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

import mapeditor.editor.MEEvent;
import mapeditor.editor.ui.MainView;
import mapeditor.editor.ui.MapSelectorView;
import mapeditor.editor.ui.MapView;
import mapeditor.editor.ui.elements.SimpleText;
import mapeditor.editor.ui.elements.TextTooltip;
import mapeditor.editor.ui.embed.SliceScalingBitmap;
import mapeditor.editor.ui.embed.TextureParser;

class MapSelectorSlot extends Sprite {

    public var mapId:int;
    private var mapName:String;

    private var background:SliceScalingBitmap;
    private var mapNameText:SimpleText;
    private var mapIdText:SimpleText;
    private var selected:Boolean;
    private var cross:Sprite;
    private var closeTooltip:TextTooltip;

    public function MapSelectorSlot(mapId:int, name:String){
        this.mapId = mapId;
        this.mapName = name;

        var mapView:MapView = MainView.Instance.mapViewContainer.maps[mapId] as MapView;
        mapView.tileMap.addEventListener(MEEvent.MAP_CHANGED, this.onMapChanged);
        mapView.mapData.addEventListener(MEEvent.MAP_SAVED, this.onMapSaved);

        this.background = TextureParser.instance.getSliceScalingBitmap("UI", "maplist_element_background");
        this.background.scaleX = 1.35;
        this.background.scaleY = 1.35;
        this.background.x = 12;
        addChild(this.background);

        this.mapIdText = new SimpleText(10, 0x888888);
        this.mapIdText.setText(mapId.toString() + "." + (!mapView.mapData.savedChanges ? " *" : ""));
        this.mapIdText.updateMetrics();
        this.mapIdText.x = 0;
        this.mapIdText.y = (this.background.height - this.mapIdText.actualHeight_) / 2;
        addChild(this.mapIdText);

        this.mapNameText = new SimpleText(10, 0x888888, false, this.background.width - 3);
        this.mapNameText.setAutoSize(TextFieldAutoSize.LEFT);
        this.mapNameText.setText(name);
        this.mapNameText.updateMetrics();
        this.mapNameText.x = this.background.x + ((this.background.width - this.mapNameText.actualWidth_) / 2);
        this.mapNameText.y = (this.background.height - this.mapNameText.actualHeight_) / 2;
        addChild(this.mapNameText);

        this.cross = new Sprite();
        this.cross.addEventListener(MouseEvent.CLICK, this.onCrossClick);
        addChild(this.cross);

        var crossBmp:Bitmap = TextureParser.instance.getTexture("UI", "close_icon");
        this.cross.addChild(crossBmp);

        this.cross.x = this.background.x + this.background.width;
        this.cross.y = (this.background.height - crossBmp.height) / 2;

        this.cross.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
    }

    private function onMapChanged(e:Event):void {
        this.mapIdText.setText(this.mapId.toString() + ".*");
        this.mapIdText.updateMetrics();
    }

    private function onMapSaved(e:Event):void {
        this.mapIdText.setText(this.mapId.toString() + ".");
        this.mapIdText.updateMetrics();
    }

    private function onCrossClick(e:Event):void {
        e.stopImmediatePropagation(); // Don't let the slot click trigger

        (parent.parent as MapSelectorView).removeMap(this);
    }

    private function onRollOver(e:Event):void {
        if (this.closeTooltip == null) {
            this.closeTooltip = new TextTooltip(this.cross, "<b>Close</b>", 16, 0xFFFFFF);
            this.closeTooltip.addSubText("<b>Save map before closing!</b>", 12, 0x888888);
            MainView.Main.stage.addChild(this.closeTooltip);
        }
    }

    public function setSelected(val:Boolean):void {
        this.selected = val;
        this.mapIdText.setColor(val ? 0xB9A960 : 0x888888);
        this.mapNameText.setColor(val ? 0xB9A960 : 0x888888);
    }
}
