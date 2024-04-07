//
//  SGHomeViewController.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/1/24.
//

import UIKit
import AVKit

final class SGHomeViewController: UIViewController {
    
    @IBOutlet weak var headerView: SGHeaderView!
    @IBOutlet weak var letsStartButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        // Do any additional setup after loading the view.
    }
    
    private func setupInterface() {
        self.navigationController?.isNavigationBarHidden = true
        letsStartButton.setTitle("Let's Start", for: .normal)
    
        self.headerView.addShadow()
    }
    
    @IBAction func letsStartButtonAction(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
                DispatchQueue.main.async {
                    let model = SGCameraViewModel()
                    let vc = SGCameraViewController(model: model)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                
            }
        }
    }
    
}
