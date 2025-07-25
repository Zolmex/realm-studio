package mapeditor.editor.ui {
import common.assets.GroundLibrary;
import common.assets.ObjectLibrary;
import common.assets.RegionLibrary;
import common.ui.SliceScalingBitmap;
import common.ui.TextureParser;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import mapeditor.editor.MEDrawType;
import mapeditor.editor.ui.elements.IDrawElementFilter;
import mapeditor.editor.ui.elements.SearchInputBox;
import mapeditor.editor.ui.elements.SimpleScrollbar;
import mapeditor.editor.ui.elements.SimpleText;

public class MapDrawElementListView extends Sprite {

    public static const WIDTH:int = 182;
    private static const ELEMENT_SIZE:int = 38;

    private var title:SimpleText;
    private var background:SliceScalingBitmap;
    private var listMask:Shape;
    private var listContainer:Sprite;
    private var selectionSquare:Bitmap;
    public var selectedElement:MapDrawElement;
    public var totalHeight:int;
    private var searchInputBox:SearchInputBox;
    private var listYLimit:Number;
    private var drawType:int;
    private var elementTypes:Dictionary;
    private var scrollbar:SimpleScrollbar;

    private var elementFilters:Vector.<IDrawElementFilter>;
    private var searchFilter:DrawListSearchFilter;
    private var objectFilter:DrawListObjectFilter;

    public function MapDrawElementListView() {
        this.totalHeight = MainView.StageHeight - 80;

        this.elementFilters = new Vector.<IDrawElementFilter>();
        this.searchFilter = new DrawListSearchFilter();
        this.objectFilter = new DrawListObjectFilter();
        this.loadElementFilters();

        var parser:TextureParser = TextureParser.instance;
        this.background = parser.getSliceScalingBitmap("UI", "drawelementsview_background");
        this.resizeBackground();
        addChild(this.background);

        this.title = new SimpleText(9, 0xB9A960);
        this.title.text = "Preview";
        this.title.updateMetrics();
        this.title.x = (this.background.width - this.title.width) / 2;
        this.title.y = 2;
        addChild(this.title);

        this.listContainer = new Sprite();
        addChild(this.listContainer);

        this.searchInputBox = new SearchInputBox(154, 15, 9, "Enter name to find...", 0x414141);
        this.searchInputBox.x = 5;
        this.searchInputBox.y = 19;
        this.searchInputBox.inputText.addEventListener(Event.CHANGE, this.onInputChange);
        addChild(this.searchInputBox);
        this.listYLimit = this.searchInputBox.y + this.searchInputBox.height + 2.5;

        this.listMask = new Shape();
        this.drawListMask();
        this.listContainer.mask = this.listMask;
        addChild(this.listMask);

        this.scrollbar = new SimpleScrollbar();
        this.scrollbar.setup(this.totalHeight - this.searchInputBox.y - 2, 0, 0);
        this.scrollbar.x = WIDTH - this.scrollbar.width - 4;
        this.scrollbar.y = this.searchInputBox.y;
        this.scrollbar.addEventListener(Event.CHANGE, this.onScrollbarChange);
        addChild(this.scrollbar);

        this.selectionSquare = parser.getTexture("UI", "drawelement_selection_decor");
        this.selectionSquare.visible = false;
        addChild(this.selectionSquare);

        this.addEventListener(MouseEvent.MOUSE_WHEEL, this.onScroll);

        filters = Constants.SHADOW_FILTER_1;
    }

    public function addPropertyFilter(propName:String, value:*):void {
        this.objectFilter.addProp(propName, value);
        this.setContent(this.drawType);
    }

    public function removePropertyFilter(propName:String):void {
        this.objectFilter.removeProp(propName);
        this.setContent(this.drawType);
    }

    private function loadElementFilters():void {
        this.elementFilters.push(this.searchFilter);
        this.elementFilters.push(this.objectFilter);
    }

    public function resetFilters():void {
        this.searchFilter.reset();
    }

    private function onInputChange(e:Event):void {
        this.searchFilter.setSearch(this.searchInputBox.inputText.text);
        this.setContent(this.drawType);
    }

    public function setContent(drawType:int):void {
        this.listContainer.removeChildren(); // Clear elements from container
        this.listContainer.y = this.listYLimit;

        this.drawType = drawType;
        var textureDict:Dictionary;
        switch(drawType){
            case MEDrawType.GROUND:
                textureDict = GroundLibrary.typeToTextureData_;
                break;
            case MEDrawType.OBJECTS:
                textureDict = ObjectLibrary.typeToTextureData_;
                break;
            case MEDrawType.REGIONS:
                textureDict = RegionLibrary.typeToTextureData_;
                break;
        }

        for each (var filter:IDrawElementFilter in this.elementFilters) {
            filter.setDrawType(drawType);
        }

        this.elementTypes = new Dictionary();

        var i:int = 0;
        for (var key:int in textureDict) {
            var filterPass:int = 0;
            for each (filter in this.elementFilters) {
                if (filter.filter(key)) {
                    filterPass++;
                }
            }

            if (filterPass < this.elementFilters.length) { // All filters must pass
                continue;
            }

            var element:MapDrawElement = new MapDrawElement(key, textureDict[key].getTexture(0), drawType);
            element.addEventListener(MouseEvent.CLICK, this.onElementClick);

            this.elementTypes[key] = element;
            this.drawElement(i, element);
            i++;
        }

        this.selectionSquare.visible = false;
        this.listContainer.addChild(this.selectionSquare);
        this.scrollbar.setup(this.totalHeight - this.searchInputBox.y - 2, this.listContainer.y - this.listYLimit, this.listContainer.height - this.totalHeight + this.listYLimit);
    }

    private function onElementClick(e:Event):void {
        var targetElement:MapDrawElement = e.target as MapDrawElement;
        if (this.selectedElement != null && targetElement == this.selectedElement) {
            this.selectedElement = null;
            this.selectionSquare.visible = false;
            return;
        }

        this.selectedElement = targetElement;
        this.selectionSquare.x = this.selectedElement.x;
        this.selectionSquare.y = this.selectedElement.y;
        this.selectionSquare.visible = true;

        this.dispatchEvent(new Event(Event.SELECT));
    }

    public function setSelected(elementType:int):void {
        var element:MapDrawElement = this.elementTypes[elementType];
        if (element == null){
            return;
        }

        this.selectedElement = element;
        this.selectionSquare.x = this.selectedElement.x;
        this.selectionSquare.y = this.selectedElement.y;
        this.selectionSquare.visible = true;

        this.listContainer.y = this.listYLimit - this.selectionSquare.y;
        this.fixListPosition();
    }

    private function onScrollbarChange(e:Event):void {
        this.listContainer.y = -this.scrollbar.cursorPos + this.listYLimit;
        this.fixListPosition();
    }

    private function onScroll(e:MouseEvent):void {
        e.stopImmediatePropagation(); // Make sure we don't zoom in/out the map
        var scroll:Number = e.delta * 10;
        this.listContainer.y += scroll;
        this.fixListPosition();
        this.scrollbar.update(this.listContainer.y - this.listYLimit);
    }

    private function fixListPosition():void {
        if (this.listContainer.y > this.listYLimit) { // Top limit
            this.listContainer.y = this.listYLimit;
        }
        if (this.listContainer.height < this.totalHeight) { // If the elements container is smaller than the view, don't scroll
            this.listContainer.y = this.listYLimit;
        } else if (this.listContainer.y < -this.listContainer.height + this.totalHeight) { // Bottom limit
            this.listContainer.y = -this.listContainer.height + this.totalHeight;
        }
    }

    private function resizeBackground():void {
        this.background.height = this.totalHeight + 4;
    }

    private function drawListMask():void {
        var yPos:Number = this.searchInputBox.y + this.searchInputBox.height + 2;
        var g:Graphics = this.listMask.graphics;
        g.clear();
        g.beginFill(0);
        g.drawRect(5, yPos, WIDTH - 5, this.totalHeight - yPos - 2.5);
        g.endFill();
    }

    public function onScreenResize():void {
        this.totalHeight = MainView.StageHeight - 80;

        this.resizeBackground();
        this.fixListPosition();
        this.drawListMask();
        this.scrollbar.setup(this.totalHeight - this.searchInputBox.y - 2, this.listContainer.y - this.listYLimit, this.listContainer.height - this.totalHeight + this.listYLimit);
    }

    private function drawElement(id:int, element:MapDrawElement):void {
        if (element.texture == null) {
            trace("null element texture");
            return;
        }

        element.x = 5 + int(id % 4) * (ELEMENT_SIZE + 2);
        element.y = int(id / 4) * (ELEMENT_SIZE + 2);
        this.listContainer.addChild(element);
    }
}
}
