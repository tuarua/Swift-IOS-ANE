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

public class FreBitmapDataSwift: NSObject {
    private typealias FREBitmapData = FREBitmapData2

    public var rawValue: FREObject? = nil
    private var _bitmapData: FREBitmapData = FREBitmapData.init()
    public var width: Int = 0
    public var height: Int = 0
    public var hasAlpha: Bool = false
    public var isPremultiplied: Bool = false
    public var isInvertedY: Bool = false
    public var lineStride32: UInt = 0
    public var bits32: UnsafeMutablePointer<UInt32>!

    public init(freObject: FREObject) {
        rawValue = freObject
    }

    public init(cgImage: CGImage) {
        super.init()
        do {
            if let freObject = try FREObject.init(className: "flash.display.BitmapData",
                                                 args: UInt32(cgImage.width),UInt32(cgImage.height),false,0) {
                rawValue = freObject
                try acquire()
                try setPixels(cgImage: cgImage)
                releaseData()
            }
        } catch {
            releaseData()
        }
    }

    public func acquire() throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
              line: #line, column: #column, file: #file)
        }
#if os(iOS)
        let status: FREResult = FreSwiftBridge.bridge.FREAcquireBitmapData2(object: rv, descriptorToSet: &_bitmapData)
#else
        let status: FREResult = FREAcquireBitmapData2(rv, &_bitmapData)
#endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot acquire BitmapData", type: FreSwiftHelper.getErrorCode(status),
              line: #line, column: #column, file: #file)
        }
        width = Int(_bitmapData.width)
        height = Int(_bitmapData.height)
        hasAlpha = _bitmapData.hasAlpha == 1
        isPremultiplied = _bitmapData.isPremultiplied == 1
        isInvertedY = _bitmapData.isInvertedY == 1
        lineStride32 = UInt(_bitmapData.lineStride32)
        bits32 = _bitmapData.bits32
    }

    public func releaseData() {
        guard let rv = rawValue else {
            return
        }
#if os(iOS)
        _ = FreSwiftBridge.bridge.FREReleaseBitmapData(object: rv)
#else
        FREReleaseBitmapData(rv)
#endif
    }

    public func setPixels(cgImage: CGImage) throws {
        if let dp = cgImage.dataProvider {
            if let data: NSData = dp.data {
                memcpy(bits32, data.bytes, data.length);
            }
            try invalidateRect(x: 0, y: 0, width: UInt(cgImage.width), height: UInt(cgImage.height))
        }
    }

    public func getAsImage() throws -> CGImage? {
        try self.acquire()

        let releaseProvider: CGDataProviderReleaseDataCallback = { (info: UnsafeMutableRawPointer?,
                                                                    data: UnsafeRawPointer, size: Int) -> () in
            // https://developer.apple.com/reference/coregraphics/cgdataproviderreleasedatacallback
            // N.B. 'CGDataProviderRelease' is unavailable: Core Foundation objects are automatically memory managed
            return
        }
        let provider: CGDataProvider = CGDataProvider(dataInfo: nil, data: bits32, size: (width * height * 4),
          releaseData: releaseProvider)!


        let bytesPerPixel = 4;
        let bitsPerPixel = 32;
        let bytesPerRow: Int = bytesPerPixel * Int(lineStride32);
        let bitsPerComponent = 8;
        let colorSpaceRef: CGColorSpace = CGColorSpaceCreateDeviceRGB()

        var bitmapInfo: CGBitmapInfo

        if hasAlpha {
            if isPremultiplied {
                bitmapInfo = CGBitmapInfo.init(rawValue: CGBitmapInfo.byteOrder32Little.rawValue |
                  CGImageAlphaInfo.premultipliedFirst.rawValue)
            } else {
                bitmapInfo = CGBitmapInfo.init(rawValue: CGBitmapInfo.byteOrder32Little.rawValue |
                  CGImageAlphaInfo.first.rawValue)
            }
        } else {
            bitmapInfo = CGBitmapInfo.init(rawValue: CGBitmapInfo.byteOrder32Little.rawValue |
              CGImageAlphaInfo.noneSkipFirst.rawValue)
        }

        let renderingIntent: CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent;
        let imageRef: CGImage = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent,
          bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpaceRef,
          bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: false,
          intent: renderingIntent)!;

        return imageRef

    }


    public func invalidateRect(x: UInt, y: UInt, width: UInt, height: UInt) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
              line: #line, column: #column, file: #file)
        }
#if os(iOS)
        let status: FREResult = FreSwiftBridge.bridge.FREInvalidateBitmapDataRect(object: rv, x: UInt32(x),
          y: UInt32(y), width: UInt32(width), height: UInt32(height))
#else
        let status: FREResult = FREInvalidateBitmapDataRect(rv, UInt32(x), UInt32(y), UInt32(width), UInt32(height))
#endif

        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot invalidateRect", type: FreSwiftHelper.getErrorCode(status),
              line: #line, column: #column, file: #file)
        }
    }

}
