/*
 * Copyright 2017 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

package com.tuarua {
import flash.events.EventDispatcher;
import flash.external.ExtensionContext;
import flash.system.Capabilities;

public class FreSwift extends EventDispatcher {
    private static const NAME:String = "FreSwift";
    private static var ctx:ExtensionContext;

    public function FreSwift() {
        if (Capabilities.os.toLowerCase().indexOf("mac os") == -1) return;
        trace("[" + NAME + "] Initalizing ANE...");
        try {
            ctx = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
            ctx.call("initFreSwift");
        } catch (e:Error) {
            trace(e.message);
            trace(e.getStackTrace());
            trace(e.errorID);
            trace(e.name);
            trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
        }
    }

    public static function dispose():void {
        if (Capabilities.os.toLowerCase().indexOf("mac os") == -1) return;
        if (!ctx) {
            trace("[" + NAME + "] Error. ANE Already in a disposed or failed state...");
            return;
        }

        trace("[" + NAME + "] Unloading ANE...");
        ctx.dispose();
        ctx = null;
    }
}
}
