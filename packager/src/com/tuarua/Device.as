/**
 * Created by User on 24/02/2017.
 */
package com.tuarua {
public class Device {
    private var _handle:int;
    private var _deviceClass:String;
    private var _deviceUUID:String;
    private var _deviceName:String;

    public function Device() {
    }

    public function get handle():int {
        return _handle;
    }

    public function set handle(value:int):void {
        _handle = value;
    }

    public function get deviceClass():String {
        return _deviceClass;
    }

    public function set deviceClass(value:String):void {
        _deviceClass = value;
    }

    public function get deviceUUID():String {
        return _deviceUUID;
    }

    public function set deviceUUID(value:String):void {
        _deviceUUID = value;
    }

    public function get deviceName():String {
        return _deviceName;
    }

    public function set deviceName(value:String):void {
        _deviceName = value;
    }
}
}
