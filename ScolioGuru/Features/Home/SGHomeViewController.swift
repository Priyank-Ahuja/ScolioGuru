//
//  SGHomeViewController.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/1/24.
//

import UIKit
import AVKit
import CoreML

final class SGHomeViewController: UIViewController {
    
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var headerView: SGHeaderView!
    @IBOutlet weak var letsStartButton: UIButton!
    
    var model: MySpinalNetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        // Do any additional setup after loading the view.
    }
    
    private func setupInterface() {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        letsStartButton.setTitle("Let's Start", for: .normal)
        self.headerBackgroundView.addShadow()
    }
    
    @IBAction func letsStartButtonAction(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
                DispatchQueue.main.async {
                    let model = SGCameraViewModel()
                    let cameraViewController = SGCameraViewController(model: model)
                    cameraViewController.backButtonClosure = { [weak self] in
                        guard let self else { return }
                        self.navigationController?.popViewController(animated: true)
                        self.tabBarController?.tabBar.isHidden = false
                    }
                    self.navigationController?.pushViewController(cameraViewController, animated: true)
                }
            } else {
                
            }
        }
    }
    
}
