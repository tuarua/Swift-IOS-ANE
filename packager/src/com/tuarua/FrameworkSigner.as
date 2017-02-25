/**
 * Created by User on 20/02/2017.
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

public class FrameworkSigner extends EventDispatcher {
    private var process:NativeProcess;
    public static const ON_COMPLETE:String = "ON_COMPLETE";
    public static const ON_ERROR:String = "ON_ERROR";
    private var _filePath:String;
    private var _identity:String;

    public function FrameworkSigner() {
    }

    public function start():void {
        if (!NativeProcess.isSupported) return;
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[FRAMEWORK SIGNING] START\n"));
        var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
        var file:File = File.applicationDirectory.resolvePath("signfw.sh");
        nativeProcessStartupInfo.workingDirectory = File.applicationDirectory;
        nativeProcessStartupInfo.executable = file;

        var processArgs:Vector.<String> = new Vector.<String>();
        processArgs.push(_identity);
        processArgs.push(_filePath);
        nativeProcessStartupInfo.arguments = processArgs;

        process = new NativeProcess();
        process.start(nativeProcessStartupInfo);
        process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
        process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
        process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
        process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
        process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
    }

    public function onOutputData(event:ProgressEvent):void {
        dispatchEvent(new Event(ON_COMPLETE));
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[FRAMEWORK SIGNING] " +
                process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)));
    }

    public function onExit(event:NativeProcessExitEvent):void {
        process.closeInput();
        process.exit(true);
        if(event.exitCode == 0) dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[FRAMEWORK SIGNING] FINISH\n"));
        dispatchEvent(new Event(event.exitCode == 0 ? ON_COMPLETE : ON_ERROR));
    }

    public function onErrorData(event:ProgressEvent):void {
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[FRAMEWORK SIGNING] " +
                process.standardError.readUTFBytes(process.standardError.bytesAvailable)));
    }

    public function onIOError(event:IOErrorEvent):void {
        trace(event.toString());
    }

    public function set filePath(value:String):void {
        _filePath = value;
    }

    public function set identity(value:String):void {
        _identity = value;
    }

    public function get filePath():String {
        return _filePath;
    }

    public function get identity():String {
        return _identity;
    }

    public function isValid():Boolean {
        return (_filePath && _filePath.length > 0
        && _identity && _identity.length > 0);
    }

    public function shutDown():void {
        if (process && process.running) {
            process.closeInput();
            process.exit(true);
        }
    }
}
}
