package {

import com.mycompany.HelloWorldANE;

import flash.display.Sprite;
import flash.text.TextField;

public class Main extends Sprite {
    public function Main() {

        var textField:TextField = new TextField();

        var ane:HelloWorldANE = new HelloWorldANE();
        ane.init();
        var returnedString:String = ane.sayHello("Hey hello", true, 5);

        textField.text = returnedString;
        addChild(textField);
    }
}
}
