import CoreGraphics

public struct CropRatio {
    public let width: CGFloat
    public let height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    // Note: Support for freeform aspect ratios will be added in future updates.
}
