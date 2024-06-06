//
//  SGTabbarViewController.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/1/24.
//

import UIKit

class SGTabbarViewController: UITabBarController {
    
    var customTabBarView = UIView(frame: .zero)
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        setupTabs()
    //
    //        self.tabBar.barTintColor = .white
    //        self.tabBar.tintColor = .black
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setupTabBarUI()
        self.addCustomTabBarView()
        setupTabs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupCustomTabBarFrame()
    }
    
    private func setupCustomTabBarFrame() {
        let height = self.view.safeAreaInsets.bottom + 54
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        
        self.tabBar.frame = tabFrame
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
        customTabBarView.frame = tabBar.frame
    }
    
    private func setupTabBarUI() {
        // Setup your colors and corner radius
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.layer.cornerRadius = 25
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.tintColor = .black
        //self.tabBar.unselectedItemTintColor = UIColor.bl
        
        // Remove the line
        if #available(iOS 13.0, *) {
            let appearance = self.tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
        }
    }
    
    private func addCustomTabBarView() {
        self.customTabBarView.frame = tabBar.frame
        
        self.customTabBarView.backgroundColor = .clear
        self.customTabBarView.layer.cornerRadius = 30
        self.customTabBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.customTabBarView.addShadow(alpha: 0.4, shadowOffset: CGSize(width: -6, height: -8))
        
        self.view.addSubview(customTabBarView)
        self.view.bringSubviewToFront(self.tabBar)
    }
    
    private func setupTabs () {
        let homeModel = SGHomeViewModel()
        let resourcesModel = SGLearnMoreViewModel()
        let physioModel = SGPhysioViewModel()
        let forumsModel = SGForumsViewModel()
        
        let home = self.createNav(with: "Home", and: UIImage(named: "home-tab-icon"), vc: SGHomeViewController(model: homeModel))
        let resources = self.createNav(with: "Resources", and: UIImage(named: "resources-tab-icon"), vc: SGLearnMoreViewController(model: resourcesModel))
        let physio = self.createNav(with: "Physio", and: UIImage(named: "physio-tab-icon"), vc: SGPhysioViewController(model: physioModel))
        let forums = self.createNav(with: "Forums", and: UIImage(named: "forums-tab-icon"), vc: SGForumsViewController(model: forumsModel))
        
        self.setViewControllers ([resources, physio, home, forums], animated: true)
    }
    
    private
    func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        return nav
    }
}
