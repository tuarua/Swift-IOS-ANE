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

public class AppCreator extends EventDispatcher {
    private var process:NativeProcess;
    public static const ON_COMPLETE:String = "ON_COMPLETE";
    public static const ON_ERROR:String = "ON_ERROR";
    private static const port:String = "7936";
    private static const storetype:String = "PKCS12";
    private static const platformsdk:String = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform" +
            "/Developer/SDKs/iPhoneOS.sdk";
    private var _target:String = "";
    private var _keystore:String = "";
    private var _storepass:String = "";
    private var _profile:String = "";
    private var _ipa:String = "";
    private var _xml:String = "";
    private var _swf:String = "";
    private var _output:String = "";
    private var _aneFolder:String = "";
    private var _air:String = "";
    private var _fw:String = "";

    public function AppCreator() {
    }

    public function start():void {
        if (!NativeProcess.isSupported) return;
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP PACKAGING] START\n"));
        var shell1File:File = File.applicationDirectory.resolvePath("resign.sh");
        var swfFile:File = new File(_swf);
        var xmlFile:File = new File(_xml);
        var outFolder:File = new File(_output);
        if (shell1File.exists) {
            if (!outFolder.resolvePath(swfFile.name))
                swfFile.copyTo(outFolder.resolvePath(swfFile.name), true);

            if (!outFolder.resolvePath(xmlFile.name))
                xmlFile.copyTo(outFolder.resolvePath(xmlFile.name), true);

            shell1File.copyTo(outFolder.resolvePath("resign.sh"), true);
        } else {
            return;
        }

        var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
        var file:File = File.applicationDirectory.resolvePath(_air + "/bin/adt");
        nativeProcessStartupInfo.workingDirectory = outFolder;
        nativeProcessStartupInfo.executable = file;

        var processArgs:Vector.<String> = new Vector.<String>();
        processArgs.push("-package");
        processArgs.push("-target", _target);


        if (_target == "ipa-debug" || _target == "ipa-debug-interpreter") {
            // processArgs.push("-listen", port); //listen is USB -connect is Network
            processArgs.push("-connect");
        }

        processArgs.push("-storetype", storetype);
        processArgs.push("-keystore", _keystore);
        processArgs.push("-storepass", _storepass);
        processArgs.push("-provisioning-profile", _profile);

        processArgs.push(_output + "/" + _ipa + ".ipa");
        processArgs.push(_xml);
        processArgs.push("-platformsdk", platformsdk);

        processArgs.push("-extdir", _aneFolder);
        processArgs.push("-C", _output, _swf);

        var lastSlash:int = _fw.lastIndexOf("/");
        var fwFolder:String = _fw.substring(0, lastSlash);
        var fwFile:String = _fw.substring(lastSlash + 1, _fw.length);

        processArgs.push("-C", fwFolder, fwFile);
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
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP PACKAGING] " +
                process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)));
    }

    public function onExit(event:NativeProcessExitEvent):void {
        process.closeInput();
        process.exit(true);
        if (event.exitCode == 0) dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP PACKAGING] FINISH\n"));
        dispatchEvent(new Event(event.exitCode == 0 ? ON_COMPLETE : ON_ERROR));
    }

    public function onErrorData(event:ProgressEvent):void {
        dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE, "[APP PACKAGING] " +
                process.standardError.readUTFBytes(process.standardError.bytesAvailable)));
    }

    public function onIOError(event:IOErrorEvent):void {
        trace(event.toString());
    }

    public function set target(value:String):void {
        _target = value;
    }

    public function set keystore(value:String):void {
        _keystore = value;
    }

    public function set storepass(value:String):void {
        _storepass = value;
    }

    public function set profile(value:String):void {
        _profile = value;
    }

    public function set ipa(value:String):void {
        _ipa = value;
    }

    public function set xml(value:String):void {
        _xml = value;
    }

    public function set swf(value:String):void {
        _swf = value;
    }

    public function set output(value:String):void {
        _output = value;
    }

    public function set aneFolder(value:String):void {
        _aneFolder = value;
    }

    public function set air(value:String):void {
        _air = value;
    }

    public function get target():String {
        return _target;
    }

    public function get keystore():String {
        return _keystore;
    }

    public function get storepass():String {
        return _storepass;
    }

    public function get profile():String {
        return _profile;
    }

    public function get ipa():String {
        return _ipa;
    }

    public function get xml():String {
        return _xml;
    }

    public function get swf():String {
        return _swf;
    }

    public function get output():String {
        return _output;
    }

    public function get aneFolder():String {
        return _aneFolder;
    }

    public function get air():String {
        return _air;
    }

    public function get fw():String {
        return _fw;
    }

    public function set fw(value:String):void {
        _fw = value;
    }

    public function isValid():Boolean {
        return (_target && _target.length > 0
                && _keystore && _keystore.length > 0
                && _storepass && _storepass.length > 0
                && _profile && _profile.length > 0
                && _ipa && _ipa.length > 0
                && _xml && _xml.length > 0
                && _swf && _swf.length > 0
                && _output && _output.length > 0
                && _aneFolder && _aneFolder.length > 0
                && _air && _air.length > 0
                && _fw && _fw.length > 0
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
