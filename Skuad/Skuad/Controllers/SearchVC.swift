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
    
    let searchBar = UISearchBar()
    var isPagingRequestAllowed = false
    var searchedText = ""
    
    // MARK: Variables
    var imageList:ImageList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        let imageListCell = UINib(nibName: kImageListCell, bundle: nil)
        imagesTableView.register(imageListCell, forCellReuseIdentifier: kImageListCell)
    }
    
    // This method will configure navigation bar
    private func configureNavBar(){
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.search))
        navigationItem.rightBarButtonItem = searchBarButton
        
        searchBar.sizeToFit()
        searchBar.placeholder = "search your image"
        searchBar.delegate = self
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    // This method will be called when user click onn serach button
    @objc func search(){
        if let text = searchBar.text, text.count > 0 {
            searchedText = text
            fetchImages(page: 1)
            imagesTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            searchBar.endEditing(true)
            activityIndicator.startAnimating()
            imagesTableView.isUserInteractionEnabled = false
        }
    }
    
    private func fetchImages(page: Int){
        weak var weakSelf = self
        SearchHandler.fetchImages(searchedText: searchedText.encode(), page: page) { (imagesList, error) in
            DispatchQueue.main.async {
                weakSelf?.activityIndicator.stopAnimating()
                weakSelf?.imagesTableView.isUserInteractionEnabled = true
                
                if error == nil {
                    if page == 1 {
                        weakSelf?.imageList = nil
                        weakSelf?.imageList = imagesList
                    }
                    else {
                        weakSelf?.imageList?.images.append(contentsOf: imagesList?.images ?? [])
                    }

                    weakSelf?.imagesTableView.reloadData()
                    weakSelf?.isPagingRequestAllowed = !(weakSelf?.imageList?.images.count == imagesList?.totalImages)
                    
                    if weakSelf?.imageList?.totalImages == 0 {
                        weakSelf?.showAlert(msg: kNoImageFound)
                    }
                }
                else {
                    weakSelf?.showAlert(msg: error?.localizedDescription ?? kErrorMsg)
                }
            }
        }
     }
    
    func showAlert(msg: String) {
               let style: UIAlertController.Style =  .alert
               let actionSheet  = UIAlertController(title: kErrorTitle, message: msg, preferredStyle: style)

               let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
               actionSheet.addAction(okAction)
            
               self.present(actionSheet, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if let galleryVC = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as? GalleryVC {
            galleryVC.imageList = imageList?.images ?? []
            galleryVC.selectedIndex = indexPath.row
            self.navigationController?.pushViewController(galleryVC, animated: true)
        }
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

// MARK: UISearchBar Delegate Methods
extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search()
    }
}
