//
//  Photos.swift
//  FlickrApp
//
//  Created by Ashutosh Roy on 23/08/20.
//  Copyright © 2020 Ashutosh Roy. All rights reserved.
//

import Foundation

struct Photos : Decodable {
    let page : Int?
    let pages : Int?
    let perpage : Int?
    let total : String
    let photo : [Photo]?
}
