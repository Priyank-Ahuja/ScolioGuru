//
//  SGLearnMoreViewModel.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import Foundation

struct VideoDetailsModel {
    let url: String
    let title: String
    let description: String
}

final class SGLearnMoreViewModel {
    let title = "Learn More"
    let description = "If you were identified as someone that may have scoliosis we have a pool of videos to help you learn more about your condition."
    let infoTitle = "Understanding Scoliosis"
    let infoDescription = "We are not sponsored but are only looking to help you learn about the condition from Doctors."
    
    func getVideoDetails(row: Int) -> VideoDetailsModel {
        if (row == 3) {
            let model = VideoDetailsModel(url: "https://www.youtube.com/watch?v=13kps6pFPiE", title: "Detecting and Treating Scoliosis", description: "describes each phase of detecting and treating scoliosis")
            return model
        } else {
            
            let model = VideoDetailsModel(url: "https://www.youtube.com/watch?v=ao9RlBasW-c", title: "Understanding Scoliosis Type From X-rays", description: "explains the 4 main type of curves when you have Scoliosis")
            return model
        }
    }
}
