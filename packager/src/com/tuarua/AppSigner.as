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

public class AppSigner extends EventDispatcher {
    private var process:NativeProcess;
    public static const ON_COMPLETE:String = "ON_COMPLETE";
    public static const ON_ERROR:String = "ON_ERROR";
    private var _profile:String;
    private var _identity:String;
    private var _ipa:String;
    private var _output:String;
    private var shellFile:File;
    private var ipaFile:File;
    private var outFolder:File
    public function AppSigner() {
    }

    public function start():void {
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP RE-SIGNING] START"));
        outFolder = new File(_output);
        ipaFile = outFolder.resolvePath(_ipa + ".ipa");

        var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
        shellFile = outFolder.resolvePath("resign.sh");
        nativeProcessStartupInfo.workingDirectory = outFolder;
        nativeProcessStartupInfo.executable = shellFile;

        var processArgs:Vector.<String> = new Vector.<String>();
        processArgs.push(ipaFile.nativePath);
        processArgs.push(_profile);
        processArgs.push(_identity);
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
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP RE-SIGNING] " +
                process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)));
    }

    public function onExit(event:NativeProcessExitEvent):void {
        process.closeInput();
        process.exit(true);
        shellFile.deleteFile();
        ipaFile.deleteFile();

        var ipaFileNew:File = outFolder.resolvePath(_ipa + ".resigned.ipa");
        ipaFileNew.moveTo(ipaFile);
        if(event.exitCode == 0) dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP RE-SIGNING] FINISH\n"));
        dispatchEvent(new Event(event.exitCode == 0 ? ON_COMPLETE : ON_ERROR));
    }

    public function onErrorData(event:ProgressEvent):void {
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP RE-SIGNING] " +
                process.standardError.readUTFBytes(process.standardError.bytesAvailable)));
    }

    public function onIOError(event:IOErrorEvent):void {
        trace(event.toString());
    }

    public function get profile():String {
        return _profile;
    }

    public function set profile(value:String):void {
        _profile = value;
    }

    public function get identity():String {
        return _identity;
    }

    public function set identity(value:String):void {
        _identity = value;
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

    public function isValid():Boolean {
        return (_profile && _profile.length > 0
                && _identity && _identity.length > 0
                && _ipa && _ipa.length > 0
                && _output && _output.length > 0
        );
    }

    public function shutDown():void {
        if (process && process.running) {
            process.closeInput();
            process.exit(true);
        }
    }
}
}
