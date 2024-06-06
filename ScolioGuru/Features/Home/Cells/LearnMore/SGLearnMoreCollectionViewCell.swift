//
//  SGLearnMoreCollectionViewCell.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import UIKit

class SGLearnMoreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainView.layer.cornerRadius = 10
    }
    
    func setupInterface(model: SGTabModel) {
        self.titleLabel.text = model.title
        self.imageView.image = UIImage(named: model.imageName)
    }
    
    func setupInterface(model: SGForums) {
        self.titleLabel.text = model.name
        self.imageView.image = UIImage(named: model.image)
    }

}
