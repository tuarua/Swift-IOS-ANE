package com.mycompany {
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

public class HelloWorldANEContext {
    private static var _isInited:Boolean = false;
    private static var _context:ExtensionContext;
    internal static const NAME:String = "HelloWorldANE";
    internal static const TRACE:String = "TRACE";
    internal static const INIT_ERROR_MESSAGE:String = NAME + " not initialised... use .helloWorld";
    public function HelloWorldANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.mycompany." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isInited = true;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
            }
        }
        return _context;
    }

    private static function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case "TRACE":
                trace("[" + NAME + "]", event.code);
                break;
            case "MY_EVENT":
                HelloWorldANE.helloWorld.dispatchEvent(new CustomEvent("MY_EVENT", event.code));
                break;
        }
    }

    public static function validate():void {
        if (!_isInited) throw new Error(INIT_ERROR_MESSAGE);
    }

    public static function dispose():void {
        if (!_context) {
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
        _isInited = false;
    }

}
}
