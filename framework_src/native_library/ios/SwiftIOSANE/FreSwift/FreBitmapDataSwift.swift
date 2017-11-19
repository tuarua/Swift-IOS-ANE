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
/// FreBitmapDataSwift: wrapper for FREBitmapData2.
public class FreBitmapDataSwift: NSObject {
    private typealias FREBitmapData = FREBitmapData2

    /// raw FREObject value.
    public var rawValue: FREObject? = nil
    private var _bitmapData: FREBitmapData = FREBitmapData.init()
    /// A Int that specifies the width, in pixels, of the bitmap. This value corresponds to the width property of
    /// the ActionScript BitmapData class object. This field is read-only.
    public var width: Int = 0
    /// A Int that specifies the height, in pixels, of the bitmap. This value corresponds to the height
    /// property of the ActionScript BitmapData class object. This field is read-only.
    public var height: Int = 0
    /// A Bool that indicates whether the bitmap supports per-pixel transparency. This value corresponds to the
    /// transparent property of the ActionScript BitmapData class object. If the value is non-zero, then the
    /// pixel format is ARGB32. If the value is zero, the pixel format is _RGB32. Whether the value is big endian
    /// or little endian depends on the host device. This field is read-only.
    public var hasAlpha: Bool = false
    /// A uint32_t that indicates whether the bitmap pixels are stored as premultiplied color values. A true
    /// value means the values are premultipled. This field is read-only.
    public var isPremultiplied: Bool = false
    ///  A Bool that indicates the order in which the rows of bitmap data in the image are stored. A non-zero
    /// value means that the bottom row of the image appears first in the image data (in other words, the first
    /// value in the bits32 array is the first pixel of the last row in the image). A zero value means that the
    /// top row of the image appears first in the image data. This field is read-only.
    public var isInvertedY: Bool = false
    /// A UInt that specifies the number of UInt values per scanline. This value is typically
    /// the same as the width parameter. This field is read-only.
    public var lineStride32: UInt = 0
    /// A pointer to a UInt32. This value is an array of UInt32 values. Each value is one pixel of the bitmap.
    public var bits32: UnsafeMutablePointer<UInt32>!

    /// init: inits with a FREObject
    /// - parameter freObject: FREObject of AS3 type BitmapData
    public init(freObject: FREObject) {
        rawValue = freObject
    }

    /// init: inits with a CGImage
    /// - parameter cgImage: CGImage which will be converted into FREBitmapData2
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

    /// See the original [Adobe documentation](https://help.adobe.com/en_US/air/extensions/WSdb11516da818ea8d-755819ea133426056e1-8000.html)
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

    /// See the original [Adobe documentation](https://help.adobe.com/en_US/air/extensions/WSdb11516da818ea8d-755819ea133426056e1-8000.html)
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

    /// Handles conversion from a CGImage
    /// - throws: Can throw a `FreError` on fail
    public func setPixels(cgImage: CGImage) throws {
        if let dp = cgImage.dataProvider {
            if let data: NSData = dp.data {
                memcpy(bits32, data.bytes, data.length);
            }
            try invalidateRect(x: 0, y: 0, width: UInt(cgImage.width), height: UInt(cgImage.height))
        }
    }

    /// Handles conversion to a CGImage
    /// - throws: Can throw a `FreError` on fail
    /// returns: CGImage?
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

        let renderingIntent: CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        let imageRef: CGImage = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent,
          bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpaceRef,
          bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: false,
          intent: renderingIntent)!;

        return imageRef

    }

    /// See the original [Adobe documentation](https://help.adobe.com/en_US/air/extensions/WSb464b1207c184b14-62b8e11f12937b86be4-7fed.html)
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
