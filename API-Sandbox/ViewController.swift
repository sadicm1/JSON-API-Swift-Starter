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
    @IBOutlet weak var sourceLinkLabel: UIButton!
    
    var urlLink = ""
    var messageArray: [TurkeyTopics] = []
    var currentTopicIndex = -1
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getRedditApi()
    }
    
    private func getRedditApi() {
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
                    
                    // add reddit message to our array
                    self.messageArray.append(redditMessage)
                    self.currentTopicIndex += 1
                    
                    self.assignUI(from: redditMessage)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    private func assignUI(from redditMessage: TurkeyTopics) {
        // assign UI objects with the data from reddit message.
        
        categoryLabel.text = redditMessage.category
        numberOfCommentsLabel.text = String(redditMessage.numberOfComments)
        loadProfileImage(redditMessage.profileImage)
        messageTitleLabel.text = redditMessage.messageTitle
        urlLink = redditMessage.link
        sourceLinkLabel.setTitle("View on " + redditMessage.domain, forState: .Normal)
    }
    
    func loadProfileImage(urlString: String) {
        // Updates the image view when passed a url string
        profileImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
  @IBAction func previousTopic(sender: UIButton) {
    
    if currentTopicIndex <= 0 {
        return
    } else {
        currentTopicIndex -= 1
        assignUI(from: messageArray[currentTopicIndex])
    }
    
  }
  
  @IBAction func nextTopic(sender: UIButton) {
    
    if currentTopicIndex == messageArray.count - 1 {
        getRedditApi()
    } else {
        currentTopicIndex += 1
        assignUI(from: messageArray[currentTopicIndex])
    }
  }
  
  
  @IBAction func viewOn(sender: UIButton) {
    // views the original post on reddit site
    UIApplication.sharedApplication().openURL(NSURL(string: urlLink)!)
  }
    
}

