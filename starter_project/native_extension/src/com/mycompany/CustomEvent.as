package com.mycompany {
import flash.events.Event;

public class CustomEvent extends Event {
    public var params:*;
    public function CustomEvent(type:String, params:* = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.params = params;
    }
    public override function clone():Event {
        return new CustomEvent(type, this.params, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("CustomEvent", "params", "type", "bubbles", "cancelable");
    }
}
}
