package realmeditor.editor.ui {
import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import realmeditor.editor.ToolSwitchEvent;
import realmeditor.editor.tools.METool;
import realmeditor.editor.ui.elements.SimpleText;
import realmeditor.editor.ui.embed.SliceScalingBitmap;
import realmeditor.editor.ui.embed.TextureParser;
import realmeditor.util.FilterUtil;
import realmeditor.util.MoreColorUtil;

public class MapToolbar extends Sprite {

    private static const ICON_SIZE:int = 34;
    private static const ICON_TO_TOOL:Array = [0, 1, 6, 5, 4, 2, 3, 7];

    private var title:SimpleText;
    private var view:MainView;
    private var background:Bitmap;
    private var icons:Vector.<ToolIconContainer>; // 0: select, 1: pencil, 2: erase, 3: picker, 4 (skip), 5: bucket, 6: line, 7: shape, 8 (skip), 9: edit
    private var selectionSquare:Bitmap;

    public function MapToolbar(view:MainView) {
        this.view = view;
        this.icons = new Vector.<ToolIconContainer>();

        this.background = TextureParser.instance.getTexture("UI", "toolbox_background");
        addChild(this.background);

        this.title = new SimpleText(8, 0xB9A960);
        this.title.setText("Tools");
        this.title.updateMetrics();
        this.title.x = (this.background.width - this.title.width) / 2;
        this.title.y = 1;
        addChild(this.title);

        var iconCount:int = 0;
        for (var i:int = 0; i < 10; i++) {
            if (i == 4 || i == 8) {
                continue;
            }

            var container:ToolIconContainer = new ToolIconContainer(i);
            container.scaleX = ICON_SIZE / container.icon.width;
            container.scaleY = ICON_SIZE / container.icon.height;
            container.x = 4;
            container.y = 16 + iconCount * ICON_SIZE + 3 * iconCount;
            container.transform.colorTransform = MoreColorUtil.darkCT; // Set as unselected
            container.addEventListener(MouseEvent.CLICK, this.onIconClick);
            iconCount++;

            addChild(container);
            this.icons.push(container);
        }

        this.selectionSquare = TextureParser.instance.getTexture("UI", "drawelement_selection_decor");
        this.selectionSquare.visible = false;
        addChild(this.selectionSquare);

        this.background.height = this.icons[7].y + ICON_SIZE + 5;

        this.icons[0].transform.colorTransform = MoreColorUtil.identity;

        filters = Constants.SHADOW_FILTER_1;
    }

    private function onIconClick(e:Event):void {
        e.stopImmediatePropagation();

        var icon:ToolIconContainer = e.target as ToolIconContainer;
        for (var i:int = 0; i < this.icons.length; i++) {
            this.icons[i].transform.colorTransform = MoreColorUtil.darkCT;
        }
        icon.transform.colorTransform = MoreColorUtil.identity;
        this.selectionSquare.visible = true;
        this.selectionSquare.x = icon.x - 2;
        this.selectionSquare.y = icon.y - 2;

        var idx:int = this.icons.indexOf(icon);
        this.view.onToolSwitch(new ToolSwitchEvent(ICON_TO_TOOL[idx]));
    }

    public function setSelected(toolId:int):void {
        for (var i:int = 0; i < this.icons.length; i++) {
            this.icons[i].transform.colorTransform = MoreColorUtil.darkCT;
        }

        var icon:ToolIconContainer;
        switch (toolId) {
            case METool.SELECT_ID:
                icon = this.icons[0];
                break;
            case METool.PENCIL_ID:
                icon = this.icons[1];
                break;
            case METool.ERASER_ID:
                icon = this.icons[2];
                break;
            case METool.PICKER_ID:
                icon = this.icons[3];
                break;
            case METool.BUCKET_ID:
                icon = this.icons[4];
                break;
            case METool.LINE_ID:
                icon = this.icons[5];
                break;
            case METool.SHAPE_ID:
                icon = this.icons[6];
                break;
            case METool.EDIT_ID:
                icon = this.icons[7];
                break;
            default:
                trace("Invalid icon id");
                return;
        }

        icon.transform.colorTransform = MoreColorUtil.identity;
        this.selectionSquare.visible = true;
        this.selectionSquare.x = icon.x - 2;
        this.selectionSquare.y = icon.y - 2;
    }
}
}

import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import realmeditor.assets.AssetLibrary;
import realmeditor.editor.tools.METool;
import realmeditor.editor.ui.MainView;
import realmeditor.editor.ui.elements.TextTooltip;
import realmeditor.editor.ui.embed.TextureParser;

class ToolIconContainer extends Sprite {

    private static const TOOL_ICONS:Object = {
        0: "selection_tool_icon",
        1: "pencil_tool_icon",
        2: "eraser_tool_icon",
        3: "picker_tool_icon",
        5: "bucket_tool_icon",
        6: "line_tool_icon",
        7: "shape_tool_icon",
        9: "edit_tool_icon"
    };

    public var icon:Bitmap;
    private var toolTextureId:int;
    private var tooltip:TextTooltip;

    public function ToolIconContainer(toolTextureId:int) {
        this.toolTextureId = toolTextureId;
        this.icon = TextureParser.instance.getTexture("UI", TOOL_ICONS[toolTextureId]);
        this.icon.smoothing = true;
        this.icon.pixelSnapping = PixelSnapping.ALWAYS;
        addChild(this.icon);

        this.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
    }

    private function onRollOver(e:Event):void {
        this.removeEventListener(MouseEvent.ROLL_OVER, this.onRollOver);

        var name:String = METool.ToolTextureIdToName(this.toolTextureId);
        var text:String = "<b>" + name + "</b>\n";
        text += font(METool.GetToolDescription(name), "#b3b3b3", 14);

        this.tooltip = new TextTooltip(this, text, 16, 0xFFFFFF);
        MainView.Main.stage.addChild(this.tooltip);
    }

    public static function font(text:String, color:String, size:int):String {
        var tagStr:String = "<font size=\"" + size + "\" color=\"" + color + "\">" + text + "</font>";
        return tagStr;
    }
}