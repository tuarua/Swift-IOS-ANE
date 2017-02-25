package views.forms {
import flash.geom.Point;
import flash.geom.Rectangle;

import events.FormEvent;

import starling.display.BlendMode;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.ColorMatrixFilter;
import starling.display.MeshBatch;

public class Slider extends Sprite {
    private var bg:Image = new Image(Assets.getAtlas().getTexture("slider-bg"));
    private var handle:Image = new Image(Assets.getAtlas().getTexture("slider-handle"));
    private var notchHolder:MeshBatch = new MeshBatch();
    private var _w:int;
    private var _numNotches:int;
    private var volumeScrubBeganX:Number;
    private var _notchGap:int;
    private var prevX:int = 0;
    private var _values:Array = new Array();
    private var isEnabled:Boolean = true;
    private var _selected:int = 0;
    private var _start:int = 0;
    private var _end:int = 0;
    private var fltr:ColorMatrixFilter;

    public function Slider(notchGap:int, start:int, end:int, selected:int = 0) {
        super();

        _notchGap = notchGap;
        _start = start;
        _end = end;
        _selected = selected;

        if (_end > _start) {
            _numNotches = (_end - _start) + 1;
            for (var j:int = _start, l2:int = _end + 1; j < l2; ++j)
                values.push(j);
        } else {
            _numNotches = (start - end) + 1;
            for (var k:int = _start, l3:int = _end - 1; k > l3; --k)
                values.push(k);
        }

        bg.scale9Grid = new Rectangle(4, 0, 12, 0);


        _w = ((_numNotches - 1) * _notchGap) + 10;

        bg.blendMode = BlendMode.NONE;
        bg.addEventListener(TouchEvent.TOUCH, onBgClick);
        handle.pivotX = 5;//half the width
        fltr = new ColorMatrixFilter();
        fltr.tint(0x000000, 0.4);
        handle.y = -5;

        draw();

        notchHolder.y = 18;

        handle.addEventListener(TouchEvent.TOUCH, onTouch);

        addChild(bg);
        addChild(handle);
        addChild(notchHolder);
    }

    private function draw():void {
        bg.width = _w;

        handle.x = (values[selected] * _notchGap) + 5;

        notchHolder.clear();
        var divider:Quad = new Quad(1, 10, 0x202020);
        for (var i:int = 0, l:int = _numNotches; i < l; ++i) {
            divider.x = (i * _notchGap) + 5;
            notchHolder.addMesh(divider);
        }
    }

    public function update(notchGap:int, start:int, end:int, selected:int = 0):void {
        _notchGap = notchGap;
        _start = start;
        _end = end;
        _selected = selected;

        if (_end > _start) {
            _numNotches = (_end - _start) + 1;
            for (var j:int = _start, l2:int = _end + 1; j < l2; ++j)
                values.push(j);
        } else {
            _numNotches = (start - end) + 1;
            for (var k:int = _start, l3:int = _end - 1; k > l3; --k)
                values.push(k);
        }

        _w = ((_numNotches - 1) * _notchGap) + 10;

        draw();
    }

    protected function onBgClick(evt:TouchEvent):void {
        var touch:Touch = evt.getTouch(bg);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            prevX = handle.x;
            var x:int = globalToLocal(new Point(touch.globalX - (0), 0)).x;
            if (x < 0)
                x = 0;
            if (x > (_w - 10))
                x = _w - 10;
            handle.x = ((Math.round(x / _notchGap)) * _notchGap) + 5;
            if (handle.x != prevX) {
                _selected = Math.round(x / _notchGap);
                this.dispatchEvent(new FormEvent(FormEvent.CHANGE, {value: values[_selected]}));
            }
        }
    }

    protected function onTouch(evt:TouchEvent):void {
        var touch:Touch = evt.getTouch(handle);
        if (isEnabled) {
            if (touch != null && touch.phase == TouchPhase.BEGAN) {
                volumeScrubBeganX = globalToLocal(new Point(0, touch.globalX)).x - handle.x + 5;
            } else if (touch != null && touch.phase == TouchPhase.ENDED) {
                volumeScrubBeganX = -1;
            } else if (touch && touch.phase == TouchPhase.MOVED) {
                prevX = handle.x;
                var x:int = globalToLocal(new Point(touch.globalX, touch.globalX - (volumeScrubBeganX))).x;
                if (x < 0)
                    x = 0;
                if (x > (_w - 10))
                    x = _w - 10;
                handle.x = ((Math.round(x / _notchGap)) * _notchGap) + 5;
                if (handle.x != prevX) {
                    _selected = Math.round(x / _notchGap);
                    this.dispatchEvent(new FormEvent(FormEvent.CHANGE, {value: values[_selected]}));
                }
            }
        }
    }

    public function enable(value:Boolean):void {
        isEnabled = value;
        if (isEnabled) {
            bg.alpha = 1;
            notchHolder.alpha = 1;
            handle.alpha = 1;
            handle.filter = null;
        } else {
            bg.alpha = 0.25;
            notchHolder.alpha = 0.75;
            handle.filter = fltr;
        }
    }

    public function get selected():int {
        return _selected;
    }

    public function get values():Array {
        return _values;
    }


}
}