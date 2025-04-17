# realm-editor
Zolmex's Realm Editor, but with old RotMG editor keybinds and a couple new features.

## Changelog

* !!! Using <b>Little Endian</b> encoding for json maps:<br>
DoM uses LITTLE_ENDIAN for maps, you can disable it by simply deleting all 3 lines in MainView. (If your maps aren't opening correctly)

* Replaced all keybinds with the RotMG map editor layout
* Added Ctrl dragging, Shift selecting, Selection deletion
* Added descriptions to all tools, showing their keybinds and all other related features
* Write terrain to JSON maps, it doesn't work with them but when porting back to wmap this data won't be lost
* To test maps, using a TEST_CONNECT event instead of Flash's Event.CONNECT
* Selection info panel: shows width and height of current selection, useful cause it works as a ruler
* Map Info Panel: Moved the map width/height to bottom left in its own panel, and made it more obvious that you can edit the dimensions.
* Fixed a bug where name of objects was saved if it was empty
* Fixed a bug where window would not close due to event listener still existing when closing editor
* Added brush options panel, where you can type brush size, choose brush shape and change chance value
* Added Shape tool functionality, currently only has 1 shape: Random, the 3 other shapes are just placeholders
* Added a "Replace" checkbox for brushes
* Added Hot Keys for tiles, press 0-9 to bind a tile to that key
