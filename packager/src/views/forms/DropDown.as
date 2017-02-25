package views.forms {
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import events.FormEvent;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.BlendMode;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.textures.Texture;
import starling.utils.Align;

import views.SrollableContent;

public class DropDown extends Sprite {
    private var _id:String;
    private var _w:int;
    private var h:int;
    private var _selected:int = 0;
    private var _items:Vector.<Object>;
    private var bg:Image;
    private var listBg:Image;
    private var listBgTexture:Texture;
    private var pane:Sprite = new Sprite();
    private var hover:Quad;
    private var txt:TextField;
    private var listOuterContainer:Sprite = new Sprite();
    private var tween:Tween;
    private var tween2:Tween;
    private var isEnabled:Boolean = true;
    private var _maxHeight:int = 200;
    private var paneHeight:int;
    private var textFormat:TextFormat;
    private var scrollable:SrollableContent;

    public function DropDown(w:int, items:Vector.<Object>) {
        super();
        this._w = w;
        this._items = items;
        textFormat = new TextFormat();
        textFormat.setTo("Fira Sans Semi-Bold 13", 13);
        textFormat.horizontalAlign = Align.LEFT;
        textFormat.verticalAlign = Align.CENTER;
        textFormat.color = 0xD8D8D8;
        doRender();
    }

    private function doRender():void {
        paneHeight = h = (_items.length * 20) + 5;
        if (paneHeight > _maxHeight)
            paneHeight = _maxHeight;

        bg = new Image(Assets.getAtlas().getTexture("dropdown-bg"));
        bg.scale9Grid = new Rectangle(4, 0, 23, 25);
        bg.width = _w;
        bg.blendMode = BlendMode.NONE;

        hover = new Quad(_w - 6, 20, 0xCC8D1E);
        hover.alpha = 0.4;

        txt = new TextField(_w, 26, _items[_selected].label);
        txt.format = textFormat;

        txt.x = 8;
        txt.batchable = true;
        txt.touchable = false;

        bg.addEventListener(TouchEvent.TOUCH, onTouch);

        listBg = new Image(Assets.getAtlas().getTexture("dropdown-items-bg"));
        listBg.scale9Grid = new Rectangle(4, 4, 41, 17);
        listBg.blendMode = BlendMode.NONE;
        listBg.width = _w;
        listBg.height = paneHeight;
        listBg.y = 25 - paneHeight;

        pane.y = 0;

        listOuterContainer.mask = new Quad(_w, h);
        listOuterContainer.mask.y = 25;

        var k:int = pane.numChildren;
        while (k--) {
            pane.getChildAt(k).dispose();
            pane.removeChildAt(k);
        }

        hover.x = 3;
        hover.y = (_selected * 20) + 2;
        pane.addChild(hover);

        var itmLbl:TextField;
        for (var i:int = 0, l:int = _items.length; i < l; ++i) {
            itmLbl = new TextField(_w, 26, _items[i].label);
            itmLbl.format = textFormat;
            itmLbl.x = 8;
            itmLbl.y = (i * 20) + 0;
            pane.addChild(itmLbl);
        }

        pane.addEventListener(TouchEvent.TOUCH, onListTouch);

        scrollable = new SrollableContent(_w, _maxHeight, pane);
        scrollable.y = 25 - paneHeight;

        scrollable.fullHeight = h;
        scrollable.init();

        listOuterContainer.addChild(listBg);
        listOuterContainer.addChild(scrollable);

        listOuterContainer.visible = false;
        addChild(listOuterContainer);
        addChild(bg);
        addChild(txt);
    }

    protected function onTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(bg, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED && isEnabled)
            open();
    }

    private function open():void {
        Starling.juggler.removeTweens(scrollable);
        tween = new Tween(scrollable, 0.15, Transitions.EASE_OUT);
        tween.animate("y", 25);

        Starling.juggler.removeTweens(listBg);
        tween2 = new Tween(listBg, 0.15, Transitions.EASE_OUT);
        tween2.animate("y", 25);

        listOuterContainer.visible = true;
        Starling.juggler.add(tween);
        Starling.juggler.add(tween2);
        Starling.current.nativeStage.addEventListener(MouseEvent.CLICK, onClick);
        Starling.current.nativeStage.addEventListener(MouseEvent.RIGHT_CLICK, onClick);
        this.dispatchEvent(new FormEvent(FormEvent.FOCUS_IN, null));
    }

    private function onClick(event:MouseEvent):void {
        var clickPoint:Point = this.globalToLocal(new Point(event.stageX, event.stageY));
        if (clickPoint.x > this.bounds.width || clickPoint.y > paneHeight || clickPoint.y < 0 || clickPoint.x < 0) {
            Starling.current.nativeStage.removeEventListener(MouseEvent.CLICK, onClick);
            close();
        }
    }

    private function close():void {
        Starling.juggler.removeTweens(scrollable);
        tween = new Tween(scrollable, 0.15, Transitions.EASE_IN);
        tween.animate("y", 25 - paneHeight);

        Starling.juggler.removeTweens(listBg);
        tween2 = new Tween(listBg, 0.15, Transitions.EASE_IN);
        tween2.animate("y", 25 - paneHeight);

        Starling.juggler.add(tween);
        Starling.juggler.add(tween2);

        tween.onComplete = function ():void {
            listOuterContainer.visible = false;
            hover.y = (_selected * 20) + 2;
        }
        this.dispatchEvent(new FormEvent(FormEvent.FOCUS_OUT, null));
    }

    public function enable(value:Boolean):void {
        isEnabled = value;
        this.alpha = (value) ? 1 : 0.25;
    }

    protected function onListTouch(event:TouchEvent):void {
        var hoverTouch:Touch = event.getTouch(pane, TouchPhase.HOVER);
        var clickTouch:Touch = event.getTouch(pane, TouchPhase.ENDED);
        if (hoverTouch && isEnabled) {
            var p:Point;
            p = hoverTouch.getLocation(pane, p);
            var proposedHover:int = Math.floor((p.y) / 20);
            if (proposedHover > -1 && proposedHover < _items.length && tween.isComplete)
                hover.y = (proposedHover * 20) + 2;
        } else if (clickTouch && isEnabled) {
            var pClick:Point;
            pClick = clickTouch.getLocation(pane, pClick);
            var proposedSelected:int = Math.floor((pClick.y) / 20);
            if (proposedSelected > -1 && proposedSelected < _items.length) {
                _selected = proposedSelected;
                txt.text = _items[_selected].label;
                this.dispatchEvent(new FormEvent(FormEvent.CHANGE, {value: _items[_selected].value}, false));
                Starling.current.nativeStage.removeEventListener(MouseEvent.CLICK, onClick);
                close();
            }
        }
    }

    public function get selected():int {
        return _selected;
    }

    public function set selected(value:int):void {
        if (value > -1) {
            _selected = value;
            txt.text = _items[_selected].label;
            hover.y = (_selected * 20) + 2;
        }
    }

    public function get value():String {
        return _items[_selected].value;
    }

    public function update(items:Vector.<Object>):void {
        _items = items;
        var k:int = this.numChildren;
        while (k--) {
            this.getChildAt(k).dispose();
            this.removeChildAt(k);
        }
        doRender();
    }

    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

    public function get maxHeight():int {
        return _maxHeight;
    }

    public function set maxHeight(value:int):void {
        _maxHeight = value;
    }

}
}