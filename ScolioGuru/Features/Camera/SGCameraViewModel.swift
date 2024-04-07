//
//  SGCameraViewModel.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/7/24.
//

import UIKit

final class SGCameraViewModel {
    
    var surroundingModel: [SGPreImageAnalysisModel] = [SGPreImageAnalysisModel(title: "Ambient Lighting", isEnabled: false), SGPreImageAnalysisModel(title: "Clear Background", isEnabled: false)]
    
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
        if averageBrightness > 0.1 {
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
        let threshold: CGFloat = 0.05 // Example threshold
                
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


}
