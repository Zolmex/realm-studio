# realm-studio

<img width="1920" height="1009" alt="RealmStudio_v1 0_2J1UFhVAiY" src="https://github.com/user-attachments/assets/dd8b8b14-c616-4049-8b55-eb0e7ffaefb5" />


## Getting started
Download the .rar file from the [latest release](https://github.com/Zolmex/realm-editor/releases/latest) and extract the files into a folder, then simply run RealmStudio.exe to use the tool.

### Basic controls
Hold Shift while dragging left-click to select an area.

Drag middle-click to move the map around.

Use scroll-wheel to zoom in/out.

[Ctrl+C / Ctrl+V]: copy / pasting.

[Ctrl+Z / Ctrl+Y]: undoing / redoing.

[Shift + G]: toggle grid.

### Tools
- Select tool:
Drag left-click to select multiple tiles. Click once to select a single tile. Escape to unselect everything.
Hold click on selected tile/s to move them around the map.
- Pencil tool:
Affects selected area only.
Press left-click to draw selected tile/object/region (depending on what's selected in the left-side panel).
- Erase tool:
Affects selected area only.
Press left-click to erase tile/object/region.
- Picker tool:
Click on any tile/object/region on the map to select it for pencil tool.
- Bucket tool:
Click anywhere inside the selected area OR tile to fill it with the selected tile/object/region.
Hold Ctrl while using the bucket tool to replace all matching objects/tiles/regions in the entire map with the selected one.
- Line tool:
NOT IMPLEMENTED.
- Shape tool:
Random shape.
- Edit tool:
Click on an object to edit its name/cfg string.

<img width="159" height="43" alt="RealmStudio_v1 0_qiKDHA3Oiu" src="https://github.com/user-attachments/assets/1ae6809e-e793-4e61-a2bd-6ac0187d534d" />

You can change the map dimensions by clicking the button in the bottom left corner next to the map dimensions.

IMPORTANT: when changing the map size, it will always cut/add tiles on **all sides** of the map. So if you're shrinking the map, consider that you may lose tiles. Map size changes CANNOT be undone, so be cautious with that.

### Map testing
<img width="79" height="35" alt="RealmStudio_v1 0_1LYVxSOHIs" src="https://github.com/user-attachments/assets/95535226-f0c0-442e-adc4-226f3201a81f" />
Map testing is only available by implementing the RealmEditorLib into your pserver's client, and making the necessary changes, there's not an easy way to do this right now so... if you know, you know. You can give it a try and follow these changes I made to the betterSkillys client to implement the map editor, it's an older version but the changes required are almost identical, only need to replace Event.CONNECT with RealmEditorTestEvent.TEST_CONNECT. 🫡

### Property filter
Click the arrow to the left of the right-side panel (elements panel) to open the property filter list.

Write the name of the property and the desired value for it (leave blank for *true*).
Press "Add" to add it to the list.

The elements panel will update based on the filter list. Elements that don't match every property in the filter list will not show in the panel.

<img width="367" height="469" alt="RealmStudio_v1 0_yVHwXRpWvc" src="https://github.com/user-attachments/assets/b70ec173-164a-4ec3-909b-864c91f94b55" />


## Additional credits
- Gummy. Brush extensions (replace, random shape). Selection info panel. Map info panel. Fixed empty objects being saved. Tool descriptions. Tile hotkey binding.
- Aurusenth. Font. UI assets. Some layout changes.
