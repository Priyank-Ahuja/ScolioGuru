//
//  SGSurveyOptionTableViewCell.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import UIKit

class SGSurveyOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.optionView.layer.cornerRadius = 10
        // Initialization code
    }

    func setupInterface(option: String, selectedCell: Int, row: Int) {
        if(selectedCell == row) {
            self.optionImageView.image = UIImage(named: "option-selected-background")
        } else {
            self.optionImageView.image = UIImage(named: "option-background")
        }
        self.optionLabel.text = option
        
        switch row {
        case 1, 4:
            optionViewWidth.constant = 109
        case 2:
            optionViewWidth.constant = 261
        case 3:
            optionViewWidth.constant = 190
        case 5:
            optionViewWidth.constant = 247
        default:
            optionViewWidth.constant = 247
        }
    }
}
