/**
 * Created by User on 08/12/2016.
 */
package com.tuarua {
public class ANEObject extends Object {
    private var _propNames:Array = new Array();
    public function ANEObject() {
    }

    public function getPropNames():Array {
        return _propNames;
    }
    public function addPropName(name:String):void {
       _propNames.push(name);
    }
}
}
