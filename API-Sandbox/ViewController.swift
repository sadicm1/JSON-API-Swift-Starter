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

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var linkURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        exerciseOne()
        exerciseTwo()
        exerciseThree()
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    let jsonMovieData = json["feed"]["entry"][0]
                    
                    let movie = Movie(json: jsonMovieData)
                    self.linkURL = NSURL(string: movie.link)!
                    
                    self.movieTitleLabel.text = movie.name
                    self.rightsOwnerLabel.text = movie.rightsOwner
                    self.releaseDateLabel.text = movie.releaseDate
                    self.priceLabel.text = String(movie.price)
                    if let imageURL = movie.imageURL {
                        if let imageData = NSData(contentsOfURL: imageURL) {
                            self.posterImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(sender: UIButton) {
       UIApplication.sharedApplication().openURL(linkURL!)
    }
    
}

