//
//  SGVideoCollectionViewCell.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import UIKit
import YouTubePlayer

class SGVideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    @IBOutlet weak var videoView: YouTubePlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        videoView.layer.cornerRadius = 10
    }
    
    func setupVideo(url: String, title: String, description: String) {
        guard let myVideoURL = URL(string: url) else {return}
        videoView.loadVideoURL(myVideoURL)
        self.videoTitleLabel.text = title
        self.videoDescriptionLabel.text = description
    }

}
