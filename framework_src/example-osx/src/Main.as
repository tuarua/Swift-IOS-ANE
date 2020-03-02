package {

import com.tuarua.FreSwift;
import com.tuarua.FreSwiftExampleANE;
import com.tuarua.Person;
import com.tuarua.fre.ANEError;

import flash.desktop.NativeApplication;
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.ByteArray;

[SWF(width="640", height="640", frameRate="60", backgroundColor="#F1F1F1")]
public class Main extends Sprite {
    private var freSwift:FreSwift = new FreSwift();
    private var ane:FreSwiftExampleANE;
    private static const GREEN:uint = 0xFF00FF00;
    private static const HALF_GREEN:uint = 0x8000FF00;
    private var hasActivated:Boolean;
    public function Main() {
        super();
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        this.addEventListener(Event.ACTIVATE, onActivated);

    }

    protected function onActivated(event:Event):void {
        if (hasActivated) return;
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);

        ane = FreSwiftExampleANE.shared();
        var textField:TextField = new TextField();
        var tf:TextFormat = new TextFormat();
        tf.size = 24;
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
        person.city.name = "Boston";

        var myArray:Array = [];
        myArray.push(3, 1, 4, 2, 6, 5);

        var resultString:String = ane.runStringTests("Björk Guðmundsdóttir Sinéad O’Connor 久保田  " +
                "利伸 Михаил Горбачёв Садриддин Айнӣ Tor Åge Bringsværd 章子怡 €");
        textField.text += resultString + "\n";

        var resultNumber:Number = ane.runNumberTests(31.99);
        textField.text += "Number: " + resultNumber + "\n";

        var resultInt:int = ane.runIntTests(-54, 66);
        textField.text += "Int: " + resultInt + "\n";

        trace("HALF_GREEN", HALF_GREEN, HALF_GREEN == ane.runColorTests(GREEN, HALF_GREEN) ? "✅" : "❌");

        var resultArray:Vector.<int> = ane.runArrayTests(myArray);
        if(resultArray){
            textField.text += "Array: " + resultArray.toString() + "\n";
        }

        var resultObject:Person = ane.runObjectTests(person) as Person;
        textField.text += "Person.age: " + resultObject.age.toString() + "\n";

        const IMAGE_URL:String = "https://www.wired.com/wp-content/uploads/2014/07/Apple_Swift_Logo.png";

        var ldr:Loader = new Loader();
        ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, ldr_complete);
        ldr.load(new URLRequest(IMAGE_URL));

        function ldr_complete(evt:Event):void {
            var bmp:Bitmap = ldr.content as Bitmap;
            bmp.y = 150;
            addChild(bmp);
            ane.runBitmapTests(bmp.bitmapData); //pass in bitmap data and apply filter
        }

        ane.runExtensibleTests(new Point(1, 55.5), new Rectangle(9.1, 0.5, 20, 50));

        var myByteArray:ByteArray = new ByteArray();
        myByteArray.writeUTFBytes("Swift in an ANE. Say whaaaat!");
        ane.runByteArrayTests(myByteArray);

        try {
            ane.runErrorTests(person);
        } catch (e:ANEError) {
            trace("Error captured in AS");
            trace("e.message:", e.message);
            trace("e.errorID:", e.errorID);
            trace("e.type:", e.type);
            trace("e.source:", e.source);
            trace("e.getStackTrace():", e.getStackTrace());
        }

        var testDate:Date = new Date(1990, 5, 13, 8, 59, 3);
        trace("Date returned is same", testDate.time == ane.runDateTests(testDate).time ? "✅" : "❌");

        var inData:String = "Saved and returned";
        var outData:String = ane.runDataTests(inData) as String;
        textField.text += outData + "\n";

        addChild(textField);
    }

    private function onExiting(event:Event):void {
        FreSwiftExampleANE.dispose();
        FreSwift.dispose();
    }
}
}