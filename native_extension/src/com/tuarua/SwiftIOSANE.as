/**
 * Created by User on 04/12/2016.
 */
package com.tuarua {
import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.external.ExtensionContext;
import flash.events.StatusEvent;
import flash.utils.ByteArray;

public class SwiftIOSANE extends EventDispatcher {
    private var extensionContext:ExtensionContext;
    private var _inited:Boolean = false;

    public function SwiftIOSANE() {
        initiate();
    }

    private function initiate():void {
        trace("[SwiftIOSANE] Initalizing ANE...");
        try {
            extensionContext = ExtensionContext.createExtensionContext("com.tuarua.SwiftIOSANE", null);
            extensionContext.addEventListener(StatusEvent.STATUS, gotEvent);
        } catch (e:Error) {
            trace("[SwiftIOSANE] ANE Not loaded properly.  Future calls will fail.");
        }
    }

    private function gotEvent(event:StatusEvent):void {
        // trace("got event",event.level)
        switch (event.level) {
            case "TRACE":
                trace(event.code);
                break;
        }
    }

    public function runStringTests(value:String):String {
        return extensionContext.call("runStringTests", value) as String;
    }

    public function runNumberTests(value:Number):Number {
        return extensionContext.call("runNumberTests", value) as Number;
    }

    public function runIntTests(value:int, value2:uint):int {
        return extensionContext.call("runIntTests", value, value2) as int;
    }

    public function runArrayTests(value:Array):Array {
        return extensionContext.call("runArrayTests", value) as Array;
    }

    public function runObjectTests(value:Person):Person {
        return extensionContext.call("runObjectTests", value) as Person;
    }

    public function runBitmapTests(bmd:BitmapData):void {
        extensionContext.call("runBitmapTests", bmd);
    }

    public function runByteArrayTests(byteArray:ByteArray):void {
        extensionContext.call("runByteArrayTests", byteArray);
    }

    public function runDataTests(value:String):String {
        return extensionContext.call("runDataTests", value) as String;
    }

    public function dispose():void {
        if (!extensionContext) {
            trace("[SwiftIOSANE] Error. ANE Already in a disposed or failed state...");
            return;
        }
        trace("[SwiftIOSANE] Unloading ANE...");
        extensionContext.removeEventListener(StatusEvent.STATUS, gotEvent);
        extensionContext.dispose();
        extensionContext = null;
    }
}
}
