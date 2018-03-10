package {

import com.mycompany.CustomEvent;
import com.mycompany.HelloWorldANE;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.text.TextField;
import com.tuarua.CommonDependencies;

public class Main extends Sprite {
    private var commonDependenciesANE:CommonDependencies = new CommonDependencies();
    private var ane:HelloWorldANE;
    private var hasActivated:Boolean;
    public function Main() {
        super();
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        this.addEventListener(Event.ACTIVATE, onActivated);
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);

    }

    private function onActivated(event:Event):void {
        if (!hasActivated) {
            var textField:TextField = new TextField();

            ane = new HelloWorldANE();
            ane.init();
            ane.addEventListener("MY_EVENT", onEvent);


            var returnedString:String = ane.sayHello("Hey hello", true, 5);

            textField.text = returnedString;

            addChild(textField);

        }
        hasActivated = true;
    }

    private function onEvent(event:CustomEvent):void {
        trace(event);
    }

    private function onExiting(event:Event):void {
        ane.dispose();
        commonDependenciesANE.dispose();
    }
}
}
