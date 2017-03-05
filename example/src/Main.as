package {

import com.tuarua.Person;
import com.tuarua.SwiftIOSANE;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Main extends Sprite {
    private var ane:SwiftIOSANE = new SwiftIOSANE();

    public function Main() {
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
        
        addChild(textField);
    }
}
}