//
//  FlickrMainViewModel.swift
//  FlickrApp
//
//  Created by Ashutosh Roy on 25/08/20.
//  Copyright © 2020 Ashutosh Roy. All rights reserved.
//

import Foundation
import Alamofire

class FlickrMainViewModel: NSObject {
    
    var photos: [Photo] = []
    var totalPages = 1
    
    func getFlickrPhotos(searchText: String?, pageNo: Int, completion:@escaping ([Photo]?) -> Void) {
        
        search(searchText: searchText, pageNo: pageNo) { [weak self] photos in
            print(photos ?? "error")
            guard let selfie = self else { return }
            
            if let totalPages = photos?.total {
                selfie.totalPages = Int(totalPages) ?? 1
            }
            
            if let photos = photos?.photo {
                selfie.photos.append(contentsOf: photos)
                completion(selfie.photos)
            }
        }
    }
    
    private func search(searchText: String?, pageNo: Int, completion:@escaping (Photos?) -> Void) {
        
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
                    completion(nil)
                    return }
                
                print(photos)
                completion(photos.photos)
        }
        
    }
}
