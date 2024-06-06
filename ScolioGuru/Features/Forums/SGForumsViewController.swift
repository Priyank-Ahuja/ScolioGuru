//
//  SGForumsViewController.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import UIKit

class SGForumsViewController: UIViewController {

    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var headerView: SGHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model: SGForumsViewModel
    
    init(model: SGForumsViewModel) {
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
        collectionView.register(UINib(nibName: "SGLearnMoreCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "SGLearnMoreCollectionViewCell")
        
        headerView.backButtonClosure = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        headerBackgroundView.addShadow()
    }
}

extension SGForumsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGTitleCollectionViewCell", for: indexPath) as? SGTitleCollectionViewCell else {return UICollectionViewCell()}
            cell.setupInterface(title: model.title, description: model.description)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGLearnMoreCollectionViewCell", for: indexPath) as? SGLearnMoreCollectionViewCell else {return UICollectionViewCell()}
            cell.setupInterface(model: model.forums[indexPath.row-1])
            return cell
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: UIScreen.main.bounds.size.width, height: 90)
        default:
            return CGSize(width: UIScreen.main.bounds.size.width/2 - 5, height: 175)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let model = SGLearnMoreViewModel()
            let learnMoreControlelr = SGLearnMoreViewController(model: model)
            
            //self.navigationController?.pushViewController(learnMoreControlelr, animated: true)
        case 2:
            let model = SGPhysioViewModel()
            let physioControlelr = SGPhysioViewController(model: model)
            
            //self.navigationController?.pushViewController(physioControlelr, animated: true)
        default:
            return
        }
    }
    
}

