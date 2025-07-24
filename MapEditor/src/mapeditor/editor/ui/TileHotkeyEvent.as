package mapeditor.editor.ui {
import flash.events.Event;

import mapeditor.editor.MEEvent;

public class TileHotkeyEvent extends Event{

    public var number:int;

    public function TileHotkeyEvent(number:int) {
        super(MEEvent.TILE_HOTKEY_SWITCH);
        this.number = number;
    }
}
}