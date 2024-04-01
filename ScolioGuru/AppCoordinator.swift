//
//  AppCoordinator.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 3/28/24.
//

import Foundation
import UIKit

final class AppCoordinator: BaseCoordinator {
    
    let rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        makeSplashScreen()
    }
    
    private func makeSplashScreen() {
        showDashboardCoordinator()
    }
    
    private func showDashboardCoordinator() {
        
    }
    
    private func showDashboard() {
        
    }
    
}
