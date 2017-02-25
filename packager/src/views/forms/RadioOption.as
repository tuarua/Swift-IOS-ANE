package views.forms {
import events.FormEvent;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class RadioOption extends Sprite {
    private var onTxture:Texture = Assets.getAtlas().getTexture("radio-selected");
    private var offTxture:Texture = Assets.getAtlas().getTexture("radio");
    private var img:Image = new Image(offTxture);
    private var _id:int;
    private var isEnabled:Boolean;

    public function RadioOption(id:int) {
        super();
        _id = id;
        img.addEventListener(TouchEvent.TOUCH, onTouch);
        addChild(img);
    }

    protected function onTouch(event:TouchEvent):void {
        var touch:Touch = event.getTouch(img, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED && isEnabled) {
            img.texture = onTxture;
            this.dispatchEvent(new FormEvent(FormEvent.CHANGE, {value: _id}));
        }
    }

    public function toggle(value:Boolean):void {
        img.texture = value ? onTxture : offTxture;
    }

    public function enable(value:Boolean):void {
        isEnabled = value;
        this.alpha = value ? 1.0 : 0.25;
    }
}
}