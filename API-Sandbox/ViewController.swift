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
    
    var movieLink: String = ""
    var allMovies: Array<Movie> = []
    var currentMovieIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // exerciseOne()
        // exerciseTwo()
        // exerciseThree()
        
        callRandomMovies()
    }
    
    private func callRandomMovies() {
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    let randomMovieNumber = Int(arc4random_uniform(25))
                    let jsonMovieData = json["feed"]["entry"][randomMovieNumber]
                    
                    let movie = Movie(json: jsonMovieData)
                    self.assignUIObjects(movie)
                    
                    // want our movies array to have maximum 100 movies
                    guard self.currentMovieIndex < 100 else { return }
                 
                    // append the movie object to allMovies array each time we request a random movie
                    self.allMovies.append(movie)
                    // update current index of allMovies array. It is the last element whenever we call random movie.
                    self.currentMovieIndex = self.allMovies.count - 1
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    private func assignUIObjects(movie: Movie) {
        // Assign a value to each UI object
        
        movieTitleLabel.text = movie.name
        rightsOwnerLabel.text = movie.rightsOwner
        releaseDateLabel.text = movie.releaseDate
        priceLabel.text = String(movie.price)
        loadPoster(movie.poster)
        movieLink = movie.link
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
       UIApplication.sharedApplication().openURL(NSURL(string: movieLink)!)
    }
  
    @IBAction func nextMovie(sender: UIButton) {
        // Show next movie.
        
        if currentMovieIndex < allMovies.count - 1 {
            // Show the next movie after current movie in the array if there is any
            currentMovieIndex += 1
            assignUIObjects(allMovies[currentMovieIndex])
        } else {
            // if the our movies array is empty then call a random movie.
            callRandomMovies()
        }
    }
  
    @IBAction func previousMovie(sender: UIButton) {
        // show previous movie.
        
        switch currentMovieIndex {
        case 0:
            return
        default:
            // show previous movie from current movie if there is any.
            currentMovieIndex -= 1
            assignUIObjects(allMovies[currentMovieIndex])
        }
        
    }
    
}

