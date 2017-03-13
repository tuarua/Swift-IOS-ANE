package {

import com.tuarua.Person;
import com.tuarua.SwiftIOSANE;

import flash.display.Bitmap;

import flash.display.Loader;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.ByteArray;

public class Main extends Sprite {
    private var ane:SwiftIOSANE = new SwiftIOSANE();

    public function Main() {
        super();
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        var textField:TextField = new TextField();
        var tf:TextFormat = new TextFormat();
        tf.size = 32;
        tf.color = 0x333333;
        tf.align = TextFormatAlign.LEFT;
        textField.defaultTextFormat = tf;
        textField.width = 800;
        textField.height = 800;
        textField.multiline = true;
        textField.wordWrap = true;

        var person:Person = new Person();
        person.age = 21;
        person.name = "Tom";

        var myArray:Array = new Array();
        myArray.push(3, 1, 4, 2, 6, 5);

        var resultString:String = ane.runStringTests("I am a string from AIR");
        textField.text += resultString + "\n";

        var resultNumber:Number = ane.runNumberTests(31.99);
        textField.text += "Number: " + resultNumber + "\n";

        var resultInt:int = ane.runIntTests(-54, 66);
        textField.text += "Int: " + resultInt + "\n";
        var resultArray:Array = ane.runArrayTests(myArray);
        textField.text += "Array: " + resultArray.toString() + "\n";

        var resultObject:Person = ane.runObjectTests(person) as Person;
        textField.text += "Person.age: " + resultObject.age.toString() + "\n";

        const IMAGE_URL:String = "http://tinyurl.com/zaky3n4";

        var ldr:Loader = new Loader();
        ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, ldr_complete);
        ldr.load(new URLRequest(IMAGE_URL));

        var bitmap1:Bitmap;

        function ldr_complete(evt:Event):void {
            var bmp:Bitmap = ldr.content as Bitmap;
            ane.runBitmapTests(bmp.bitmapData);
        }


        var myByteArray:ByteArray = new ByteArray();
        myByteArray.writeUTFBytes("Swift in an ANE. Say whaaaat!");
        ane.runByteArrayTests(myByteArray);


        ane.runErrorTests(person, "test string", 78);

        var inData:String = "Saved and returned";
        var outData:String = ane.runDataTests(inData) as String;
        textField.text += outData + "\n";

        addChild(textField);
    }
}
}