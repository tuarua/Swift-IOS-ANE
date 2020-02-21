package com.mycompany {
import com.tuarua.fre.ANEError;
import flash.events.EventDispatcher;
public class HelloWorldANE extends EventDispatcher {
    private static var _shared:HelloWorldANE;

    public function HelloWorldANE() {
        if (HelloWorldANEContext.context) {
            var ret:* = HelloWorldANEContext.context.call("init");
            if (ret is ANEError) throw ret as ANEError;
        }
        _shared = this;
    }

    public static function shared():HelloWorldANE {
        if (!_shared) {
            new HelloWorldANE();
        }
        return _shared;
    }

    public function sayHello(myString:String, uppercase:Boolean, numRepeats:int):String {
        HelloWorldANEContext.validate();
        var ret:* = HelloWorldANEContext.context.call("sayHello", myString, uppercase, numRepeats);
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

    public static function dispose():void {
        if (HelloWorldANEContext.context) {
            HelloWorldANEContext.dispose();
        }
    }

}
}