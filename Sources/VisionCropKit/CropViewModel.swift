import SwiftUI

@Observable
final class CropViewModel {
    var cropRect: CGRect
    let imageRect: CGRect
    
    private let onRectChange: (CGRect) -> Void
    
    init(
        containerSize: CGSize,
        imageAspect: CGFloat,
        ratio: CropRatio,
        initialCropRect: CGRect? = nil,
        onRectChange: @escaping (CGRect) -> Void
    ) {
        self.onRectChange = onRectChange
        
        imageRect = Self.fitRect(aspect: imageAspect, in: containerSize)
        
        if let initialRect = initialCropRect {
            cropRect = Self.cropRectFromNormalized(initialRect, in: imageRect)
        } else {
            cropRect = Self.makeCropFrame(in: imageRect, ratio: ratio)
        }
        
        onRectChange(normalizedRect)
    }
    
    func move(toCenter newCenter: CGPoint) {
        var x = newCenter.x - cropRect.width / 2
        var y = newCenter.y - cropRect.height / 2
        x = max(imageRect.minX, min(x, imageRect.maxX - cropRect.width))
        y = max(imageRect.minY, min(y, imageRect.maxY - cropRect.height))
        cropRect.origin = CGPoint(x: x, y: y)
        onRectChange(normalizedRect)
    }
    
    func resize(from baseRect: CGRect, by scale: CGFloat) {
        let minSize: CGFloat = 40
        
        let ratio = baseRect.width / baseRect.height
        var newWidth = baseRect.width * scale
        var newHeight = baseRect.height * scale
        
        newWidth = max(minSize, min(newWidth, imageRect.width))
        newHeight = newWidth / ratio
        
        if newHeight > imageRect.height {
            newHeight = imageRect.height
            newWidth = newHeight * ratio
        }
        
        let centerX = baseRect.midX
        let centerY = baseRect.midY
        
        let newX = centerX - newWidth / 2
        let newY = centerY - newHeight / 2
        
        cropRect = CGRect(
            x: max(imageRect.minX, min(newX, imageRect.maxX - newWidth)),
            y: max(imageRect.minY, min(newY, imageRect.maxY - newHeight)),
            width: newWidth,
            height: newHeight
        )
        
        onRectChange(normalizedRect)
    }
    
    func applyRatio(_ ratio: CropRatio) {
        let center = cropRect.center
        cropRect = Self.makeCropFrame(in: imageRect, ratio: ratio, center: center)
        onRectChange(normalizedRect)
    }
    
    var normalizedRect: CGRect {
        let x = (cropRect.minX - imageRect.minX) / imageRect.width
        let y = (cropRect.minY - imageRect.minY) / imageRect.height
        let width = cropRect.width / imageRect.width
        let height = cropRect.height / imageRect.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private static func fitRect(aspect: CGFloat, in size: CGSize) -> CGRect {
        let viewRatio = size.width / size.height
        if viewRatio > aspect {
            let height = size.height
            let width = height * aspect
            return CGRect(x: (size.width - width) / 2, y: 0, width: width, height: height)
        } else {
            let width = size.width
            let height = width / aspect
            return CGRect(x: 0, y: (size.height - height) / 2, width: width, height: height)
        }
    }
    
    private static func makeCropFrame(
        in imageRect: CGRect,
        ratio: CropRatio,
        center: CGPoint? = nil
    ) -> CGRect {
        let targetRatio = ratio.width / ratio.height
        let imageRatio = imageRect.width / imageRect.height
        var width, height: CGFloat
        
        if targetRatio > imageRatio {
            width = imageRect.width
            height = width / targetRatio
        } else {
            height = imageRect.height
            width = height * targetRatio
        }
        
        let centerPoint = center ?? CGPoint(x: imageRect.midX, y: imageRect.midY)
        let originX = centerPoint.x - width / 2
        let originY = centerPoint.y - height / 2
        
        let x = max(imageRect.minX, min(originX, imageRect.maxX - width))
        let y = max(imageRect.minY, min(originY, imageRect.maxY - height))
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private static func cropRectFromNormalized(_ normalizedRect: CGRect, in imageRect: CGRect) -> CGRect {
        CGRect(
            x: imageRect.minX + normalizedRect.minX * imageRect.width,
            y: imageRect.minY + normalizedRect.minY * imageRect.height,
            width: normalizedRect.width * imageRect.width,
            height: normalizedRect.height * imageRect.height
        )
    }
}
