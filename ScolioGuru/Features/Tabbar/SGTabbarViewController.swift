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
        
        self.customTabBarView.backgroundColor = .systemFill
        self.customTabBarView.layer.cornerRadius = 30
        self.customTabBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.customTabBarView.layer.masksToBounds = false
        self.customTabBarView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        self.customTabBarView.layer.shadowOffset = CGSize(width: -6, height: -8)
        self.customTabBarView.layer.shadowOpacity = 0.5
        self.customTabBarView.layer.shadowRadius = 20
        
        self.view.addSubview(customTabBarView)
        self.view.bringSubviewToFront(self.tabBar)
    }
    
    private func setupTabs () {
        let home = self.createNav(with: "Home", and: UIImage(named: "home-tab-icon"), vc: SGHomeViewController())
        
        
        self.setViewControllers ([home], animated: true)
    }
    
    private
    func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        return nav
    }
}