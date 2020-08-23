//
//  PhotoResponse.swift
//  FlickrApp
//
//  Created by Ashutosh Roy on 23/08/20.
//  Copyright © 2020 Ashutosh Roy. All rights reserved.
//

import Foundation

struct PhotoResponse: Decodable {
    var stat: String?
    var photos : Photos
}
