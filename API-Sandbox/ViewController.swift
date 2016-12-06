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

    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var bookLink: String = ""
    var allBooks: [Book] = []
    var currentBookIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        callRandomBooks()
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(sender: UIButton) {
       UIApplication.sharedApplication().openURL(NSURL(string: bookLink)!)
    }
  
    @IBAction func nextMovie(sender: UIButton) {
        // Show next movie.
        
        if currentBookIndex < allBooks.count - 1 {
            // Show the next movie after current movie in the array if there is any
            currentBookIndex += 1
            assignUIObjects(allBooks[currentBookIndex])
        } else {
            // if the our movies array is empty then call a random movie.
            callRandomBooks()
        }
    }
  
    @IBAction func previousMovie(sender: UIButton) {
        // show previous movie.
        
        switch currentBookIndex {
        case 0:
            return
        default:
            // show previous movie from current movie if there is any.
            currentBookIndex -= 1
            assignUIObjects(allBooks[currentBookIndex])
        }
        
    }
    
    private func callRandomBooks() {
        // Calls the top 25 free books listed in iTunes store
        
        let apiToContact = "https://itunes.apple.com/us/rss/topfreeebooks/limit=25/json"
        
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    let randomBookNumber = Int(arc4random_uniform(25))
                    let jsonBookData = json["feed"]["entry"][randomBookNumber]
                    let book = Book(json: jsonBookData)
                    self.assignUIObjects(book)
                    
                    // want our books array to have maximum 100 books
                    guard self.currentBookIndex < 100 else { return }
                    
                    // append the book object to allBooks array each time we request a random book
                    self.allBooks.append(book)
                    // update current index of allBooks array. It is the last element whenever we call random book.
                    self.currentBookIndex = self.allBooks.count - 1
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    private func assignUIObjects(book: Book) {
        // Assign a value to each UI object
        
        bookTitleLabel.text = book.title
        authorLabel.text = book.authorName
        releaseDateLabel.text = book.releaseDate
        publisherLabel.text = book.publisher
        loadPoster(book.poster)
        bookLink = book.link
    }
    
}

