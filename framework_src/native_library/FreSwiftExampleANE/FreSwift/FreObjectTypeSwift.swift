/* Copyright 2018 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.*/

import Foundation
/// FreObjectTypeSwift: Provides Swift mappings for FREObjectType.   
/// Adds additional AS3 types (cls, rectangle, point, date)
public enum FreObjectTypeSwift: UInt32 {
    /// Object
    case object = 0
    /// Number
    case number = 1
    /// String
    case string = 2
    /// ByteArray
    case bytearray = 3
    /// Array
    case array = 4
    /// Vector
    case vector = 5
    /// Bitmapdata
    case bitmapdata = 6
    /// Boolean
    case boolean = 7
    /// NULL
    case null = 8
    /// int
    case int = 9
    /// Class
    case cls = 10 //aka class
    /// flash.geom.Rectangle
    case rectangle = 11
    /// flash.geom.Point
    case point = 12
    /// Date
    case date = 13
}
