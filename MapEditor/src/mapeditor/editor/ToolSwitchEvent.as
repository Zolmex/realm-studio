package mapeditor.editor {
import flash.events.Event;

public class ToolSwitchEvent extends Event{

    public var toolId:int;

    public function ToolSwitchEvent(toolId:int) {
        super(MEEvent.TOOL_SWITCH);
        this.toolId = toolId;
    }
}
}
