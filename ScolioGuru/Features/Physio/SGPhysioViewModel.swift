//
//  SGPhysioViewModel.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import Foundation


final class SGPhysioViewModel {
    let title = "Physio"
    let description = "If you were identified as someone that may have scoliosis we urge you to watch the video below first before looking at some of the other exercise videos."
    let scoliosisTitle = "Physio Therapy for Scoliosis"
    let scoliosisDescription = "The purpose of the videos in this section is to help you identify a good approach to physiotherapy."
    let schrothTitle = "Schroth Physio Therapy"
    let schrothDescription = "It aims at helping you build your muscle strength to improve your spinal curve."
    
    func getVideoDetails(row: Int) -> VideoDetailsModel {
        if (row == 3) {
            let model = VideoDetailsModel(url: "https://www.youtube.com/watch?v=HemV0DXl8VU", title: "Schroth Method Physical Therapy", description: "Learn more about the Schroth Barcelona method")
            return model
        } else {
            
            let model = VideoDetailsModel(url: "https://www.youtube.com/watch?v=cmWYhpT6Qfk", title: "What are Schroth Method Exercises for Scoliosis?", description: "Check out how we treat Scoliosis using the Schroth Method")
            return model
        }
    }
}
