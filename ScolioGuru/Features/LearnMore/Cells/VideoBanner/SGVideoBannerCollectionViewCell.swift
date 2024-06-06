//
//  SGVideoBannerCollectionViewCell.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import UIKit
import YouTubePlayer

class SGVideoBannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupVideo(url: String) {
        guard let myVideoURL = URL(string: url) else {return}
        youtubePlayerView.loadVideoURL(myVideoURL)
    }

}
