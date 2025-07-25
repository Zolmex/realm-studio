package mapeditor.editor.ui {

import common.ui.elements.ChoiceBox;
import common.ui.elements.ChoiceElement;

import flash.events.Event;

import mapeditor.editor.MEBrush;

public class BrushShapePanel extends BrushOptionPanel {

    private var choiceBox:ChoiceBox;

    private var shapeElements:Vector.<ChoiceElement> = new <ChoiceElement>[
        new ChoiceElement(MEBrush.SHAPE_RANDOM, "Random", 12, 0xB2B2B2, 10),
        new ChoiceElement(MEBrush.SHAPE_RANDOM_2, "Random2", 12, 0xB2B2B2, 10),
        new ChoiceElement(MEBrush.SHAPE_RANDOM_2, "Random3", 12, 0xB2B2B2, 10),
        new ChoiceElement(MEBrush.SHAPE_RANDOM_2, "Random4", 12, 0xB2B2B2, 10)
    ];

    public function BrushShapePanel(main:MainView) {
        super("Shape: ", main);
        var choiceId:int = getShapeIdFromValue(main.userBrush.brushShape);
        if (choiceId == -1) choiceId = 0;
        this.choiceBox = new ChoiceBox(shapeElements, 12, 0xB2B2B2, choiceId);
        this.choiceBox.addEventListener(Event.CHANGE, this.onChange);
        addChild(this.choiceBox);
        updatePositions();
    }

    public override function update(brush:MEBrush):void {
        var choiceId:int = getShapeIdFromValue(brush.brushShape);

        if (choiceId == -1)
            choiceId = 0;
        this.choiceBox.setSelected(choiceId);
        updatePositions();
    }

    private function updatePositions():void {
        this.choiceBox.x = this.titleText.x + this.titleText.width;
        this.choiceBox.y = this.titleText.y;
    }

    private function onChange(e:Event):void {
        var newShape:int = int(this.choiceBox.selectedElement.value);
        if (this.mainView.userBrush.brushShape != newShape)
            this.mainView.userBrush.setBrushShape(newShape);
        updatePositions();
        dispatchEvent(e);
    }

    private function getShapeIdFromValue(val:Object):int {
        var i:int = 0;
        for each (var e:ChoiceElement in this.shapeElements) {
            if (e.value == val) {
                return i;
            }
            i++;
        }

        return -1;
    }
}
}