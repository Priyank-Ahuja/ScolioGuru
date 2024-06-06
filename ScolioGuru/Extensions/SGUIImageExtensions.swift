//
//  SGUIImageExtensions.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 6/5/24.
//

import UIKit

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        //UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        UIGraphicsImageRenderer(size: imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeImage(percentage: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let newImage = renderer.image { (context) in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        return newImage
    }
}
