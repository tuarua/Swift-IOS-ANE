/**
 * Created by User on 20/02/2017.
 */
package com.tuarua {
import events.IdentityEvent;

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;

public class IdentityReader extends EventDispatcher {
    private var process:NativeProcess;
    private var identitiesString:String = "";
    private var _identities:Vector.<Identity> = new <Identity>[];
    public function IdentityReader() {

    }
    public function start():void {
        if(!NativeProcess.isSupported) return;
        var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
        var file:File = File.applicationDirectory.resolvePath("get-keychain.sh");
        nativeProcessStartupInfo.workingDirectory = File.applicationDirectory;
        nativeProcessStartupInfo.executable = file;
        process = new NativeProcess();
        process.start(nativeProcessStartupInfo);
        process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
        process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
        process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
        process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
        process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
    }
    public function onOutputData(event:ProgressEvent):void {
        identitiesString += process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
        //trace(process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable));
    }

    public function onErrorData(event:ProgressEvent):void {
        trace("ERROR -", process.standardError.readUTFBytes(process.standardError.bytesAvailable));
    }

    public function onExit(event:NativeProcessExitEvent):void {
        var tmpArray:Array = identitiesString.split("\n");
        for each (var item:String in tmpArray) {
            var identity:Identity = new Identity();
            if (item.indexOf(")") == -1) continue;

            //to get GUID
            var arr1:Array = item.split(" ");
            identity.guid = arr1[3];
            identity.name = item.substring(item.indexOf('"')+1,item.lastIndexOf('"'));
            _identities.push(identity);
        }
        this.dispatchEvent(new IdentityEvent(IdentityEvent.ON_IDENTITIES));
        process.closeInput();
        process.exit(true);
    }

    public function onIOError(event:IOErrorEvent):void {
        trace(event.toString());
    }

    public function get identities():Vector.<Identity> {
        return _identities;
    }

    public function shutDown():void {
        if (process && process.running) {
            process.closeInput();
            process.exit(true);
        }
    }
}
}
