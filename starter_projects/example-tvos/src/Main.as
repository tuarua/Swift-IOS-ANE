package {

import com.mycompany.CustomEvent;
import com.mycompany.HelloWorldANE;

import flash.desktop.NativeApplication;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

public class Main extends Sprite {
    private var ane:HelloWorldANE;

    public function Main() {
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
        var textField:TextField = new TextField();

        ane = new HelloWorldANE();
        ane.init();
        ane.addEventListener("MY_EVENT", onEvent);
        var returnedString:String = ane.sayHello("Hey hello", true, 5);

        textField.text = returnedString;
        addChild(textField);
    }

    private function onEvent(event:CustomEvent):void {
        trace(event);
    }

    private function onExiting(event:Event):void {
        ane.dispose();
    }
}
}
