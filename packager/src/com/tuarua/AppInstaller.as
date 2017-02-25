/**
 * Created by User on 24/02/2017.
 */
package com.tuarua {
import events.MessageEvent;

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;

public class AppInstaller extends EventDispatcher {
    private var process:NativeProcess;
    public static const ON_COMPLETE:String = "ON_COMPLETE";
    public static const ON_ERROR:String = "ON_ERROR";
    private static const platformsdk:String = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform" +
            "/Developer/SDKs/iPhoneOS.sdk";
    private var _ipa:String = "";
    private var _output:String = "";
    private var _deviceHandle:int;
    private var _air:String;
    private var _shouldRun:Boolean = true;
    public function AppInstaller() {
    }

    public function start():void {
        if(_air && _deviceHandle && _output){
            dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP INSTALLER] START\n"));
            var outFolder:File = new File(_output);
            var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            var file:File = File.applicationDirectory.resolvePath(_air + "/bin/adt");
            nativeProcessStartupInfo.workingDirectory = outFolder;
            nativeProcessStartupInfo.executable = file;

            var processArgs:Vector.<String> = new Vector.<String>();
            //adt -installApp -platform platformName -platformsdk path-to-sdk -device deviceID ‑package fileName
            processArgs.push("-installApp");
            processArgs.push("-platform", "ios");
            processArgs.push("-platformsdk", platformsdk);
            processArgs.push("-device", _deviceHandle);
            processArgs.push("-package", _output + "/" + _ipa + ".ipa");

            nativeProcessStartupInfo.arguments = processArgs;

            process = new NativeProcess();
            process.start(nativeProcessStartupInfo);
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
            process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
            process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
        } else {
            trace("missing");
            trace("_air", _air);
            trace("_output", _output);
            trace("_deviceHandle", _deviceHandle);
        }
    }
    public function onOutputData(event:ProgressEvent):void {
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP INSTALLER] "
                + process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)));

    }

    public function onExit(event:NativeProcessExitEvent):void {
        process.closeInput();
        process.exit(true);
       // trace("APP INSTALLER: event.exitCode: ",event.exitCode);
        if (event.exitCode == 0) dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP INSTALLER] FINISH\n"));
        dispatchEvent(new Event(event.exitCode == 0 ? ON_COMPLETE : ON_ERROR));
    }

    public function onErrorData(event:ProgressEvent):void {
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP INSTALLER] " +
                process.standardError.readUTFBytes(process.standardError.bytesAvailable)));
    }

    public function onIOError(event:IOErrorEvent):void {
        trace(event.toString());
    }

    public function get deviceHandle():int {
        return _deviceHandle;
    }

    public function set deviceHandle(value:int):void {
        _deviceHandle = value;
    }

    public function get ipa():String {
        return _ipa;
    }

    public function set ipa(value:String):void {
        _ipa = value;
    }

    public function get output():String {
        return _output;
    }

    public function set output(value:String):void {
        _output = value;
    }

    public function get air():String {
        return _air;
    }

    public function set air(value:String):void {
        _air = value;
    }

    public function get shouldRun():Boolean {
        return _shouldRun;
    }

    public function set shouldRun(value:Boolean):void {
        _shouldRun = value;
    }

    public function shutDown():void {
        if (process && process.running) {
            process.closeInput();
            process.exit(true);
        }
    }
}
}
