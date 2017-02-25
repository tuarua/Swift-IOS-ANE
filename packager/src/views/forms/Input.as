package views.forms {
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFieldType;

import events.FormEvent;

import starling.core.Starling;
import starling.display.BlendMode;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Align;

import views.forms.NativeTextInput;

public class Input extends Sprite {
    private var inputBG:Image;
    private var w:int;
    private var nti:NativeTextInput;
    private var frozenText:TextField;
    private var isEnabled:Boolean = true;
    private var _password:Boolean = false;
    private var _type:String = TextFieldType.INPUT;
    private var _multiline:Boolean = false;
    private var _numLines:int;

    public function Input(_w:int, _txt:String, _h:int = 25) {
        super();
        this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
        w = _w;
        inputBG = new Image(Assets.getAtlas().getTexture("input-bg"));
        inputBG.scale9Grid = new Rectangle(4, 4, 16, 16);
        inputBG.width = _w;
        inputBG.height = _h;

        inputBG.blendMode = BlendMode.NONE;
        inputBG.touchable = false;

        frozenText = new TextField(_w - 10, _h, _txt);
        frozenText.format.setTo("Fira Sans Semi-Bold 13", 13);
        frozenText.format.horizontalAlign = Align.LEFT;
        frozenText.format.verticalAlign = Align.TOP;
        frozenText.format.color = 0xD8D8D8;

        frozenText.x = 6;
        frozenText.y = 4;

        frozenText.touchable = false;
        frozenText.batchable = true;
        frozenText.visible = false;
        nti = new NativeTextInput(_w - 10, _txt, false, 0xC0C0C0);
        nti.setHeight(_h);
        nti.addEventListener("CHANGE", onTextChange);
        nti.addEventListener(FormEvent.FOCUS_OUT, onFocusOut);
        addChild(inputBG);
        addChild(frozenText);
    }

    private function onFocusOut(event:flash.events.Event):void {
        this.dispatchEvent(new FormEvent(FormEvent.FOCUS_OUT));
    }

    protected function onTextChange(event:flash.events.Event):void {
        if (_password) {
            var asteriskString:String = "";
            for (var i:int=0;i < nti.input.text.length;i++){
                asteriskString = asteriskString + "*";
            }
            frozenText.text = asteriskString;
        }else{
            frozenText.text = nti.input.text;
        }
    }

    private function onAddedToStage(event:starling.events.Event):void {
        updatePosition();
        nti.addEventListener("CHANGE", changeHandler);
        nti.addEventListener(FormEvent.ENTER, enterHandler);
        Starling.current.nativeOverlay.addChild(nti);
    }

    private function enterHandler(event:flash.events.Event):void {
        this.dispatchEvent(new FormEvent(FormEvent.ENTER));
    }

    protected function changeHandler(event:flash.events.Event):void {
        this.dispatchEvent(new FormEvent(FormEvent.CHANGE));
    }

    public function freeze(value:Boolean = true):void {
        frozenText.visible = value;
        nti.show(!value);
        updatePosition();
    }

    public function updatePosition():void {
        try {
            var pos:Point = this.parent.localToGlobal(new Point(this.x, this.y));
            var offsetY:int = 1;
            nti.x = pos.x + 5;
            nti.y = pos.y + offsetY;
        } catch (e:Error) {

        }
    }

    public function enable(_b:Boolean):void {
        isEnabled = _b;
        inputBG.alpha = (_b) ? 1 : 0.25;
        nti.enable(_b);
    }

    public function set password(value:Boolean):void {
        nti.password = _password = value;
    }

    public function set type(value:String):void {
        nti.type = _type = value;
    }

    public function set multiline(value:Boolean):void {
        nti.multiline = _multiline = value;
    }

    public function set maxChars(value:uint):void {
        nti.maxChars = value;
    }

    public function set restrict(value:String):void {
        nti.restrict = value;
    }

    public function get text():String {
        return nti.input.text;
    }

    public function appendText(value:String):void {
        nti.input.appendText(value);
        frozenText.text += value;
    }

    public function set scrollV(value:int):void{
        nti.input.scrollV = value;
    }

    public function set text(value:String):void {
        frozenText.text = value;
        nti.input.text = value;
    }
    public function setFocus():void {
        Starling.current.nativeOverlay.stage.focus = nti.input;
    }

    public function get numLines():int {
        return nti.input.numLines;
    }

}
}