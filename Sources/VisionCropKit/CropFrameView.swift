import SwiftUI

struct CropFrameView: View {
    @Bindable var viewModel: CropViewModel
    @State private var startCenter: CGPoint = .zero
    @State private var startTouch: CGPoint = .zero
    @State private var baseRect: CGRect = .zero
    @State private var isScaling: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.45))
                .frame(width: viewModel.imageRect.width, height: viewModel.imageRect.height)
                .position(x: viewModel.imageRect.midX, y: viewModel.imageRect.midY)
                .mask {
                    Rectangle()
                        .overlay {
                            Rectangle()
                                .frame(width: viewModel.cropRect.width, height: viewModel.cropRect.height)
                                .position(x: viewModel.cropRect.midX, y: viewModel.cropRect.midY)
                                .blendMode(.destinationOut)
                        }
                        .compositingGroup()
                }
                .allowsHitTesting(false)
            
            Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: viewModel.cropRect.width, height: viewModel.cropRect.height)
                .position(x: viewModel.cropRect.midX, y: viewModel.cropRect.midY)
                .overlay {
                    GridLines()
                        .stroke(Color.white.opacity(0.7), lineWidth: 0.5)
                        .frame(width: viewModel.cropRect.width, height: viewModel.cropRect.height)
                        .position(x: viewModel.cropRect.midX, y: viewModel.cropRect.midY)
                }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    if gesture.translation == .zero {
                        startCenter = CGPoint(x: viewModel.cropRect.midX, y: viewModel.cropRect.midY)
                        startTouch = gesture.startLocation
                    }
                    let newCenter = CGPoint(
                        x: startCenter.x + gesture.location.x - startTouch.x,
                        y: startCenter.y + gesture.location.y - startTouch.y
                    )
                    viewModel.move(toCenter: newCenter)
                }
        )
        .simultaneousGesture(
            MagnificationGesture()
                .onChanged { value in
                    if !isScaling {
                        baseRect = viewModel.cropRect
                        isScaling = true
                    }
                    viewModel.resize(from: baseRect, by: value)
                }
                .onEnded { _ in
                    isScaling = false
                }
        )
        .animation(.easeInOut(duration: 0.08), value: viewModel.cropRect)
    }
}

struct GridLines: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let thirdWidth = rect.width / 3
        for i in 1...2 {
            let xPosition = rect.minX + thirdWidth * CGFloat(i)
            path.move(to: CGPoint(x: xPosition, y: rect.minY))
            path.addLine(to: CGPoint(x: xPosition, y: rect.maxY))
        }
        
        let thirdHeight = rect.height / 3
        for i in 1...2 {
            let yPosition = rect.minY + thirdHeight * CGFloat(i)
            path.move(to: CGPoint(x: rect.minX, y: yPosition))
            path.addLine(to: CGPoint(x: rect.maxX, y: yPosition))
        }
        
        return path
    }
}
