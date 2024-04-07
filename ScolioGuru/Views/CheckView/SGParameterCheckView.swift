//
//  SGCheckView.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/7/24.
//

import UIKit

class SGParameterCheckView: SelfDesigningView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var model: SGParameterCheckViewModel?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupInterface(model: SGParameterCheckViewModel) {
        self.imageView.image = model.image
        self.titleLabel.text = model.title
    }
}
