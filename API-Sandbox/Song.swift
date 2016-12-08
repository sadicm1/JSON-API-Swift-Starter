//
//  Song.swift
//  API-Sandbox
//
//  Created by Mehmet Sadıç on 07/12/2016.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Album {
    let artist: String
    let name: String
    let link: String
    let price: Double
    let poster: String
    let releaseDate: String
    
    init(json: JSON) {
        self.artist = json["artistName"].stringValue
        self.name = json["trackName"].stringValue
        self.link = json["collectionViewUrl"].stringValue
        self.price = json["collectionPrice"].doubleValue
        self.poster = json["artworkUrl100"].stringValue
        self.releaseDate = String(json["releaseDate"].stringValue.characters.prefix(10))
    }
}