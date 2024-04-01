//
//  SGHomeViewController.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/1/24.
//

import UIKit
import AVKit

final class SGHomeViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var letsStartButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        // Do any additional setup after loading the view.
    }
    
    private func setupInterface() {
        letsStartButton.layer.cornerRadius = 22
        
        self.headerView.layer.masksToBounds = false
        self.headerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.headerView.layer.shadowOffset = CGSize(width: -4, height: -6)
        self.headerView.layer.shadowOpacity = 0.5
        self.headerView.layer.shadowRadius = 20
    }
    
    @IBAction func letsStartButtonAction(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
            } else {
                
            }
        }
    }
    
}
