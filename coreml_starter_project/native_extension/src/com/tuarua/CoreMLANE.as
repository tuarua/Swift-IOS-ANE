package com.tuarua {
import com.tuarua.fre.ANEError;

import flash.display.BitmapData;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

public class CoreMLANE extends EventDispatcher {
    private static const NAME:String = "CoreMLANE";
    private var ctx:ExtensionContext;
    private static const TRACE:String = "TRACE";

    public function CoreMLANE() {
        trace("[" + NAME + "] Initalizing ANE...");
        try {
            ctx = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
            ctx.addEventListener(StatusEvent.STATUS, gotEvent);
        } catch (e:Error) {
            trace(e.name);
            trace(e.message);
            trace(e.getStackTrace());
            trace(e.errorID);
            trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
        }
    }

    private function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case "CUSTOM_EVENT":
                dispatchEvent(new CustomEvent(event.level, event.code));
                break;
        }
    }

    public function init():void {
        var theRet:* = ctx.call("init");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function imageMatch(bmd:BitmapData):void {
        ctx.call("imageMatch", bmd);
    }


    public function dispose():void {
        if (!ctx) {
            trace("[" + NAME + "] Error. ANE Already in a disposed or failed state...");
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        ctx.removeEventListener(StatusEvent.STATUS, gotEvent);
        ctx.dispose();
        ctx = null;
    }

}
}
