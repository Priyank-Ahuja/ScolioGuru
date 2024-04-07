//
//  SGHeaderView.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/6/24.
//

import UIKit

class SGHeaderView: SelfDesigningView {

    @IBOutlet weak var headerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addShadow()
    }

}
