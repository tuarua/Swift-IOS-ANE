package {

import com.tuarua.AppCreator;
import com.tuarua.AppSigner;
import com.tuarua.FrameworkSigner;
import com.tuarua.Identity;
import com.tuarua.IdentityReader;

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.text.TextField;
import flash.geom.Rectangle;

import starling.core.Starling;
import starling.events.Event;

[SWF(width = "800", height = "600", frameRate = "60", backgroundColor = "#121314")]
public class Main extends Sprite {

    public var mStarling:Starling;
    public function Main() {

        super();

        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        Starling.multitouchEnabled = false;
        var viewPort:Rectangle = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
        mStarling = new Starling(StarlingRoot, stage, viewPort,null,"auto","auto");
        mStarling.stage.stageWidth = stage.stageWidth;  // <- same size on all devices!
        mStarling.stage.stageHeight = stage.stageHeight;
        mStarling.simulateMultitouch = false;
        //mStarling.showStatsAt("right","bottom");
        mStarling.enableErrorChecking = false;
        mStarling.antiAliasing = 16;
        mStarling.skipUnchangedFrames = true;

        mStarling.addEventListener(starling.events.Event.ROOT_CREATED,
                function onRootCreated(event:Object, app:StarlingRoot):void {
                    mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
                    app.start();
                    mStarling.start();
                });
    }

}
}
