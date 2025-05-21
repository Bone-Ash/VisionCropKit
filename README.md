# VisionCropView

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-visionOS%20v1%20|%20v2-blue.svg)](#)
[![Swift](https://img.shields.io/badge/Swift-5.9%20|%206.0%20|%206.1%20|%206.2-orange.svg)](https://swift.org)

VisionCropView is a SwiftUI-based image cropping component tailored for visionOS (v1 and v2). It provides an easy and natural way to crop images with support for common aspect ratios and cropping, combined with smooth gestures for moving and resizing the crop frame.

## Features

- Supports popular aspect ratios including square, 3:4, 4:3, 9:16, 16:9
- Drag to move the crop frame within image bounds
- Pinch to resize the crop frame while maintaining the selected ratio
- Real-time crop preview overlayed on the original image
- Clean and lightweight SwiftUI implementation with `@Observable` state management
- Designed specifically for visionOS v1 and v2 environments
- Support for freeform aspect ratios will be added in future updates.

## Demo

![Demo](Demo.gif)

## Installation

Use Swift Package Manager to add VisionCropKit to your project:

1. In Xcode, select **File** > **Add Packages...**
2. Enter the repository URL of VisionCropKit
3. Add it to your project dependencies

Or add it manually to your `Package.swift`:

```
.package(url: "https://github.com/YourUser/VisionCropKit.git", from: "1.0.0")
```

## Example Usage

```
import SwiftUI
import VisionCropKit

struct ContentView: View {
    @State private var croppedImage: UIImage? = nil
    @State private var showImageCropper = true
    
    var body: some View {
        VStack {
            if let croppedImage {
                Image(uiImage: croppedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 400, maxHeight: 400)
            }
            
            Button("Open Cropper") {
                showImageCropper = true
            }
        }
        .padding()
        .sheet(isPresented: $showImageCropper) {
            let image = UIImage(named: "Photo")!
            VisionCropView(
                sourceImage: image,
                aspectRatio: .square,
                onComplete: { result in
                    if let result = result {
                        croppedImage = result
                    }
                }
            )
            .frame(width: 600, height: 600)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
```

## License

This project is licensed under the MIT License. Contributions and suggestions are always welcome!
