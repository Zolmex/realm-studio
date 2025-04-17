package realmeditor.editor.ui {

import flash.ui.Keyboard;
import flash.utils.Dictionary;

import realmeditor.editor.MEEvent;

public class Keybinds {

    public static var KEYS:Dictionary;
    public static var CTRL_KEYS:Dictionary; // Ctrl + key
    public static var SHIFT_KEYS:Dictionary; // Shift + key
    public static var ALT_KEYS:Dictionary; // Alt + key
    public static var HELD_CTRL_KEYS:Dictionary;
    public static var HELD_KEYS:Dictionary;

    public static function loadKeys():void {
        KEYS = new Dictionary();
        CTRL_KEYS = new Dictionary();
        SHIFT_KEYS = new Dictionary();
        ALT_KEYS = new Dictionary();
        HELD_KEYS = new Dictionary();
        HELD_CTRL_KEYS = new Dictionary();
        KEYS[Keyboard.S] = MEEvent.TOOL_SWITCH_SELECT;
        KEYS[Keyboard.D] = MEEvent.TOOL_SWITCH_PENCIL;
        KEYS[Keyboard.L] = MEEvent.TOOL_SWITCH_LINE;
        KEYS[Keyboard.U] = MEEvent.TOOL_SWITCH_SHAPE;
        KEYS[Keyboard.F] = MEEvent.TOOL_SWITCH_BUCKET;
        KEYS[Keyboard.A] = MEEvent.TOOL_SWITCH_PICKER;
        KEYS[Keyboard.E] = MEEvent.TOOL_SWITCH_ERASER;
        KEYS[Keyboard.I] = MEEvent.TOOL_SWITCH_EDIT;
        KEYS[Keyboard.T] = MEEvent.DRAW_TYPE_SWITCH;
        KEYS[Keyboard.ESCAPE] = MEEvent.CLEAR_SELECTION;
        KEYS[Keyboard.UP] = MEEvent.MOVE_SELECTION_UP;
        KEYS[Keyboard.DOWN] = MEEvent.MOVE_SELECTION_DOWN;
        KEYS[Keyboard.LEFT] = MEEvent.MOVE_SELECTION_LEFT;
        KEYS[Keyboard.RIGHT] = MEEvent.MOVE_SELECTION_RIGHT;
        KEYS[Keyboard.F3] = MEEvent.TOGGLE_DEBUG;
        KEYS[Keyboard.DELETE] = MEEvent.DELETE_SELECTION;
        SHIFT_KEYS[Keyboard.G] = MEEvent.GRID_ENABLE;
        CTRL_KEYS[Keyboard.C] = MEEvent.COPY;
        CTRL_KEYS[Keyboard.V] = MEEvent.PASTE;
        HELD_CTRL_KEYS[Keyboard.Z] = MEEvent.UNDO;
        HELD_CTRL_KEYS[Keyboard.Y] = MEEvent.REDO;
        KEYS[Keyboard.NUMBER_1] = MEEvent.TILE_HOTKEY_SWITCH;
        KEYS[Keyboard.NUMBER_2] = MEEvent.TILE_HOTKEY_SWITCH;
        KEYS[Keyboard.NUMBER_3] = MEEvent.TILE_HOTKEY_SWITCH;
        KEYS[Keyboard.NUMBER_4] = MEEvent.TILE_HOTKEY_SWITCH;
        KEYS[Keyboard.NUMBER_5] = MEEvent.TILE_HOTKEY_SWITCH;
        KEYS[Keyboard.NUMBER_6] = MEEvent.TILE_HOTKEY_SWITCH;
        KEYS[Keyboard.NUMBER_7] = MEEvent.TILE_HOTKEY_SWITCH;
        KEYS[Keyboard.NUMBER_8] = MEEvent.TILE_HOTKEY_SWITCH;
        KEYS[Keyboard.NUMBER_9] = MEEvent.TILE_HOTKEY_SWITCH;
        KEYS[Keyboard.NUMBER_0] = MEEvent.TILE_HOTKEY_SWITCH;
    }
}
}
