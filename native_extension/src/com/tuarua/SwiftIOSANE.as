/**
 * Created by User on 04/12/2016.
 */
package com.tuarua {
import com.tuarua.fre.ANEError;

import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.external.ExtensionContext;
import flash.events.StatusEvent;
import flash.utils.ByteArray;

public class SwiftIOSANE extends EventDispatcher {
    private static const name:String = "SwiftIOSANE";
    private var _inited:Boolean = false;
    private var ctx:ExtensionContext;

    public function SwiftIOSANE() {
        initiate();
    }

    private function initiate():void {
        trace("[" + name + "] Initalizing ANE...");
        try {
            ctx = ExtensionContext.createExtensionContext("com.tuarua." + name, null);
            ctx.addEventListener(StatusEvent.STATUS, gotEvent);
        } catch (e:Error) {
            trace("[" + name + "] ANE Not loaded properly.  Future calls will fail.");
        }
    }

    private function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case "TRACE":
                trace("[" + name + "]", event.code);
                break;
        }
    }

    public function runStringTests(value:String):String {
        return ctx.call("runStringTests", value) as String;
    }

    public function runNumberTests(value:Number):Number {
        return ctx.call("runNumberTests", value) as Number;
    }

    public function runIntTests(value:int, value2:uint):int {
        return ctx.call("runIntTests", value, value2) as int;
    }

    public function runArrayTests(value:Array):Array {
        return ctx.call("runArrayTests", value) as Array;
    }

    public function runObjectTests(value:Person):Person {
        return ctx.call("runObjectTests", value) as Person;
    }

    public function runBitmapTests(bmd:BitmapData):void {
        ctx.call("runBitmapTests", bmd);
    }

    public function runByteArrayTests(byteArray:ByteArray):void {
        ctx.call("runByteArrayTests", byteArray);
    }

    public function runDataTests(value:String):String {
        return ctx.call("runDataTests", value) as String;
    }

    public function runErrorTests(value:Person):void {
        var theRet:* = ctx.call("runErrorTests", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function runErrorTests2(string:String):void {
        ctx.call("runErrorTests2", string);
    }

    public function dispose():void {
        if (!ctx) {
            trace("[" + name + "] Error. ANE Already in a disposed or failed state...");
            return;
        }
        trace("[" + name + "] Unloading ANE...");
        ctx.removeEventListener(StatusEvent.STATUS, gotEvent);
        ctx.dispose();
        ctx = null;
    }
}
}
