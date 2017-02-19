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

        ane.noReturn(true);

		textField.text = ane.getHelloWorld("Swift and ANE bypass");
        textField.text = textField.text + "\n" + ane.getAge(person);
        textField.text = textField.text + "\n" + ane.getPrice();
        textField.text = textField.text + "\n" + ane.getIsSwiftCool();

        addChild(textField);
    }
}
}


//http://stackoverflow.com/questions/32730312/reason-no-suitable-image-found

//http://stackoverflow.com/questions/33634748/undefined-symbols-for-architecture-in-dynamic-framework

// -undefined dynamic_lookup

//https://forums.adobe.com/message/9128277#9128277

// http://www.manpagez.com/man/1/ld64/

// https://pewpewthespells.com/blog/static_and_dynamic_libraries.html

// nm -arch i386 -g SwiftFW.framework/SwiftFW

// ar -xv airx86.a FlashRuntimeExtensions.o
// ar -xv airx86.a EventDispatcherGlue.o

// ar -xv airx86.a ExtensionContextGlue.o
// ar -xv airx86.a FixedMalloc.o

// ar cr FlashRuntimeExtensions.a FlashRuntimeExtensions.o ExtensionContextGlue.o EventDispatcherGlue.o FixedMalloc.o

// ar cr FlashRuntimeExtensions.a airx86.a extensionglue.o

//FlashRuntimeExtensions.o


// __ZN4MMgc15GCTraceableBase7gcTraceEPNS_2GCEm

// /Users/User/flash/SwiftIOSANE/native_library/ios/SwiftFW/BuildStaticSeparate2.sh