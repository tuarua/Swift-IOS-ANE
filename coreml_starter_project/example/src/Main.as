package {

import com.tuarua.CoreMLANE;
import com.tuarua.CustomEvent;

import flash.desktop.NativeApplication;
import flash.display.Bitmap;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Main extends Sprite {

    private var ane:CoreMLANE = new CoreMLANE();

    [Embed(source="dog.jpg")]
    public static const TestImage:Class;
    private var textField:TextField = new TextField();
    public function Main() {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);


        var tf:TextFormat = new TextFormat();
        tf.size = 32;
        tf.color = 0x333333;
        tf.align = TextFormatAlign.LEFT;
        textField.defaultTextFormat = tf;
        textField.width = 800;
        textField.height = 800;
        textField.multiline = true;
        textField.wordWrap = true;

        textField.x = 20;
        textField.x = 20;

        textField.text = "Placeholder Text";


        var testImage:Bitmap = new TestImage() as Bitmap;
        testImage.x = 0;
        testImage.y = 100;
        addChild(testImage);
        addChild(textField);


        ane.init();
        ane.addEventListener("CUSTOM_EVENT", onCustomEvent);
        ane.imageMatch(testImage.bitmapData);

    }

    private function onCustomEvent(event:CustomEvent):void {
        trace(event.params);
        textField.text = event.params;
    }

    private function onExiting(event:Event):void {
        ane.dispose();
    }
}
}
