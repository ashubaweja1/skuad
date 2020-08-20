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
private let kSuggestionListCell = "SuggestionListCell"

class SearchVC: UIViewController {
    
    @IBOutlet weak var imagesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var suggestionView: UIView!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var suggestionTableHeightConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    let searchBar = UISearchBar()
    var isPagingRequestAllowed = false
    var searchedText = ""
    var imageList:ImageList?
    var suggestionList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        let imageListCell = UINib(nibName: kImageListCell, bundle: nil)
        imagesTableView.register(imageListCell, forCellReuseIdentifier: kImageListCell)
        suggestionTableView.register(UITableViewCell.self, forCellReuseIdentifier: kSuggestionListCell)
    }
    
    // This method will configure navigation bar
    private func configureNavBar(){
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.search))
        navigationItem.rightBarButtonItem = searchBarButton
        
        searchBar.sizeToFit()
        searchBar.placeholder = kSearchImage
        searchBar.delegate = self
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    // This method will be called when user click onn serach button
    @objc func search(){
        if let text = searchBar.text, text.count > 0 {
            searchedText = text
            imagesTableView.isUserInteractionEnabled = false
            imagesTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            searchBar.endEditing(true)
            activityIndicator.startAnimating()
            fetchImages(page: 1)
            removeSuggestionView()
        }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        suggestionView.isHidden = true
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
                        
                        if imagesList?.images.count ?? 0 > 0 {
                            UserDefaultHelper.addSuggestion(suggestion: weakSelf?.searchedText ?? "")
                        }
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
        if tableView == suggestionTableView {
            return suggestionList.count
        }
        return imageList?.images.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView == suggestionTableView) ? 30 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView == suggestionTableView) ? 30 : 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == imagesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: kImageListCell, for: indexPath)
            cell.selectionStyle = .none
            if let imageListCell = cell as? ImageListCell, imageList?.images.count ?? 0 > indexPath.row {
                imageListCell.configureImageCell(image: imageList!.images[indexPath.row])
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kSuggestionListCell, for: indexPath)
            cell.textLabel?.text = suggestionList[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == imagesTableView {
            searchBar.endEditing(true)
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            if let galleryVC = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as? GalleryVC {
                galleryVC.imageList = imageList?.images ?? []
                galleryVC.selectedIndex = indexPath.row
                self.navigationController?.pushViewController(galleryVC, animated: true)
            }
        }
        else {
            searchBar.text = suggestionList[indexPath.row]
            search()
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showSuggestionView()
    }
}

extension SearchVC {
    
    func showSuggestionView(){
        suggestionList.removeAll()
        suggestionList = UserDefaultHelper.getSuggestionList()
        if suggestionList.count > 0 {
            suggestionView.isHidden = false
            suggestionTableView.reloadData()
            suggestionTableHeightConstraint.constant = CGFloat(suggestionList.count * 30)
        }
    }
    
    func removeSuggestionView(){
        suggestionView.isHidden = true
    }
}
