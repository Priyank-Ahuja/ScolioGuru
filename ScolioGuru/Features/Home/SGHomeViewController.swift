//
//  SGHomeViewController.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import UIKit

class SGHomeViewController: UIViewController {
    
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model: SGHomeViewModel
    
    init(model: SGHomeViewModel) {
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
        collectionView.register(UINib(nibName: "SGSpinalCheckCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "SGSpinalCheckCollectionViewCell")
        
        headerBackgroundView.addShadow()
    }
}

extension SGHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGSpinalCheckCollectionViewCell", for: indexPath) as? SGSpinalCheckCollectionViewCell else {return UICollectionViewCell()}
            cell.delegate = self
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGLearnMoreCollectionViewCell", for: indexPath) as? SGLearnMoreCollectionViewCell else {return UICollectionViewCell()}
            cell.setupInterface(model: model.tabs[indexPath.row-2])
            return cell
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: UIScreen.main.bounds.size.width, height: 150)
        case 1:
            return CGSize(width: UIScreen.main.bounds.size.width, height: 160)
        default:
            return CGSize(width: UIScreen.main.bounds.size.width/2 - 5, height: 165)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            let model = SGLearnMoreViewModel()
            let learnMoreControlelr = SGLearnMoreViewController(model: model)
            
            self.navigationController?.pushViewController(learnMoreControlelr, animated: true)
        case 3:
            let model = SGPhysioViewModel()
            let physioControlelr = SGPhysioViewController(model: model)
            
            self.navigationController?.pushViewController(physioControlelr, animated: true)
        case 4:
            let model = SGForumsViewModel()
            let forumsControlelr = SGForumsViewController(model: model)
            
            self.navigationController?.pushViewController(forumsControlelr, animated: true)
        default:
            return
        }
    }
    
}

extension SGHomeViewController: SGSpinalCheckCollectionViewCellDelegate {
    func spinalCheckButtonPressed() {
        let spinalCheckController = SGHealthCheckViewController()
        
        self.navigationController?.pushViewController(spinalCheckController, animated: true)
    }
}
