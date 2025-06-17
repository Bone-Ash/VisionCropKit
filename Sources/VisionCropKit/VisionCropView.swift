import SwiftUI

public struct VisionCropView: View {
    private let sourceImage: UIImage
    private let initialRatio: CropAspectRatio
    private let initialRect: CGRect?
    private let onComplete: (UIImage?) -> Void
    
    @State private var cropRect = CGRect.zero
    @State private var viewModel: CropViewModel?
    @State private var selectedRatio: CropAspectRatio
    @Environment(\.dismiss) private var dismiss
    
    public init(
        sourceImage: UIImage,
        cropRect: CGRect? = nil,
        aspectRatio: CropAspectRatio = .square,
        onComplete: @escaping (UIImage?) -> Void
    ) {
        self.sourceImage = sourceImage
        self.initialRect = cropRect
        self.initialRatio = aspectRatio
        self.onComplete = onComplete
        self.selectedRatio = aspectRatio
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Image(uiImage: sourceImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    if let viewModel { CropFrameView(viewModel: viewModel) }
                }
                .onAppear {
                    if viewModel == nil {
                        viewModel = CropViewModel(
                            containerSize: geometry.size,
                            imageAspect: sourceImage.size.width / sourceImage.size.height,
                            cropRatio: selectedRatio.ratio,
                            initialCropRect: initialRect,
                            onRectChange: { rect in
                                self.cropRect = rect
                            }
                        )
                    }
                }
        }
        .background(Material.regular)
        .overlay(alignment: .topLeading) {
            Button {
                onComplete(nil)
                dismiss()
            } label: {
                Circle()
                    .fill(Material.bar)
                    .frame(height: 44)
                    .overlay {
                        Image(systemName: "xmark")
                    }
                    .hoverEffect()
            }
            .padding(22)
            .buttonStyle(.plain)
        }
        .overlay(alignment: .top) {
            Menu(selectedRatio.displayName) {
                ForEach(CropAspectRatio.allCases, id: \.self) { ratio in
                    Button {
                        selectedRatio = ratio
                        viewModel?.applyRatio(ratio.ratio)
                    } label: {
                        HStack {
                            Text(ratio.displayName)
                            if selectedRatio.displayName == ratio.displayName {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            .padding(.top, 22)
        }
        .overlay(alignment: .bottom) {
            Button("Crop", systemImage: "scissors") {
                if let viewModel {
                    let croppedImage = cropImage(sourceImage, with: viewModel.normalizedRect)
                    onComplete(croppedImage)
                    dismiss()
                }
            }
            .padding(.bottom, 22)
        }
        
    }
    
    private func cropImage(_ image: UIImage, with rect: CGRect) -> UIImage {
        let imageSize = image.size
        let x = rect.origin.x * imageSize.width
        let y = rect.origin.y * imageSize.height
        let width = rect.width * imageSize.width
        let height = rect.height * imageSize.height
        
        let cropRect = CGRect(x: x, y: y, width: width, height: height)
        
        guard let cgImage = image.cgImage,
              let croppedCGImage = cgImage.cropping(to: cropRect) else {
            return image
        }
        
        return UIImage(cgImage: croppedCGImage)
    }
}
