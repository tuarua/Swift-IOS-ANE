/**
 * Created by User on 08/12/2016.
 */
package com.tuarua {
[RemoteClass(alias="com.tuarua.Person")]
public class Person {
    public var name:String = ""; //must init with empty string otherwise comes through as FRE_TYPE_NULL
    public var age:int;
    public var opt:String;
    public var isMan:Boolean = false;
    public var height:Number = 1.80;
    public var city:City = new City();

    public function Person() {
        super();
    }

    public function add(x:int, y:int):int {
        return x + y;
    }
}
}
