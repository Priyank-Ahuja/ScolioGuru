//
//  SGUIViewExtension.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/7/24.
//

import UIKit

extension UIView {
    
    public func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.layer.shadowOffset = CGSize(width: -4, height: -6)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 20
    }
    
    public func addShadow(alpha: CGFloat, shadowOffset: CGSize) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(alpha).cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 20
    }
}
