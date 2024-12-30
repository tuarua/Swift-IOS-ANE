/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

/// FreBitmapDataSwift: wrapper for FREBitmapData2.
public class FreBitmapDataSwift: NSObject {
    private typealias FREBitmapData = FREBitmapData2
    private var logger: FreSwiftLogger {
        return FreSwiftLogger.shared
    }
    /// raw FREObject value.
    public var rawValue: FREObject?
    private var _bitmapData: FREBitmapData = FREBitmapData()
    /// A Int that specifies the width, in pixels, of the bitmap. This value corresponds to the width property of
    /// the ActionScript BitmapData class object. This field is read-only.
    public var width = 0
    /// A Int that specifies the height, in pixels, of the bitmap. This value corresponds to the height
    /// property of the ActionScript BitmapData class object. This field is read-only.
    public var height = 0
    /// A Bool that indicates whether the bitmap supports per-pixel transparency. This value corresponds to the
    /// transparent property of the ActionScript BitmapData class object. If the value is non-zero, then the
    /// pixel format is ARGB32. If the value is zero, the pixel format is _RGB32. Whether the value is big endian
    /// or little endian depends on the host device. This field is read-only.
    public var hasAlpha = false
    /// A uint32_t that indicates whether the bitmap pixels are stored as premultiplied color values. A true
    /// value means the values are premultipled. This field is read-only.
    public var isPremultiplied = false
    ///  A Bool that indicates the order in which the rows of bitmap data in the image are stored. A non-zero
    /// value means that the bottom row of the image appears first in the image data (in other words, the first
    /// value in the bits32 array is the first pixel of the last row in the image). A zero value means that the
    /// top row of the image appears first in the image data. This field is read-only.
    public var isInvertedY = false
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
        if let freObject = FREObject(className: "flash.display.BitmapData",
                                             args: UInt32(cgImage.width),
                                             UInt32(cgImage.height), false, 0) {
            rawValue = freObject
            acquire()
            setPixels(cgImage)
            releaseData()
        }
    }

    /// See the original [Adobe documentation](https://help.adobe.com/en_US/air/extensions/WSdb11516da818ea8d-755819ea133426056e1-8000.html)
    public func acquire() {
        guard let rv = rawValue else { return }
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREAcquireBitmapData2(object: rv, descriptorToSet: &_bitmapData)
#else
        let status = FREAcquireBitmapData2(rv, &_bitmapData)
#endif
        
        guard FRE_OK == status else {
            logger.error(message: "cannot acquire BitmapData", type: FreSwiftHelper.getErrorCode(status))
            return
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
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREReleaseBitmapData(object: rv)
#else
        let status = FREReleaseBitmapData(rv)
#endif
        if FRE_OK == status { return }
        logger.error(message: "cannot releaseData", type: FreSwiftHelper.getErrorCode(status))
    }

    /// Handles conversion from a CGImage
    public func setPixels(_ image: CGImage) {
        if let dp = image.dataProvider {
            if let data: NSData = dp.data {
                memcpy(bits32, data.bytes, data.length)
            }
            invalidateRect(x: 0, y: 0, width: UInt(image.width), height: UInt(image.height))
        }
    }

    /// Handles conversion to a CGImage
    /// returns: CGImage?
    public func asCGImage() -> CGImage? {
        self.acquire()
        let releaseProvider: CGDataProviderReleaseDataCallback = { (_: UnsafeMutableRawPointer?, _: UnsafeRawPointer, _: Int) in
            // https://developer.apple.com/reference/coregraphics/cgdataproviderreleasedatacallback
            // N.B. 'CGDataProviderRelease' is unavailable: Core Foundation objects are automatically memory managed
            return
        }
        let provider: CGDataProvider = CGDataProvider(dataInfo: nil, data: bits32, size: (width * height * 4),
          releaseData: releaseProvider)!

        let bytesPerPixel = 4
        let bitsPerPixel = 32
        let bytesPerRow: Int = bytesPerPixel * Int(lineStride32)
        let bitsPerComponent = 8
        let colorSpaceRef: CGColorSpace = CGColorSpaceCreateDeviceRGB()

        var bitmapInfo: CGBitmapInfo

        if hasAlpha {
            if isPremultiplied {
                bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue |
                  CGImageAlphaInfo.premultipliedFirst.rawValue)
            } else {
                bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue |
                  CGImageAlphaInfo.first.rawValue)
            }
        } else {
            bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue |
              CGImageAlphaInfo.noneSkipFirst.rawValue)
        }

        let renderingIntent: CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        return CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent,
          bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpaceRef,
          bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: false,
          intent: renderingIntent)
    }

    /// See the original [Adobe documentation](https://help.adobe.com/en_US/air/extensions/WSb464b1207c184b14-62b8e11f12937b86be4-7fed.html)
    public func invalidateRect(x: UInt, y: UInt, width: UInt, height: UInt) {
        guard let rv = rawValue else { return }
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREInvalidateBitmapDataRect(object: rv, x: UInt32(x),
          y: UInt32(y), width: UInt32(width), height: UInt32(height))
#else
        let status = FREInvalidateBitmapDataRect(rv, UInt32(x), UInt32(y), UInt32(width), UInt32(height))
#endif

        if FRE_OK == status { return }
        logger.error(message: "cannot invalidateRect", type: FreSwiftHelper.getErrorCode(status))
    }
}
#if os(iOS) || os(tvOS)
public extension UIImage {
    /// Converts a FREObject of AS3 type BitmapData into a UIImage
    /// - parameter freObject: FREObject which is of AS3 type flash.display.BitmapData.
    /// - parameter scale: You may wish to scale the UIImage to screen size.
    /// - parameter orientation: 
    convenience init?(freObject: FREObject?, scale: CGFloat = 1.0, orientation: UIImage.Orientation = .up) {
        guard let rv = freObject else {
            return nil
        }
        let asBitmapData = FreBitmapDataSwift(freObject: rv)
        defer {
            asBitmapData.releaseData()
        }
        if let cgimg = asBitmapData.asCGImage() {
            self.init(cgImage: cgimg, scale: scale, orientation: orientation)
        } else {
            return nil
        }
    }
}
#endif
