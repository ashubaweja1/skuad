//
//  SearchVC.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import UIKit

// MARK: Private Constants
private let kImageListCell = "ImageListCell"


class SearchVC: UIViewController {

    @IBOutlet weak var imagesTableView: UITableView!
    
    // MARK: Variables
    var imageList:ImageList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageListCell = UINib(nibName: kImageListCell, bundle: nil)
        imagesTableView.register(imageListCell, forCellReuseIdentifier: kImageListCell)
        
        fetchImagess()
    }
    
    // MARK: Private Methods
    
     private func fetchImagess(){
         weak var weakSelf = self
//         activityIndicator.startAnimating()
        SearchHandler.fetchImages(searchedText: "yellow+flower", page: 1) { (imagesList, error) in
            DispatchQueue.main.async {
            //               weakSelf?.activityIndicator.stopAnimating()
                weakSelf?.imageList = imagesList
                weakSelf?.imagesTableView.reloadData()
                          
            }
        }
     }
}


// MARK: UITableView Delegates & Datasource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList?.images.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kImageListCell, for: indexPath)
        cell.selectionStyle = .none
        if let imageListCell = cell as? ImageListCell, imageList?.images.count ?? 0 > indexPath.row {
            imageListCell.configureImageCell(image: imageList!.images[indexPath.row])
        }
        return cell
    }
}

