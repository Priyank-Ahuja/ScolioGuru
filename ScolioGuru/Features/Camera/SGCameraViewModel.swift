//
//  SGCameraViewModel.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/7/24.
//

import UIKit

final class SGCameraViewModel {
    
    var surroundingModel: [SGPreImageAnalysisModel] = [SGPreImageAnalysisModel(title: "Ambient Lighting", isEnabled: false), SGPreImageAnalysisModel(title: "Clear Background", isEnabled: false)]
    
    var cameraViews = [0: SGCameraView(title: "Side View - Turn Left", imageName: "left-view", description: "Relax your posture and try to be comfortable."),
                       1: SGCameraView(title: "Side View - Turn Right", imageName: "right-view", description: "Relax your posture and try to be comfortable."),
                       2: SGCameraView(title: "Front View", imageName: "front-view", description: "Relax your posture and try to be comfortable. "),
                       3: SGCameraView(title: "Back View", imageName: "back-view", description: "Relax your posture and try to be comfortable. "),
                       4: SGCameraView(title: "Adams Bend Test", imageName: "adam-bend-test", description: "Follow the image or the audio to do this test. Hold your palms together in front of you and then bend towards your knee. Keep your arms straight at all times."),
                       5: SGCameraView(title: "Adams Bend Test", imageName: "adam-front-view", description: "Front View"),
                       6: SGCameraView(title: "Adams Bend Test", imageName: "adam-side-view", description: "Side View")]
    
    var currentViewNumber = 0 {
        didSet {
            if currentViewNumber == 7 {
                goToAnalysis = true
            } else {
                goToAnalysis = false
            }
        }
    }
    
    var state: SGCameraState = .preImage
    
    var goToAnalysis: Bool = false
    
    func getParamsError(of cgImage: CGImage) -> SGErrorModel {
        if !calculateAverageBrightness(of: cgImage) {
            return SGErrorModel(title: "Get better lighting", message: "Pleas take the picture in better lighting conditions.", isError: true)
        } else if !checkForClearBackground(in: cgImage) {
            return SGErrorModel(title: "Find better location", message: "Please find a better background to take the picture against.", isError: true)
        }
        return SGErrorModel(title: "", message: "", isError: false)
    }
    
    private func calculateAverageBrightness(of cgImage: CGImage) -> Bool {
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceGray()
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue) else { return false }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let data = context.data else { return false }
        
        let dataPointer = data.bindMemory(to: UInt8.self, capacity: width * height)
        var brightnessSum: CGFloat = 0
        
        for x in 0..<width {
            for y in 0..<height {
                let offset = y * width + x
                brightnessSum += CGFloat(dataPointer[offset])
            }
        }
        
        let totalPixels = CGFloat(width * height)
        let averageBrightness = brightnessSum / totalPixels / 255.0 // Normalize to [0,1]
        
        updateModel(isEnabled: true, title: "Ambient Lighting")
        if averageBrightness > 0.4 {
            updateModel(isEnabled: true, title: "Ambient Lighting")
            return true
        } else {
            updateModel(isEnabled: false, title: "Ambient Lighting")
            return false
        }
    }
    
    private func checkForClearBackground(in cgImage: CGImage) -> Bool {
        // Simplified example: Analyze the entire image. For real applications, segment the image to focus on the background.
        guard let pixelData = cgImage.dataProvider?.data as Data? else { return false }
        
        var colorVariance: CGFloat = 0
        var lastPixelColor: UIColor?
        
        for x in stride(from: 0, to: cgImage.width, by: 10) { // Skipping pixels for performance
            for y in stride(from: 0, to: cgImage.height, by: 10) {
                let pixelInfo: Int = ((cgImage.width * y) + x) * 4
                
                let r = CGFloat(pixelData[pixelInfo]) / 255.0
                let g = CGFloat(pixelData[pixelInfo+1]) / 255.0
                let b = CGFloat(pixelData[pixelInfo+2]) / 255.0
                
                let pixelColor = UIColor(red: r, green: g, blue: b, alpha: 1)
                
                if let lastColor = lastPixelColor {
                    colorVariance += pixelColor.variance(to: lastColor)
                }
                
                lastPixelColor = pixelColor
            }
        }
        
        // Determine if variance is below a threshold (indicating uniformity)
        // This threshold would need to be determined based on experimentation
        let threshold: CGFloat = 15000.0 // Example threshold
                
        updateModel(isEnabled: colorVariance < threshold, title: "Clear Background")
        return colorVariance < threshold
    }
    
    private func updateModel(isEnabled: Bool, title: String) {
        for (index, params) in surroundingModel.enumerated() {
            if params.title == title {
                surroundingModel[index].isEnabled = isEnabled
            }
        }
    }
    
    func resetSurroundingModel() {
    surroundingModel = [SGPreImageAnalysisModel(title: "Ambient Lighting", isEnabled: false), SGPreImageAnalysisModel(title: "Clear Background", isEnabled: false)]
    }

    func getCurrentView() -> SGCameraView? {
        return cameraViews[currentViewNumber]
    }
    
    func updateCurrentView() {
        if currentViewNumber <= 6 {
            currentViewNumber += 1
        }
    }
    
    func imageToCVPixelBuffer(from image: UIImage) -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else {
        return nil
      }

      CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
      let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

      context?.translateBy(x: 0, y: image.size.height)
      context?.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context!)
      image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      UIGraphicsPopContext()
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

      return pixelBuffer
    }
    
    func resizeAndConvertToPixelBuffer(image: UIImage, percentage: CGFloat) -> CVPixelBuffer? {
        let width = Int(image.size.width * percentage)
        let height = Int(image.size.height * percentage)
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 720, height: 720))
        
        guard let cgImage = resizedImage?.cgImage else {
            return nil
        }

        var pixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary

        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard let finalPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }

        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        context.render(ciImage, to: finalPixelBuffer)

        return finalPixelBuffer
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        var scale: CGFloat

        if size.width > size.height {
            scale = targetSize.width / size.width
        } else {
            scale = targetSize.height / size.height
        }

        let width = size.width * scale
        let height = size.height * scale

        let x = (targetSize.width - width) / 2.0
        let y = (targetSize.height - height) / 2.0

        let rect = CGRect(x: x, y: y, width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.setFillColor(UIColor.clear.cgColor)
        UIRectFill(CGRect(origin: .zero, size: targetSize))

        image.draw(in: rect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
