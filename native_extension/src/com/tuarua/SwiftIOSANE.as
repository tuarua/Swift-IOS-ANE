/**
 * Created by User on 04/12/2016.
 */
package com.tuarua {
import flash.events.EventDispatcher;
import flash.external.ExtensionContext;
import flash.events.StatusEvent;
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
        trace("got event",event.level)
        switch (event.level) {
            case "TRACE":
                trace(event.code);
                break;
        }
    }

    public function getHelloWorld(value:String):String {
        return extensionContext.call("getHelloWorld",value) as String;
    }

    public function getAge(person:Person):int {
        return int(extensionContext.call("getAge", person));
    }

    public function getPrice():Number {
        return Number(extensionContext.call("getPrice"));
    }

    public function getIsSwiftCool():Boolean {
        return extensionContext.call("getIsSwiftCool");
    }

    public function noReturn(value:Boolean):void {
        extensionContext.call("noReturn");
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
