/*
 *  Copyright 2017 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package com.tuarua {
import com.tuarua.fre.ANEError;

import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

public class FreSwiftExampleANE extends EventDispatcher {
    private static var _example:FreSwiftExampleANE;

    public function FreSwiftExampleANE() {
        if (FreSwiftExampleANEContext.context) {
            var theRet:* = FreSwiftExampleANEContext.context.call("init");
            if (theRet is ANEError) throw theRet as ANEError;
        }
        _example = this;
    }

    public static function get example():FreSwiftExampleANE {
        if (!_example) {
            new FreSwiftExampleANE();
        }
        return _example;
    }

    public function runStringTests(value:String):String {
        FreSwiftExampleANEContext.validate();
        return FreSwiftExampleANEContext.context.call("runStringTests", value) as String;
    }

    public function runNumberTests(value:Number):Number {
        FreSwiftExampleANEContext.validate();
        return FreSwiftExampleANEContext.context.call("runNumberTests", value) as Number;
    }

    public function runIntTests(value:int, value2:uint):int {
        FreSwiftExampleANEContext.validate();
        return FreSwiftExampleANEContext.context.call("runIntTests", value, value2) as int;
    }

    public function runArrayTests(value:Array):Array {
        FreSwiftExampleANEContext.validate();
        return FreSwiftExampleANEContext.context.call("runArrayTests", value) as Array;
    }

    public function runObjectTests(value:Person):Person {
        FreSwiftExampleANEContext.validate();
        return FreSwiftExampleANEContext.context.call("runObjectTests", value) as Person;
    }

    public function runBitmapTests(bmd:BitmapData):void {
        FreSwiftExampleANEContext.validate();
        FreSwiftExampleANEContext.context.call("runBitmapTests", bmd);
    }

    public function runExtensibleTests(point:Point, rect:Rectangle):Point {
        FreSwiftExampleANEContext.validate();
        return FreSwiftExampleANEContext.context.call("runExtensibleTests", point, rect) as Point;
    }

    public function runByteArrayTests(byteArray:ByteArray):void {
        FreSwiftExampleANEContext.validate();
        FreSwiftExampleANEContext.context.call("runByteArrayTests", byteArray);
    }

    public function runDataTests(value:String):String {
        FreSwiftExampleANEContext.validate();
        return FreSwiftExampleANEContext.context.call("runDataTests", value) as String;
    }

    public function runDateTests(value:Date):Date {
        FreSwiftExampleANEContext.validate();
        return FreSwiftExampleANEContext.context.call("runDateTests", value) as Date;
    }

    public function runColorTests(value:uint, value2:uint):uint {
        FreSwiftExampleANEContext.validate();
        return FreSwiftExampleANEContext.context.call("runColorTests", value, value2) as uint;
    }

    public function runErrorTests(value:Person):void {
        FreSwiftExampleANEContext.validate();
        var theRet:* = FreSwiftExampleANEContext.context.call("runErrorTests", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public static function dispose():void {
        if (FreSwiftExampleANEContext.context) {
            FreSwiftExampleANEContext.dispose();
        }
    }

}
}
