//
//  GalleryVC.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import UIKit

private let kGalleryCell = "GalleryCell"
private let kTitle = "Gallery"

class GalleryVC: UIViewController {
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    var imageList = [Image]()
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = kTitle
        
        let nib = UINib(nibName: kGalleryCell, bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: kGalleryCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        galleryCollectionView.isHidden = false
        galleryCollectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0) , at: .centeredHorizontally, animated: false)
    }
}

extension GalleryVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGalleryCell, for: indexPath) as? GalleryCell {
            cell.configureGalleryCell(image: imageList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
