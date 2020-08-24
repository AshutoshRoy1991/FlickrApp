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
    var photos: [Photo] = []
    private var pageNo = 1
    private var totalPages = 1
    private var searchText = "Apple"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFlickrPhotos()
    }
}

// MARK: - UICollectionView
extension FlickrMainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let photo = photos[indexPath.row]
        cell.imageURL = photo.imageURL
        cell.imageName = photo.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == (photos.count - 1) {
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
        self.photos.removeAll()
        
        getFlickrPhotos()
    }
}

// MARK: - Networking
extension FlickrMainViewController {
    func getFlickrPhotos() {
        
        fetchFlickrPhotos(searchText: self.searchText) { [weak self] photos in
            guard let selfie = self else { return }
            
            if let totalPages = photos?.total {
                selfie.totalPages = Int(totalPages) ?? 1
            }
            
            if let photos = photos?.photo {
                selfie.photos.append(contentsOf: photos)
                selfie.collectionView.reloadData()
            }
        }
    }
    
    func fetchFlickrPhotos(searchText: String? = nil, completion: ((Photos?) -> Void)? = nil) {
        let url = URL(string: "https://api.flickr.com/services/rest/")!
        var parameters = [
            "method" : "flickr.photos.search",
            "sort": "relevance",
            "format" : "json",
            "nojsoncallback" : "1",
        ]
        parameters["text"] = searchText
        parameters["page"] = String(pageNo)
        parameters["api_key"] = FlickrConstants.api_key
        parameters["per_page"] = String(FlickrConstants.per_page)
        
        AF.request(url, parameters: parameters).validate()
            .responseDecodable(of: PhotoResponse.self) { response in
                guard let photos = response.value else {
                    completion?(nil)
                    return }
                
                print(photos)
                completion?(photos.photos)
        }
    }
    
    private func loadNextPage() {
        if pageNo < totalPages {
            pageNo += 1
            getFlickrPhotos()
        }
    }
}
