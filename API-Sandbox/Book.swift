//
//  Book.swift
//  API-Sandbox
//
//  Created by Mehmet Sadıç on 06/12/2016.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Book {
    // A struct that contains properties of a Book
    
    let title: String
    let authorName: String
    let publisher: String
    let poster: String
    let releaseDate: String
    let link: String
    
    init(json: JSON) {
        self.title = json["im:name"]["label"].stringValue
        self.authorName = json["im:artist"]["label"].stringValue
        self.publisher = json["im:publisher"]["label"].stringValue
        self.poster = json["im:image"][2]["label"].stringValue
        self.releaseDate = json["im:releaseDate"]["attributes"]["label"].stringValue
        self.link = json["link"]["attributes"]["href"].stringValue
    }
}
