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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isPagingRequestAllowed = false
    
    // MARK: Variables
    var imageList:ImageList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageListCell = UINib(nibName: kImageListCell, bundle: nil)
        imagesTableView.register(imageListCell, forCellReuseIdentifier: kImageListCell)
        
        fetchImages(page: 1)
    }
    
    // MARK: Private Methods
    
    private func fetchImages(page: Int){
         weak var weakSelf = self
        if imageList == nil {
            activityIndicator.startAnimating()
        }
         
        SearchHandler.fetchImages(searchedText: "yellow+flower", page: page) { (imagesList, error) in
            DispatchQueue.main.async {
                weakSelf?.activityIndicator.stopAnimating()
                if weakSelf?.imageList == nil {
                    weakSelf?.imageList = imagesList
                }
                else {
                    weakSelf?.imageList?.images.append(contentsOf: imagesList?.images ?? [])
                }

                weakSelf?.imagesTableView.reloadData()
                weakSelf?.isPagingRequestAllowed = !(weakSelf?.imageList?.images.count == imagesList?.totalImages)
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

// MARK: UIScrollView Delegates
extension SearchVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  imageList == nil {
            return
        }

        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y

        if scrollOffset + scrollViewHeight + 500.0 > scrollContentSizeHeight && isPagingRequestAllowed {
            isPagingRequestAllowed = false
            let nextPage = (imageList!.images.count/20) + 1
            fetchImages(page: nextPage)
        }
    }
}
