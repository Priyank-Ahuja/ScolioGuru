//
//  SGButtonView.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/6/24.
//

import UIKit

class SGButton: UIButton {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setupInterface()
    }
    
    private func setupInterface() {
        self.layer.cornerRadius = 22
        self.backgroundColor = UIColor.chardonnaya
        self.tintColor = .black
        self.addShadow()
    }
}
