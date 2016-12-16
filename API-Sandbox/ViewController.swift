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
    
    var urlLink = ""
  
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
                    let messageCount = UInt32(json["data"]["children"].count)
                    let randomMessageNumber = Int(arc4random_uniform(messageCount))
                    let jsonRedditData = json["data"]["children"][randomMessageNumber]
                    
                    let redditMessage = TurkeyTopics(json: jsonRedditData)
                    
                    self.categoryLabel.text = redditMessage.category
                    self.numberOfCommentsLabel.text = String(redditMessage.numberOfComments)
                    self.loadProfileImage(redditMessage.profileImage)
                    self.messageTitleLabel.text = redditMessage.messageTitle
                    self.urlLink = redditMessage.link
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func loadProfileImage(urlString: String) {
        // Updates the image view when passed a url string
        profileImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
  
  @IBAction func viewOnReddit(sender: UIButton) {
    // views the original post on reddit site
    UIApplication.sharedApplication().openURL(NSURL(string: urlLink)!)
  }
    
}

