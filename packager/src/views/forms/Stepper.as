package views.forms {
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFormatAlign;

import events.FormEvent;

import starling.core.Starling;
import starling.display.BlendMode;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

public class Stepper extends Sprite {
    private var inputBG:Image;

    private var upArrow:Image = new Image(Assets.getAtlas().getTexture("stepper-arrow"));
    private var downArrow:Image = new Image(Assets.getAtlas().getTexture("stepper-arrow"));
    private var w:int;
    private var nti:NativeTextInput;
    private var frozenText:TextField;
    private var isEnabled:Boolean = true;
    private var increment:int;
    private var _maxValue:int = -1;
    private var _minValue:int = -1;

    public function Stepper(_w:int, _txt:String, _maxChars:int = 3, _increment:int = 1) {
        super();
        this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
        w = _w;
        increment = _increment;

        inputBG = new Image(Assets.getAtlas().getTexture("stepper-bg"));
        inputBG.scale9Grid = new Rectangle(4, 0, 18, 0);

        inputBG.width = w;
        inputBG.blendMode = BlendMode.NONE;
        inputBG.touchable = false;

        frozenText = new TextField(w - 29, 25, _txt);
        frozenText.format.setTo("Fira Sans Semi-Bold 13", 13);
        frozenText.x = w - 29 - 35;
        frozenText.y = 4;
        frozenText.format.horizontalAlign = Align.LEFT;
        frozenText.format.verticalAlign = Align.TOP;
        frozenText.format.color = 0xD8D8D8;
        frozenText.touchable = false;
        frozenText.batchable = true;
        frozenText.visible = false;


        nti = new NativeTextInput(w - 29, _txt, false, 0xC0C0C0);
        nti.align = TextFormatAlign.RIGHT;
        nti.maxChars = _maxChars;
        nti.restrict = "-0-9";
        upArrow.x = w - 24;
        upArrow.y = 1;
        upArrow.addEventListener(TouchEvent.TOUCH, onUp);

        downArrow.scaleY = -1;
        downArrow.x = w - 24;
        downArrow.y = 24;
        downArrow.addEventListener(TouchEvent.TOUCH, onDown);

        addChild(inputBG);
        addChild(frozenText);
        addChild(upArrow);
        addChild(downArrow);
    }

    private function onUp(event:TouchEvent):void {
        var touch:Touch = event.getTouch(upArrow);
        if (touch && touch.phase == TouchPhase.ENDED && isEnabled) {
            var test:int;
            test = (parseInt(nti.input.text) + increment);
            if (_maxValue == -1 || test <= _maxValue) {//eh ?
                frozenText.text = nti.input.text = test.toString();
                this.dispatchEvent(new FormEvent(FormEvent.CHANGE, {value: test}));
            }
        }
    }

    private function onDown(event:TouchEvent):void {
        var touch:Touch = event.getTouch(downArrow);
        if (touch && touch.phase == TouchPhase.ENDED && isEnabled) {
            var test:int;
            test = (parseInt(nti.input.text) - increment);
            if (test >= _minValue) {
                frozenText.text = nti.input.text = test.toString();
                this.dispatchEvent(new FormEvent(FormEvent.CHANGE, {value: test}));
            }
        }
    }

    public function get value():int {
        return parseInt(nti.input.text);
    }

    public function set value(value:int):void {
        frozenText.text = nti.input.text = value.toString();
    }

    public function enable(value:Boolean):void {
        isEnabled = value;
        frozenText.alpha = downArrow.alpha = upArrow.alpha = inputBG.alpha = inputBG.alpha = (value) ? 1 : 0.25;
        nti.enable(value);
        nti.enable(value);
        nti.enable(value);
    }

    private function onAddedToStage(event:starling.events.Event):void {
        updatePosition();
        nti.addEventListener("CHANGE", changeHandler);
        Starling.current.nativeOverlay.addChild(nti);
    }

    public function updatePosition():void {
        try {
            var pos:Point = this.parent.localToGlobal(new Point(this.x, this.y));
            var offsetY:int = 1;
            nti.x = pos.x + 3;
            nti.y = pos.y + offsetY;
        } catch (e:Error) {

        }
    }

    protected function changeHandler(event:flash.events.Event):void {
        var test:int;
        test = parseInt(nti.input.text);
        this.dispatchEvent(new FormEvent(FormEvent.CHANGE, {value: test}));
    }

    public function get maxValue():int {
        return _maxValue;
    }

    public function set maxValue(value:int):void {
        _maxValue = value;
    }

    public function get minValue():int {
        return _minValue;
    }

    public function set minValue(value:int):void {
        _minValue = value;
    }

    public function freeze(value:Boolean = true):void {
        frozenText.visible = value;
        nti.show(!value);
        updatePosition();
    }
}
}