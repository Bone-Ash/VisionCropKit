import SwiftUI

public enum CropAspectRatio: CaseIterable {
    case square
    case portrait1x2
    case landscape2x1
    case portrait3x4
    case landscape4x3
    case portrait9x16
    case landscape16x9
    case freeform
    
    public static var allCases: [CropAspectRatio] {
        [.square, .portrait1x2, .landscape2x1, .portrait3x4, .landscape4x3, .portrait9x16, .landscape16x9, .freeform]
    }
    
    var ratio: CropRatio {
        switch self {
        case .square:
            return CropRatio(width: 1, height: 1)
        case .portrait1x2:
            return CropRatio(width: 1, height: 2)
        case .landscape2x1:
            return CropRatio(width: 2, height: 1)
        case .portrait3x4:
            return CropRatio(width: 3, height: 4)
        case .landscape4x3:
            return CropRatio(width: 4, height: 3)
        case .portrait9x16:
            return CropRatio(width: 9, height: 16)
        case .landscape16x9:
            return CropRatio(width: 16, height: 9)
        case .freeform:
            return CropRatio(width: 1, height: 1)
        }
    }
    
    var displayName: LocalizedStringKey {
        switch self {
        case .square:
            return "1:1"
        case .portrait1x2:
            return "1:2"
        case .landscape2x1:
            return "2:1"
        case .portrait3x4:
            return "3:4"
        case .landscape4x3:
            return "4:3"
        case .portrait9x16:
            return "9:16"
        case .landscape16x9:
            return "16:9"
        case .freeform:
            return "Freeform"
        }
    }
}
