//
//  Movie.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Movie {
    let name: String
    let rightsOwner: String
    let price: Double
    let link: String
    let releaseDate: String
    let imageURL: NSURL?
    
    init(json: JSON) {
        self.name = json["im:name"]["label"].stringValue
        self.rightsOwner = json["rights"]["label"].stringValue
        self.price = Double(String(json["im:price"]["label"].stringValue.characters.dropFirst())) ?? 0
        self.link = json["link"][0]["attributes"]["href"].stringValue
        self.releaseDate = json["im:releaseDate"]["attributes"]["label"].stringValue
        self.imageURL = NSURL(string: json["im:image"][0]["label"].stringValue) ?? nil
    }
}
