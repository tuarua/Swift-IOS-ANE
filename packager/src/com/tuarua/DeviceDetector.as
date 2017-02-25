/**
 * Created by User on 24/02/2017.
 */
package com.tuarua {
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;

public class DeviceDetector extends EventDispatcher {
    private var process:NativeProcess;
    public static const ON_COMPLETE:String = "ON_COMPLETE";
    public static const ON_ERROR:String = "ON_ERROR";
    public var devices:Vector.<Device> = new <Device>[];
    private var _air:String;

    public function DeviceDetector() {
    }

    public function start():void {
        if(_air){
            var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            var file:File = File.applicationDirectory.resolvePath(_air + "/bin/adt");
            nativeProcessStartupInfo.workingDirectory = File.applicationDirectory;
            nativeProcessStartupInfo.executable = file;

            var processArgs:Vector.<String> = new Vector.<String>();
            processArgs.push("-devices");
            processArgs.push("-platform", "iOS");

            nativeProcessStartupInfo.arguments = processArgs;

            process = new NativeProcess();
            process.start(nativeProcessStartupInfo);
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
            process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
            process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
        }
    }

    public function onOutputData(event:ProgressEvent):void {
        var tmp:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
        var tmpArray:Array = tmp.split("\n");
        for each (var item:String in tmpArray) {
            var arr1:Array = item.split(String.fromCharCode(9));
            if (arr1.length < 4 || isNaN(parseInt(arr1[0]))) continue;
            var device:Device = new Device();
            device.handle = parseInt(trim(arr1[0]));
            device.deviceClass = trim(arr1[1]);
            device.deviceUUID = trim(arr1[2]);
            device.deviceName = trim(arr1[3]);
            devices.push(device);
        }
    }

    private function trim(string:String):String {
        var rex:RegExp = new RegExp(/^s*|\s*$/gim);
        return string.replace(rex, "");
    }

    public function onExit(event:NativeProcessExitEvent):void {
        process.closeInput();
        process.exit(true);
        dispatchEvent(new Event(event.exitCode == 0 ? ON_COMPLETE : ON_ERROR));
    }

    public function onErrorData(event:ProgressEvent):void {
    }

    public function onIOError(event:IOErrorEvent):void {
        trace(event.toString());
    }

    public function get air():String {
        return _air;
    }

    public function set air(value:String):void {
        _air = value;
    }

    public function shutDown():void {
        if (process && process.running) {
            process.closeInput();
            process.exit(true);
        }
    }
}
}
