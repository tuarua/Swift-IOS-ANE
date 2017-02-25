/**
 * Created by User on 25/02/2017.
 */
package com.tuarua {
import events.MessageEvent;

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;

public class FDB extends EventDispatcher {
    private var process:NativeProcess;
    private var _air:String;
    private var isInited:Boolean = false;

    public function FDB() {
    }

    public function start():void {
        if (_air) {
            dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "LAUNCH APP ON DEVICE\n"));
            dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[FDB] STARTED\n"));
            var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            var file:File = File.applicationDirectory.resolvePath(_air + "/bin/fdb");
            nativeProcessStartupInfo.workingDirectory = File.applicationDirectory;
            nativeProcessStartupInfo.executable = file;

            var processArgs:Vector.<String> = new Vector.<String>();
            //processArgs.push("-p", "7936");

            nativeProcessStartupInfo.arguments = processArgs;

            process = new NativeProcess();
            process.start(nativeProcessStartupInfo);
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
            process.addEventListener(ProgressEvent.STANDARD_INPUT_PROGRESS, onStdInputProgress);
            process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
            process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
        } else {
            trace("missing");
            trace("_air", _air);
        }
    }

    private function onStdInputProgress(event:ProgressEvent):void {
        //trace(event);
    }

    public function onOutputData(event:ProgressEvent):void {
        var s:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
        if ((s.charCodeAt(s.length - 1) == 32 || s.charCodeAt(s.length - 1) == 10) && !isInited) {
            isInited = true;
            sendCommand("r");
            dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[FDB]\n1. Open app on device\n2. " +
                    "Set any breakpoints\n3.Type c to continue.\n4.Type h for help\n"));
        }
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, s));
    }

    public function sendCommand(command:String):void {
        process.standardInput.writeUTF(command + String.fromCharCode(13));
    }

    public function shutDown():void {
        if (process && process.running) {
            process.closeInput();
            process.exit(true);
        }
    }

    public function onExit(event:NativeProcessExitEvent):void {
        if (process.running) {
            process.closeInput();
            process.exit(true);
        }
        //trace("[FDB] exit ", event.exitCode);
    }

    public function onErrorData(event:ProgressEvent):void {
        //trace("[FDB] error", process.standardError.readUTFBytes(process.standardError.bytesAvailable));

        // dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP INSTALLER] " +
        //      process.standardError.readUTFBytes(process.standardError.bytesAvailable)));
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
}
}
