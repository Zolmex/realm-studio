package realmeditor.editor.ui.elements {
import flash.display.DisplayObject;
import flash.text.StyleSheet;

public class TextTooltip extends Tooltip {

    private static const CSS_TEXT:String = ".in { }";

    private var textField:SimpleText;
    private var subTextField:SimpleText;

    public function TextTooltip(target:DisplayObject, text:String, size:int = 18, color:uint = 0xFFFFFF) {
        this.textField = new SimpleText(size, color);
        var sheet:StyleSheet = new StyleSheet();
        sheet.parseCSS(CSS_TEXT);
        this.textField.styleSheet = sheet;
        this.textField.htmlText = text;
        this.textField.useTextDimensions();

        super(target);
    }

    protected override function addChildren():void {
        addChild(this.textField);
        if (this.subTextField){
            addChild(this.subTextField);
        }
    }

    protected override function positionChildren():void {
        this.textField.x = 5;
        this.textField.y = 5;

        if (this.subTextField){
            this.subTextField.x = this.textField.x;
            this.subTextField.y = this.textField.y + this.textField.height;
        }
    }

    public function addSubText(text:String, size:int = 14, color:uint = 0xFFFFFF, bold:Boolean = false):void {
        this.subTextField = new SimpleText(size, color);
        var sheet:StyleSheet = new StyleSheet();
        sheet.parseCSS(CSS_TEXT);
        this.textField.styleSheet = sheet;
        this.textField.htmlText = text;
        this.textField.useTextDimensions();

        this.updateChildren();
    }
}
}
