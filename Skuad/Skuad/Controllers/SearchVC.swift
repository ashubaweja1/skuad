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
    var imageList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageListCell = UINib(nibName: kImageListCell, bundle: nil)
        imagesTableView.register(imageListCell, forCellReuseIdentifier: kImageListCell)
    }
}


// MARK: UITableView Delegates & Datasource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
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
        if let imageListCell = cell as? ImageListCell {
            print("configure cell")
        }
        return cell
    }
}

