//
//  FlickrMainViewController.swift
//  FlickrApp
//
//  Created by Ashutosh Roy on 23/08/20.
//  Copyright © 2020 Ashutosh Roy. All rights reserved.
//

import UIKit
import Alamofire

final class FlickrMainViewController: UIViewController {
    private var pageNo = 1
    private var totalPages = 1
    private var searchText = "Apple"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = FlickrMainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFlickrPhotos()
    }
}

// MARK: - UICollectionView
extension FlickrMainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let photo = viewModel.photos[indexPath.row]
        cell.imageURL = photo.imageURL
        cell.imageName = photo.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == (viewModel.photos.count - 9) {
            loadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView = UICollectionReusableView()
        
        if kind == UICollectionView.elementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeader", for: indexPath)
        }
        return reusableView
    }
}

// MARK: - UICollectionViewFlowLayout
extension FlickrMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width / FlickrConstants.defaultColumnCount) - 1
        return CGSize(width: itemWidth, height: itemWidth + 25)
    }
}

// MARK: - UISearchBar
extension FlickrMainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.searchText = searchBar.text ?? ""
        self.viewModel.photos.removeAll()
        
        getFlickrPhotos()
    }
}

// MARK: - Networking
extension FlickrMainViewController {
    func getFlickrPhotos() {
        viewModel.getFlickrPhotos(searchText: self.searchText, pageNo: self.pageNo) { [weak self] _ in
            guard let selfie = self else { return }
            selfie.collectionView.reloadData()
        }
    }
    
    private func loadNextPage() {
        if pageNo < viewModel.totalPages {
            pageNo += 1
            getFlickrPhotos()
        }
    }
}
