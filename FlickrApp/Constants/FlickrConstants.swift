//
//  Constants.swift
//  FlickrApp
//
//  Created by Ashutosh Roy on 23/08/20.
//  Copyright © 2020 Ashutosh Roy. All rights reserved.
//

import UIKit

class FlickrConstants: NSObject {

    static let api_key = "062a6c0c49e4de1d78497d13a7dbb360"
    static let per_page = 20
//    static let searchURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FlickrConstants.api_key)&format=json&nojsoncallback=1&safe_search=1&per_page=\(FlickrConstants.per_page)&text=%@&page=%ld"
    static let imageURL = "https://farm%d.staticflickr.com/%@/%@_%@_m.jpg"
    
    static let defaultColumnCount: CGFloat = 3.0
}
