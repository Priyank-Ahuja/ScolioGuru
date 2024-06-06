//
//  SGForumsViewModel.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import Foundation

final class SGForumsViewModel {
    let title = "Community Forums"
    let description = "Pick your community of choice."
    let forums: [SGForums] = [SGForums(name: "Discord", image: "discord"),
                              SGForums(name: "Reditt", image: "reditt")]
}
