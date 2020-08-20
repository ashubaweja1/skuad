//
//  GalleryVC.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import UIKit

/// This class will display the large images in the form of gallery
class GalleryVC: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    // MARK: Variables
    var imageList = [Image]()
    var selectedIndex = 0
    
    // MARK: Constants
    private let kGalleryCell = "GalleryCell"
    private let kTitle = "Gallery"

    
    // MARK: Initialization Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = kTitle
        registerGalleryCell()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        galleryCollectionView.isHidden = false
        galleryCollectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0) , at: .centeredHorizontally, animated: false)
    }
    
    // MARK: Private Methods
    /// This method will register Gallery Cell
    private func registerGalleryCell(){
        let nib = UINib(nibName: kGalleryCell, bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: kGalleryCell)
    }
}

// MARK: UICollectionView Delegates, Datasource & DelegateFlowLayout Methods
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
