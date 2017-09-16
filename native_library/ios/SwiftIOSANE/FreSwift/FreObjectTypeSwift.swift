/* Copyright 2017 Tua Rua Ltd.
 
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

public enum FreObjectTypeSwift: UInt32 {
    case object = 0
    case number = 1
    case string = 2
    case bytearray = 3
    case array = 4
    case vector = 5
    case bitmapdata = 6
    case boolean = 7
    case null = 8
    case int = 9
    case cls = 10 //aka class
    case rectangle = 11
    case point = 12
    case date = 13
}
