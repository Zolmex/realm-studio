# realm-editor

# Changelog

* Replaced all keybinds with the RotMG map editor layout
* Added Ctrl dragging, Shift selecting, Selection deletion
* Added descriptions to all tools, showing their keybinds and all other related features
* Write terrain to JSON maps, it doesn't work with them but when porting back to wmap this data won't be lost
* To test maps, using a TEST_CONNECT event instead of Flash's Event.CONNECT
* Selection info panel: shows width and height of current selection, useful cause it works as a ruler
* Map Info Panel: Moved the map width/height to bottom left in its own panel, and made it more obvious that you can edit the dimensions.
* !!! Using <b>Little Endian</b> encoding for json maps:<br>
DoM uses LITTLE_ENDIAN for maps, you can disable it by simply deleting all 3 lines in MainView.
* Fixed a bug where name of objects was saved if it was empty