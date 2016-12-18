//
//  Turkey.swift
//  API-Sandbox
//
//  Created by Mehmet Sadıç on 16/12/2016.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TurkeyTopics {
    
    let category: String
    let score: Int
    let profileImage: String
    let messageTitle: String
    let link: String
    let domain: String
    
    
    init(json: JSON) {
        self.category = json["data"]["link_flair_text"].stringValue
        self.score = json["data"]["num_comments"].intValue
        self.profileImage = json["data"]["thumbnail"].stringValue
        self.messageTitle = json["data"]["title"].stringValue
        self.link = json["data"]["url"].stringValue
        self.domain = json["data"]["domain"].stringValue
    }
}
