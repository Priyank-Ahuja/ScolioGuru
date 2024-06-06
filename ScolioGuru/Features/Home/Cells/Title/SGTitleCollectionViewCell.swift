//
//  SGTitleCollectionViewCell.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import UIKit

class SGTitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupInterface(title: String, description: String, titleSize: CGFloat = 28, alignment: NSTextAlignment = .center) {
        titleLabel.text = title
        descriptionLabel.text = description
        titleLabel.font.withSize(titleSize)
        titleLabel.textAlignment = alignment
        descriptionLabel.textAlignment = alignment
    }
}
