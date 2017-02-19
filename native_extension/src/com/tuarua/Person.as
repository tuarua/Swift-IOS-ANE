/**
 * Created by User on 08/12/2016.
 */
package com.tuarua {
[RemoteClass(alias="com.tuarua.Person")]
public class Person extends ANEObject {
    public var name:String;
    public var age:int;
    public var opt:String;
    public function Person() {
        super();
        super.addPropName("name");
        super.addPropName("age");
        super.addPropName("opt");
    }

}
}
