//
//  SGHomeViewModel.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import Foundation

final class SGHomeViewModel {
    let title = "Welcome"
    let description = "If you or someone you know is worried about their spinal health then you are in the right place. This app has been designed to help you learn more about a Spinal  Health condition called Scoliosis. It can allow to get a basic assessment for the condition."
    let tabs: [SGTabModel] = [SGTabModel(title: "Learn More", imageName: "learn-more", tabImage: "learn-more"),
                              SGTabModel(title: "Physio", imageName: "physio", tabImage: "physio"),
                              SGTabModel(title: "Community", imageName: "community", tabImage: "community"),
                              SGTabModel(title: "Profile", imageName: "profile", tabImage: "profile")]
}

