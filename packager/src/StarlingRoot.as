/**
 * Created by Eoin Landy on 21/02/2017.
 */
package {
import com.tuarua.AppCreator;
import com.tuarua.AppInstaller;
import com.tuarua.AppSigner;
import com.tuarua.Device;
import com.tuarua.DeviceDetector;
import com.tuarua.FDB;
import com.tuarua.FrameworkSigner;
import com.tuarua.Identity;
import com.tuarua.IdentityReader;

import events.FormEvent;
import events.IdentityEvent;
import events.MessageEvent;

import flash.desktop.NativeApplication;

import flash.events.Event;
import flash.filesystem.File;
import flash.net.FileFilter;
import flash.text.TextFieldType;

import model.SettingsLocalStore;

import starling.display.BlendMode;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.utils.Align;

import views.forms.CheckBox;
import views.forms.DropDown;
import views.forms.Input;

public class StarlingRoot extends Sprite {
    private var identityReader:IdentityReader;
    private var frameworkSigner:FrameworkSigner;
    private var appSigner:AppSigner;
    private var appCreator:AppCreator;
    private var appInstaller:AppInstaller;
    private var deviceDetector:DeviceDetector;
    private var fdb:FDB;
    private var targetDrop:DropDown;
    private var fastChk:CheckBox;
    private var showChk:CheckBox;
    private var installChk:CheckBox;
    private var identityDrop:DropDown;
    private var deviceDrop:DropDown;
    private var targetList:Vector.<Object> = new Vector.<Object>;


    private var txtHolder:Sprite = new Sprite();
    private var holder:Sprite = new Sprite();
    private var airLbl:TextField = new TextField(160, 32, "AIR SDK");
    private var identityLbl:TextField = new TextField(160, 32, "Identity");
    private var targetLbl:TextField = new TextField(160, 32, "Target");
    private var fastLbl:TextField = new TextField(160, 32, "Fast packaging");
    private var installLbl:TextField = new TextField(160, 32, "Install");
    private var showLbl:TextField = new TextField(160, 32, "Show password");
    private var keystoreLbl:TextField = new TextField(160, 32, "Keystore (.p12)");
    private var passwordLbl:TextField = new TextField(160, 32, "Password");
    private var profileLbl:TextField = new TextField(160, 32, "Provisioning profile");
    private var xmlLbl:TextField = new TextField(160, 32, "App descriptor");
    private var swfLbl:TextField = new TextField(160, 32, "Main swf");
    private var outputLbl:TextField = new TextField(160, 32, "Output folder");
    private var ipaLbl:TextField = new TextField(160, 32, "Ipa name");
    private var aneLbl:TextField = new TextField(160, 32, "ANE folder");
    private var frameworkLbl:TextField = new TextField(160, 32, "Swift framework");
    private var deviceLbl:TextField = new TextField(160, 32, "Device");
    private var consoleLog:Input = new Input(720, "", 320);

    private var fdbInput:Input;

    private var passwordInput:Input;
    private var keystoreInput:Input;
    private var keystoreChoose:Image = new Image(Assets.getAtlas().getTexture("choose-bg"));
    private var keystoreFile:File = new File();

    private var profileInput:Input;
    private var profileChoose:Image = new Image(Assets.getAtlas().getTexture("choose-bg"));
    private var profileFile:File = new File();

    private var airInput:Input;
    private var airChoose:Image = new Image(Assets.getAtlas().getTexture("choose-bg"));
    private var airFile:File = new File();

    private var xmlInput:Input;
    private var xmlChoose:Image = new Image(Assets.getAtlas().getTexture("choose-bg"));
    private var xmlFile:File = new File();

    private var swfInput:Input;
    private var swfChoose:Image = new Image(Assets.getAtlas().getTexture("choose-bg"));
    private var swfFile:File = new File();

    private var outputInput:Input;
    private var outputChoose:Image = new Image(Assets.getAtlas().getTexture("choose-bg"));
    private var outputFile:File = new File();

    private var ipaInput:Input;

    private var aneInput:Input;
    private var aneChoose:Image = new Image(Assets.getAtlas().getTexture("choose-bg"));
    private var aneFile:File = new File();

    private var fwInput:Input;
    private var fwChoose:Image = new Image(Assets.getAtlas().getTexture("choose-bg"));
    private var fwFile:File = new File();

    private var packageBtn:Sprite;
    private var backBtn:Sprite;
    private var canPackage:Boolean;

    public function StarlingRoot() {
        super();
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(flash.events.Event.EXITING, onExiting);
    }

    public function start():void {

        SettingsLocalStore.load(SettingsLocalStore == null);
        //SettingsLocalStore.load(true);

        appCreator = new AppCreator();
        appCreator.addEventListener(AppCreator.ON_COMPLETE, onAppCreated);
        appCreator.addEventListener(AppCreator.ON_ERROR, onError);
        appCreator.addEventListener(MessageEvent.ON_MESSAGE, onMessage);

        frameworkSigner = new FrameworkSigner();
        frameworkSigner.addEventListener(FrameworkSigner.ON_ERROR, onError);
        frameworkSigner.addEventListener(MessageEvent.ON_MESSAGE, onMessage);
        frameworkSigner.addEventListener(FrameworkSigner.ON_COMPLETE, onFrameworkSignComplete);

        appSigner = new AppSigner();
        appSigner.addEventListener(AppSigner.ON_COMPLETE, onAppSignComplete);
        appSigner.addEventListener(AppSigner.ON_ERROR, onError);
        appSigner.addEventListener(MessageEvent.ON_MESSAGE, onMessage);

        deviceDetector = new DeviceDetector();
        deviceDetector.addEventListener(DeviceDetector.ON_COMPLETE, ondeviceList);

        appInstaller = new AppInstaller();
        appInstaller.addEventListener(AppInstaller.ON_COMPLETE, onAppInstallComplete);
        appInstaller.addEventListener(MessageEvent.ON_MESSAGE, onMessage);
        appInstaller.addEventListener(AppSigner.ON_ERROR, onError);

        fdb = new FDB();
        fdb.addEventListener(MessageEvent.ON_MESSAGE, onMessage);


        appCreator.fw = frameworkSigner.filePath = SettingsLocalStore.getPropAsString("fw");
        appSigner.identity = frameworkSigner.identity = SettingsLocalStore.getPropAsString("identity");
        fdb.air = appInstaller.air = deviceDetector.air = appCreator.air = SettingsLocalStore.getPropAsString("airPath");
        appCreator.aneFolder = SettingsLocalStore.getPropAsString("ane");
        appInstaller.ipa = appSigner.ipa = appCreator.ipa = SettingsLocalStore.getPropAsString("ipa");
        appCreator.keystore = SettingsLocalStore.getPropAsString("keystore");
        appInstaller.output = appSigner.output = appCreator.output = SettingsLocalStore.getPropAsString("output");
        appCreator.swf = SettingsLocalStore.getPropAsString("swf");
        appCreator.xml = SettingsLocalStore.getPropAsString("xml");
        appSigner.profile = appCreator.profile = SettingsLocalStore.getPropAsString("profile");
        appCreator.target = SettingsLocalStore.getPropAsString("target");


        var identityList:Vector.<Object> = new Vector.<Object>;
        identityList.push({value: "", label: "None"});

        identityDrop = new DropDown(400, identityList);
        identityDrop.enable(false);
        identityDrop.addEventListener(FormEvent.CHANGE, onFormChange);
        identityDrop.addEventListener(FormEvent.FOCUS_IN, onDropOpen);
        identityDrop.addEventListener(FormEvent.FOCUS_OUT, onDropClose);

        var deviceList:Vector.<Object> = new Vector.<Object>;
        deviceList.push({value: "-1", label: "None"});
        deviceDrop = new DropDown(250, deviceList);
        deviceDrop.enable(false);
        deviceDrop.addEventListener(FormEvent.CHANGE, onFormChange);


        var tf:TextFormat = new TextFormat();
        tf.setTo("Fira Sans Semi-Bold 13", 13, 0xD8D8D8, Align.LEFT, Align.TOP);

        keystoreFile.addEventListener(Event.SELECT, onKeystoreChosen);
        profileFile.addEventListener(Event.SELECT, onProfileChosen);
        airFile.addEventListener(Event.SELECT, onAirChosen);

        xmlFile.addEventListener(Event.SELECT, onXmlChosen);
        swfFile.addEventListener(Event.SELECT, onSwfChosen);
        outputFile.addEventListener(Event.SELECT, onOutputChosen);

        aneFile.addEventListener(Event.SELECT, onAneChosen);
        fwFile.addEventListener(Event.SELECT, onFrameworkChosen);

        txtHolder.addChild(identityLbl);
        txtHolder.addChild(targetLbl);
        txtHolder.addChild(keystoreLbl);
        txtHolder.addChild(passwordLbl);
        txtHolder.addChild(profileLbl);
        txtHolder.addChild(airLbl);
        txtHolder.addChild(xmlLbl);
        txtHolder.addChild(swfLbl);
        txtHolder.addChild(outputLbl);
        txtHolder.addChild(ipaLbl);
        txtHolder.addChild(aneLbl);
        txtHolder.addChild(frameworkLbl);
        txtHolder.addChild(deviceLbl);

        var itm:TextField;
        for (var i:int = 0; i < txtHolder.numChildren; i++) {
            itm = txtHolder.getChildAt(i) as TextField;
            itm.format = tf;
            itm.batchable = true;
            itm.touchable = false;
            itm.y = i * 32;
        }


        passwordInput = new Input(250, "");
        passwordInput.type = TextFieldType.INPUT;
        passwordInput.addEventListener(FormEvent.FOCUS_OUT, onPasswordSet);
        passwordInput.password = true;
        passwordInput.y = passwordLbl.y;
        passwordInput.freeze(false);
        passwordInput.enable(true);


        keystoreInput = new Input(400, appCreator.keystore);
        keystoreInput.type = TextFieldType.DYNAMIC;
        keystoreInput.enable(true);
        keystoreInput.freeze(true);
        keystoreInput.y = keystoreLbl.y;

        keystoreChoose.x = keystoreInput.x + keystoreInput.width + 8;
        keystoreChoose.y = keystoreInput.y;
        keystoreChoose.useHandCursor = false;
        keystoreChoose.blendMode = BlendMode.NONE;
        keystoreChoose.addEventListener(TouchEvent.TOUCH, onKeystoreTouch);


        profileInput = new Input(400, appCreator.profile);
        profileInput.type = TextFieldType.DYNAMIC;
        profileInput.enable(true);
        profileInput.freeze(true);
        profileInput.y = profileLbl.y;

        profileChoose.x = profileInput.x + profileInput.width + 8;
        profileChoose.y = profileInput.y;
        profileChoose.useHandCursor = false;
        profileChoose.blendMode = BlendMode.NONE;
        profileChoose.addEventListener(TouchEvent.TOUCH, onProfileTouch);

        airInput = new Input(400, appCreator.air);
        airInput.type = TextFieldType.DYNAMIC;
        airInput.enable(true);
        airInput.freeze(true);
        airInput.y = airLbl.y;

        airChoose.x = airInput.x + airInput.width + 8;
        airChoose.y = airInput.y;
        airChoose.useHandCursor = false;
        airChoose.blendMode = BlendMode.NONE;
        airChoose.addEventListener(TouchEvent.TOUCH, onAirTouch);


        xmlInput = new Input(400, appCreator.xml);
        xmlInput.type = TextFieldType.DYNAMIC;
        xmlInput.enable(true);
        xmlInput.freeze(true);
        xmlInput.y = xmlLbl.y;

        xmlChoose.x = xmlInput.x + xmlInput.width + 8;
        xmlChoose.y = xmlInput.y;
        xmlChoose.useHandCursor = false;
        xmlChoose.blendMode = BlendMode.NONE;
        xmlChoose.addEventListener(TouchEvent.TOUCH, onXmlTouch);


        swfInput = new Input(400, appCreator.swf);
        swfInput.type = TextFieldType.DYNAMIC;
        swfInput.enable(true);
        swfInput.freeze(true);
        swfInput.y = swfLbl.y;

        swfChoose.x = swfInput.x + swfInput.width + 8;
        swfChoose.y = swfInput.y;
        swfChoose.useHandCursor = false;
        swfChoose.blendMode = BlendMode.NONE;
        swfChoose.addEventListener(TouchEvent.TOUCH, onSwfTouch);


        outputInput = new Input(400, appCreator.output);
        outputInput.type = TextFieldType.DYNAMIC;
        outputInput.enable(true);
        outputInput.freeze(true);
        outputInput.y = outputLbl.y;

        outputChoose.x = outputInput.x + outputInput.width + 8;
        outputChoose.y = outputInput.y;
        outputChoose.useHandCursor = false;
        outputChoose.blendMode = BlendMode.NONE;
        outputChoose.addEventListener(TouchEvent.TOUCH, onOutputTouch);


        ipaInput = new Input(400, appCreator.ipa);
        ipaInput.addEventListener(FormEvent.FOCUS_OUT, onIpaSet);
        ipaInput.type = TextFieldType.INPUT;
        ipaInput.enable(true);
        ipaInput.freeze(false);
        ipaInput.y = ipaLbl.y;

        consoleLog.type = TextFieldType.DYNAMIC;
        consoleLog.enable(true);
        consoleLog.freeze(true);
        consoleLog.visible = false;
        consoleLog.x = 40;
        consoleLog.y = 40;


        fdbInput = new Input(720, "");
        fdbInput.type = TextFieldType.INPUT;
        fdbInput.addEventListener(FormEvent.ENTER, onFdbEnter);
        //passwordInput.addEventListener(FormEvent.FOCUS_OUT, onPasswordSet);
        fdbInput.y = passwordLbl.y;
        fdbInput.freeze(true);
        fdbInput.enable(true);
        fdbInput.visible = false;

        fdbInput.x = 40;
        fdbInput.y = consoleLog.y + consoleLog.height + 20;


        aneInput = new Input(400, appCreator.aneFolder);
        aneInput.type = TextFieldType.DYNAMIC;
        aneInput.enable(true);
        aneInput.freeze(true);
        aneInput.y = aneLbl.y;

        aneChoose.x = aneInput.x + aneInput.width + 8;
        aneChoose.y = aneInput.y;
        aneChoose.useHandCursor = false;
        aneChoose.blendMode = BlendMode.NONE;
        aneChoose.addEventListener(TouchEvent.TOUCH, onAneTouch);


        fwInput = new Input(400, frameworkSigner.filePath);
        fwInput.type = TextFieldType.DYNAMIC;
        fwInput.enable(true);
        fwInput.freeze(true);
        fwInput.y = frameworkLbl.y;

        fwChoose.x = fwInput.x + fwInput.width + 8;
        fwChoose.y = fwInput.y;
        fwChoose.useHandCursor = false;
        fwChoose.blendMode = BlendMode.NONE;
        fwChoose.addEventListener(TouchEvent.TOUCH, onFwTouch);

        identityReader = new IdentityReader();
        identityReader.addEventListener(IdentityEvent.ON_IDENTITIES, onIdentities);
        identityReader.start();

        targetList.push({value: "ipa-test", label: "Test without debugging"});
        targetList.push({value: "ipa-debug", label: "Debug over network"});
        targetList.push({value: "ipa-app-store", label: "Apple App Store"});
        targetList.push({value: "ipa-ad-hoc", label: "Ad hoc distribution"});

        targetDrop = new DropDown(230, targetList);
        targetDrop.addEventListener(FormEvent.CHANGE, onFormChange);
        targetDrop.addEventListener(FormEvent.FOCUS_IN, onDropOpen);
        targetDrop.addEventListener(FormEvent.FOCUS_OUT, onDropClose);
        var cnt:int = 0;
        for each (var object:Object in targetList) {
            if (object["value"] == appCreator.target) {
                targetDrop.selected = cnt;
                break;
            }
            cnt++;
        }

        targetDrop.y = targetLbl.y;

        deviceDrop.y = deviceLbl.y;

        fastChk = new CheckBox();
        fastChk.addEventListener(FormEvent.CHANGE, onFormChange);
        fastChk.x = 250;
        fastChk.y = targetDrop.y - 12;

        fastLbl.format = tf;
        fastLbl.batchable = true;
        fastLbl.touchable = false;

        fastLbl.x = 440;
        fastLbl.y = targetDrop.y;
        txtHolder.addChild(fastLbl);


        installChk = new CheckBox(true);
        installChk.enable(false);
        installChk.addEventListener(FormEvent.CHANGE, onFormChange);
        installChk.x = 250;
        installChk.y = deviceDrop.y - 12;

        installLbl.format = tf;
        installLbl.batchable = true;
        installLbl.touchable = false;
        installLbl.alpha = 0.25;

        installLbl.x = 440;
        installLbl.y = deviceDrop.y;
        txtHolder.addChild(installLbl);

        showChk = new CheckBox();
        showChk.addEventListener(FormEvent.CHANGE, onFormChange);
        showChk.x = 250;
        showChk.y = passwordInput.y - 12;

        showLbl.format = tf;
        showLbl.batchable = true;
        showLbl.touchable = false;
        showLbl.x = 440;
        showLbl.y = passwordInput.y;

        packageBtn = createButton("Package");
        packageBtn.addEventListener(TouchEvent.TOUCH, onEncodeTouch);
        packageBtn.useHandCursor = true;


        holder.x = 200;
        holder.y = 47;

        packageBtn.x = holder.x + 140;
        packageBtn.y = holder.y + 450;


        backBtn = createButton("Back");
        backBtn.addEventListener(TouchEvent.TOUCH, onBackTouch);
        backBtn.useHandCursor = true;
        backBtn.x = packageBtn.x;
        backBtn.y = packageBtn.y;
        backBtn.visible = false;

        txtHolder.addChild(showLbl);

        txtHolder.x = 50;
        txtHolder.y = 50;


        identityDrop.y = identityLbl.y;


        addChild(consoleLog);
        addChild(fdbInput);

        holder.addChild(passwordInput);
        holder.addChild(keystoreInput);
        holder.addChild(keystoreChoose);

        holder.addChild(profileInput);
        holder.addChild(profileChoose);

        holder.addChild(airInput);
        holder.addChild(airChoose);

        holder.addChild(xmlInput);
        holder.addChild(xmlChoose);

        holder.addChild(swfInput);
        holder.addChild(swfChoose);

        holder.addChild(outputInput);
        holder.addChild(outputChoose);

        holder.addChild(ipaInput);

        holder.addChild(aneInput);
        holder.addChild(aneChoose);

        holder.addChild(fwInput);
        holder.addChild(fwChoose);

        holder.addChild(targetDrop);
        holder.addChild(fastChk);
        holder.addChild(showChk);

        holder.addChild(identityDrop);
        holder.addChild(deviceDrop);
        holder.addChild(installChk);

        addChild(packageBtn);
        addChild(backBtn);


        addChild(txtHolder);
        addChild(holder);

        consoleLog.visible = false;

        if (deviceDetector.air)
            deviceDetector.start();

        validate();
    }

    private function onFdbEnter(event:FormEvent):void {
        fdb.sendCommand(fdbInput.text);
        fdbInput.text = "";
    }

    private function onMessage(event:MessageEvent):void {
        //trace(event.params);
        consoleLog.appendText(event.params.toString());
        consoleLog.scrollV = consoleLog.numLines;
        //consoleLog.text += ;
    }

    private static function createButton(lbl:String):Sprite {
        var spr:Sprite = new Sprite();
        var bg:Quad = new Quad(80, 36, 0xFFFFFF);
        var tf:TextFormat = new TextFormat();
        tf.setTo("Fira Sans Semi-Bold 13", 13, 0x333333, Align.CENTER, Align.TOP);

        var txt:TextField = new TextField(80, 32, lbl);
        txt.format = tf;
        txt.y = 10;

        spr.addChild(bg);
        spr.addChild(txt);
        return spr;
    }

    private function onPasswordSet(event:FormEvent):void {
        appCreator.storepass = passwordInput.text;
        validate();
    }

    private function onIpaSet(event:FormEvent):void {
        appInstaller.ipa = appSigner.ipa = appCreator.ipa = ipaInput.text;
        SettingsLocalStore.setProp("ipa", ipaInput.text);
        validate();
    }

    private function onDropClose(event:FormEvent):void {
        passwordInput.freeze(false);
    }

    private function onDropOpen(event:FormEvent):void {
        passwordInput.freeze(true);
    }


    private function onEncodeTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(packageBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED && canPackage) {
            passwordInput.freeze(true);
            ipaInput.freeze(true);
            holder.visible = false;
            txtHolder.visible = false;
            packageBtn.visible = false;

            consoleLog.visible = true;
            consoleLog.freeze(false);
            frameworkSigner.start();
        }
    }

    private function onBackTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(backBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED && canPackage) {
            passwordInput.freeze(false);
            ipaInput.freeze(false);
            holder.visible = true;
            txtHolder.visible = true;
            backBtn.visible = false;
            packageBtn.visible = true;
            consoleLog.freeze(true);
            consoleLog.visible = false;

            fdbInput.freeze(true);
            fdbInput.visible = false;

            fdb.shutDown();

        }
    }

    private function onAirTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(airChoose, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED)
            airFile.browseForDirectory("Select AIR SDK");
    }

    private function onXmlTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(xmlChoose, TouchPhase.ENDED);
        var txtFilter:FileFilter = new FileFilter("Text", "*.xml");
        if (touch && touch.phase == TouchPhase.ENDED)
            xmlFile.browseForOpen("Select xml file...", [txtFilter]);
    }

    private function onSwfTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(swfChoose, TouchPhase.ENDED);
        var txtFilter:FileFilter = new FileFilter("Text", "*.swf");
        if (touch && touch.phase == TouchPhase.ENDED)
            swfFile.browseForOpen("Select swf file...", [txtFilter]);
    }

    private function onAneTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(aneChoose, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED)
            aneFile.browseForDirectory("Select ANE folder");
    }

    private function onFwTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(fwChoose, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED)
            fwFile.browseForDirectory("Select Framework");
    }

    private function onOutputTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(outputChoose, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED)
            outputFile.browseForDirectory("Select Output folder");
    }

    private function onProfileTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(profileChoose, TouchPhase.ENDED);
        var txtFilter:FileFilter = new FileFilter("Text", "*.mobileprovision");
        if (touch && touch.phase == TouchPhase.ENDED)
            profileFile.browseForOpen("Select mobileprovision file...", [txtFilter]);
    }

    private function onKeystoreTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(keystoreChoose, TouchPhase.ENDED);
        var txtFilter:FileFilter = new FileFilter("Text", "*.p12");
        if (touch && touch.phase == TouchPhase.ENDED)
            keystoreFile.browseForOpen("Select p12 file...", [txtFilter]);
    }

    protected function onXmlChosen(event:Event):void {
        xmlInput.text = xmlFile.nativePath;
        appCreator.xml = xmlFile.nativePath;
        SettingsLocalStore.setProp("xml", xmlFile.nativePath);
        validate();
    }

    protected function onSwfChosen(event:Event):void {
        swfInput.text = swfFile.nativePath;
        appCreator.swf = swfFile.nativePath;
        SettingsLocalStore.setProp("swf", swfFile.nativePath);
        validate();
    }

    protected function onFrameworkChosen(event:Event):void {
        fwInput.text = fwFile.nativePath;
        appCreator.fw = frameworkSigner.filePath = fwFile.nativePath;
        SettingsLocalStore.setProp("fw", fwFile.nativePath);
        validate();
    }

    protected function onAneChosen(event:Event):void {
        aneInput.text = aneFile.nativePath;
        appCreator.aneFolder = aneFile.nativePath;
        SettingsLocalStore.setProp("ane", aneFile.nativePath);
        validate();
    }

    protected function onOutputChosen(event:Event):void {
        outputInput.text = outputFile.nativePath;
        appInstaller.output = appSigner.output = appCreator.output = outputFile.nativePath;
        SettingsLocalStore.setProp("output", outputFile.nativePath);
        validate();
    }

    protected function onKeystoreChosen(event:Event):void {
        keystoreInput.text = keystoreFile.nativePath;
        appCreator.keystore = keystoreFile.nativePath;
        SettingsLocalStore.setProp("keystore", keystoreFile.nativePath);
        validate();
    }

    protected function onProfileChosen(event:Event):void {
        profileInput.text = profileFile.nativePath;
        appSigner.profile = appCreator.profile = profileFile.nativePath;
        SettingsLocalStore.setProp("profile", profileFile.nativePath);
        validate();
    }

    protected function onAirChosen(event:Event):void {
        airInput.text = airFile.nativePath;
        fdb.air = appInstaller.air = deviceDetector.air = appCreator.air = airFile.nativePath;
        SettingsLocalStore.setProp("airPath", airFile.nativePath);
        deviceDetector.start();
        validate();
    }

    private function onFormChange(event:FormEvent):void {
        switch (event.currentTarget) {
            case targetDrop:
            case fastChk:
                var fullValue:String = targetDrop.value;
                if (fullValue == "ipa-app-store" || fullValue == "ipa-ad-hoc") {
                    fastChk.enable(false);
                    fastLbl.alpha = 0.25;
                } else {
                    fastChk.enable(true);
                    fastLbl.alpha = 1;
                    if (fastChk.selected)
                        fullValue = fullValue + "-interpreter";
                }
                appCreator.target = fullValue;
                SettingsLocalStore.setProp("target", fullValue);
                break;
            case installChk:
                appInstaller.shouldRun = installChk.selected;
                deviceDrop.enable(installChk.selected);
                break;
            case identityDrop:
                appSigner.identity = frameworkSigner.identity = identityDrop.value;
                SettingsLocalStore.setProp("identity", identityDrop.value);
                break;
            case showChk:
                passwordInput.password = !showChk.selected;
                break;
            case deviceDrop:
                appInstaller.deviceHandle = parseInt(deviceDrop.value);
                break;
        }
        validate();
    }

    private function validate():void {
        canPackage = appSigner.isValid() && appCreator.isValid() && frameworkSigner.isValid();
        packageBtn.alpha = canPackage ? 1.0 : 0.25;
    }

    private function onFrameworkSignComplete(event:Event):void {
        appCreator.start();
    }

    private function onAppCreated(event:Event):void {
        appSigner.start();
    }

    private function onError(event:Event):void {
        backBtn.visible = true;
        trace("ERROR");
    }


    private function onAppInstallComplete(event:Event):void {
        if (targetDrop.value == "ipa-debug") {
            fdbInput.freeze(false);
            fdbInput.visible = true;
            fdbInput.setFocus();
            if (fdb.air) {
                fdb.start();
            }
        }

        backBtn.visible = true;
    }


    private function onAppSignComplete(event:Event):void {
        if (installChk.selected && parseInt(deviceDrop.value) > -1)
            appInstaller.start();
        else
            backBtn.visible = true;
    }

    private function ondeviceList(event:Event):void {
        var deviceList:Vector.<Object> = new Vector.<Object>;
        for each (var device:Device in deviceDetector.devices) {
            deviceList.push({value: device.handle, label: device.deviceName});
        }
        if (deviceList.length > 0) {
            deviceDrop.update(deviceList);
            deviceDrop.enable(installChk.selected);
        }
        appInstaller.deviceHandle = parseInt(deviceDrop.value);
        deviceDrop.selected = 0;
        installChk.enable(true);
        installLbl.alpha = 1;
    }

    private function onExiting(event:Event):void {
        fdb.shutDown();
        identityReader.shutDown();
        frameworkSigner.shutDown();
        appSigner.shutDown();
        appCreator.shutDown();
        appInstaller.shutDown();
        deviceDetector.shutDown();

    }

    private function onIdentities(event:IdentityEvent):void {
        var identityList:Vector.<Object> = new Vector.<Object>;
        for each (var identity:Identity in identityReader.identities) {
            identityList.push({value: identity.guid, label: identity.name});
        }
        identityDrop.update(identityList);
        var cnt:int = 0;
        for each (var object:Object in identityList) {
            if (object["value"] == frameworkSigner.identity) {
                identityDrop.selected = cnt;
                break;
            }
            cnt++;
        }

        identityDrop.enable(true);
    }

}
}
