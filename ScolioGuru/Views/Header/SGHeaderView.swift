//
//  SGHeaderView.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/6/24.
//

import UIKit

class SGHeaderView: SelfDesigningView {

    @IBOutlet weak var headerView: UIView!
    
    var backButtonClosure: VoidClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.addShadow()
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonClosure?()
    }
}
