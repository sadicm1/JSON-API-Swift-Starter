//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ViewController: UIViewController {
  
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var urlLinkLabel: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let apiToContact = "https://www.reddit.com/r/Turkey.json"
        // This code will call the topics related to Turkey from reddit site.
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    let randomMessageNumber = Int(arc4random_uniform(100))
                    let jsonRedditData = json["data"]["children"][randomMessageNumber]
                    
                    let redditMessage = TurkeyTopics(json: jsonRedditData)
                    
                    self.categoryLabel.text = redditMessage.category
                    self.numberOfCommentsLabel.text = String(redditMessage.numberOfComments)
                    
                    self.messageTitleLabel.text = redditMessage.messageTitle
                    
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
  
  
  
    
}

