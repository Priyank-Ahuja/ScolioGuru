//
//  SGParameterCheckViewModel.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/7/24.
//

import UIKit


final class SGParameterCheckViewModel {
    let isEnabled: Bool
    let title: String
    let image: UIImage?
    
    init(isEnabled: Bool, title: String) {
        self.isEnabled = isEnabled
        self.title = title
        self.image = isEnabled ? UIImage(named: "check-yes") : UIImage(named: "check-no")
    }
}
