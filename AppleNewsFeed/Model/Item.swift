//
//  Item.swift
//  AppleNewsFeed
//
//  Created by olga.krjuckova on 11/08/2021.
//

import UIKit

import Gloss

class Item: JSONDecodable {
    
    var description: String
    var title: String
    var url: String
    var urlToImage: String
    var publishedAt: String
    var image: UIImage?
    
    
    required init?(json: JSON) {
        //if description is not a String, well present ""
        self.description = "description" <~~ json ?? ""
        self.title = "title" <~~ json ?? ""
        self.url = "url" <~~ json ?? ""
        self.urlToImage = "urlToImage" <~~ json ?? ""
        self.publishedAt = "publishedAt" <~~ json ?? ""
        
        //for image.If we Load and Save the data
        
        DispatchQueue.main.async {
            // func needed.Func in closure-> need self.
            self.image = self.loadImage()
        }
        
    }
    
    //restricted area-> visible here only
    private func loadImage() -> UIImage?{
        var returnImage: UIImage?
        
        guard let url = URL(string: urlToImage) else {
            return returnImage
        }
        
        if let data = try? Data(contentsOf: url){
            if let image = UIImage(data: data){
                returnImage = image
            }
        }
        return returnImage
    }
    
}
