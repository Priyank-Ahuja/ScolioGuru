//
//  SGSpinalCheckCollectionViewCell.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import UIKit

protocol SGSpinalCheckCollectionViewCellDelegate {
    func spinalCheckButtonPressed()
}

class SGSpinalCheckCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var spineImageView: UIImageView!
    
    var delegate: SGSpinalCheckCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.spineImageView.layer.cornerRadius = 10
    }
    
    @IBAction func spinalCheckButtonAction(_ sender: Any) {
        self.delegate?.spinalCheckButtonPressed()
    }
    
}
