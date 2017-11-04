/*
 * Copyright Tua Rua Ltd. (c) 2017.
 */

package com.tuarua.fre {
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class ANEUtils {
    public function ANEUtils() {
    }

    public static function getClass(obj:Object):Class {
        return Class(getDefinitionByName(getQualifiedClassName(obj)));
    }

    public function getClass(obj:Object):Class {
        return Class(getDefinitionByName(getQualifiedClassName(obj)));
    }

    public static function getClassProps(clz:*):Vector.<Object> {
        var ret:Vector.<Object> = new <Object>[];
        var xml:XML = describeType(clz);
        if (xml.variable && xml.variable.length() > 0) {
            for each (var prop:XML in xml.variable) {
                var obj:Object = {};
                obj.name = prop.@name.toString();
                obj.type = prop.@type.toString();
                obj.cls = obj.type == "*" ? null : getClass(Class(getDefinitionByName(obj.type)));
                ret.push(obj);
                //trace(obj.name, obj.type);
            }
        } else if (xml.factory && xml.factory.variable && xml.factory.variable.length() > 0) {
            for each (var propb:XML in xml.factory.variable) {
                var objb:Object = {};
                objb.name = propb.@name.toString();
                objb.type = propb.@type.toString();
                objb.cls = objb.type == "*" ? null : getClass(Class(getDefinitionByName(objb.type)));
                ret.push(objb);
                //trace(objb.name, objb.type);
            }
        } else {
            for (var id:String in clz) {
                var objc:Object = {};
                objc.name = id;
                if (clz.hasOwnProperty(id)) {
                    objc.type = getClassType(clz[id]);
                    objc.cls = objc.type == "*" ? null : getClass(Class(getDefinitionByName(objc.type)));
                    //objc.cls = getClass(Class(getDefinitionByName(objc.type)));
                    //trace(objc.name, objc.type);
                    ret.push(objc);
                }

            }
        }
        return ret;
    }

    public function getClassProps(clz:*):Vector.<Object> {
        var ret:Vector.<Object> = new <Object>[];
        var xml:XML = describeType(clz);
        if (xml.variable && xml.variable.length() > 0) {
            for each (var prop:XML in xml.variable) {
                var obj:Object = {};
                obj.name = prop.@name.toString();
                obj.type = prop.@type.toString();
                obj.cls = obj.type == "*" ? null : getClass(Class(getDefinitionByName(obj.type)));
                ret.push(obj);
                //trace(obj.name, obj.type);
            }
        } else if (xml.factory && xml.factory.variable && xml.factory.variable.length() > 0) {
            for each (var propb:XML in xml.factory.variable) {
                var objb:Object = {};
                objb.name = propb.@name.toString();
                objb.type = propb.@type.toString();
                objb.cls = objb.type == "*" ? null : getClass(Class(getDefinitionByName(objb.type)));
                ret.push(objb);
                //trace(objb.name, objb.type);
            }
        } else {
            for (var id:String in clz) {
                var objc:Object = {};
                objc.name = id;
                if (clz.hasOwnProperty(id)) {
                    objc.type = getClassType(clz[id]);
                    objc.cls = objc.type == "*" ? null : getClass(Class(getDefinitionByName(objc.type)));
                    //objc.cls = getClass(Class(getDefinitionByName(objc.type)));
                    //trace(objc.name, objc.type);
                    ret.push(objc);
                }

            }
        }
        return ret;
    }

    private static function getPropClass(name:String, cls:Class):Class {
        var clsProps:Vector.<Object> = getClassProps(cls);
        for each (var clsa:Object in clsProps) {
            if (clsa.name == name) {
                return clsa.cls;
            }
        }
        return null;
    }

    public static function map(from:Object, to:Class):Object {
        var classInstance:Object;
        classInstance = new to();
        for (var id:String in from) {
            var name:String = id;
            var propCls:Class = getPropClass(name, to);

            switch (propCls) {
                case String:
                case int:
                case Number:
                case Boolean:
                case Array:
                case Vector.<String>:
                case Vector.<int>:
                case Vector.<Number>:
                case Vector.<Boolean>:
                    classInstance[name] = from[name];
                    break;
                case Date:
                    classInstance[name] = new Date(Date.parse(from[name]));
                    break;
                default: //Object or Class
                    //trace("we want to convert " + name + " into", propCls);
                    classInstance[name] = (propCls == null) ? from[name] : map(from[name], getPropClass(name, to));
                    break;
            }

        }
        return classInstance;
    }

    public static function getClassType(clz:*):String {
        var xml:XML = describeType(clz);
        return xml.@name;
    }

    public function getClassType(clz:*):String {
        var xml:XML = describeType(clz);
        return xml.@name;
    }

}
}
