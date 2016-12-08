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

    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var allAlbums: Array<Album> = []
    var currentAlbumIndex = 0
    var albumLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        callRandomAlbums()
    }
    
    private func callRandomAlbums() {
        let apiToContact = "https://itunes.apple.com/search"
        let parameters = ["term": "selena+gomez", "media": "music"]
        
        // This code will call the iTunes top 25 Albums endpoint listed above
        Alamofire.request(.GET, apiToContact, parameters: parameters).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    let randomAlbumNumber = Int(arc4random_uniform(25))
                    let jsonAlbumData = json["results"][randomAlbumNumber]
                    
                    let album = Album(json: jsonAlbumData)
                    self.assignUIObjects(album)
                    
                    // want our Albums array to have maximum 100 Albums
                    guard self.currentAlbumIndex < 100 else { return }
                 
                    // append the Album object to allAlbums array each time we request a random Album
                    self.allAlbums.append(album)
                    // update current index of allAlbums array. It is the last element whenever we call random Album.
                    self.currentAlbumIndex = self.allAlbums.count - 1
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    private func assignUIObjects(album: Album) {
        // Assign a value to each UI object
        
        albumTitleLabel.text = album.name
        artistLabel.text = album.artist
        releaseDateLabel.text = album.releaseDate
        priceLabel.text = String(album.price)
        loadPoster(album.poster)
        albumLink = album.link
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
        UIApplication.sharedApplication().openURL(NSURL(string: albumLink)!)
    }
  
    @IBAction func nextAlbum(sender: UIButton) {
        // Show next Album.
        
        if currentAlbumIndex < allAlbums.count - 1 {
            // Show the next Album after current Album in the array if there is any
            currentAlbumIndex += 1
            assignUIObjects(allAlbums[currentAlbumIndex])
        } else {
            // if the our Albums array is empty then call a random Album.
            callRandomAlbums()
        }
    }
  
    @IBAction func previousAlbum(sender: UIButton) {
        // show previous Album.
        
        switch currentAlbumIndex {
        case 0:
            return
        default:
            // show previous Album from current Album if there is any.
            currentAlbumIndex -= 1
            assignUIObjects(allAlbums[currentAlbumIndex])
        }
        
    }
    
}

