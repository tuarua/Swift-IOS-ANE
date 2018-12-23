/*
 *  Copyright 2017 Tua Rua Ltd.
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
 */

package com.tuarua {
[RemoteClass(alias="com.tuarua.Person")]
public class Person {
    public var name:String = ""; //must init with empty string otherwise comes through as FRE_TYPE_NULL
    public var age:int;
    public var opt:String;
    public var isMan:Boolean = false;
    public var height:Number = 1.80;
    public var city:City = new City();

    public function Person() {
        super();
    }

    public function add(x:int, y:int):int {
        return x + y;
    }
}
}
