//
//  SGPhysioViewController.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import UIKit

class SGPhysioViewController: UIViewController {
    
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var headerView: SGHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model: SGPhysioViewModel
    
    init(model: SGPhysioViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        collectionView.register(UINib(nibName: "SGTitleCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "SGTitleCollectionViewCell")
        collectionView.register(UINib(nibName: "SGVideoBannerCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "SGVideoBannerCollectionViewCell")
        collectionView.register(UINib(nibName: "SGVideoCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "SGVideoCollectionViewCell")
        
        headerView.backButtonClosure = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        headerBackgroundView.addShadow()
    }
}

extension SGPhysioViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGTitleCollectionViewCell", for: indexPath) as? SGTitleCollectionViewCell else {return UICollectionViewCell()}
            cell.setupInterface(title: model.title, description: model.description)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGVideoBannerCollectionViewCell", for: indexPath) as? SGVideoBannerCollectionViewCell else {return UICollectionViewCell()}
            cell.setupVideo(url: "https://youtu.be/BeoWG4RIhNM?feature=shared&t=275")
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGTitleCollectionViewCell", for: indexPath) as? SGTitleCollectionViewCell else {return UICollectionViewCell()}
            cell.setupInterface(title: model.schrothTitle, description: model.schrothDescription, titleSize: 24, alignment: .left)
            return cell
        case 5:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGTitleCollectionViewCell", for: indexPath) as? SGTitleCollectionViewCell else {return UICollectionViewCell()}
            cell.setupInterface(title: model.scoliosisTitle, description: model.scoliosisDescription, titleSize: 24, alignment: .left)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGVideoCollectionViewCell", for: indexPath) as? SGVideoCollectionViewCell else {return UICollectionViewCell()}
            let videoModel = model.getVideoDetails(row: indexPath.row)
            cell.setupVideo(url: videoModel.url, title: videoModel.title, description: videoModel.description)
            return cell
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: UIScreen.main.bounds.size.width, height: 120)
        case 1:
            return CGSize(width: UIScreen.main.bounds.size.width, height: 160)
        case 2, 5:
            return CGSize(width: UIScreen.main.bounds.size.width, height: 110)
        default:
            return CGSize(width: UIScreen.main.bounds.size.width/2 - 15, height: 240)
        }
    }
    
}

