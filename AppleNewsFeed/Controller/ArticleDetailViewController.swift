//
//  ArticleDetailViewController.swift
//  AppleNewsFeed
//
//  Created by olga.krjuckova on 13/08/2021.
//

import UIKit
import CoreData

class ArticleDetailViewController: UIViewController {

    var savedItems = [Items]()
    //helps to access AppDelegate-> save-load conteiner
    var context: NSManagedObjectContext?
    var webUrlString = String()
    var titleString = String()
    var contentString = String()
    
    var newsImage: UIImage?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var readFullArticleButton: UIButton!
    @IBOutlet weak var saveArticleButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFullArticleButton.layer.cornerRadius = 10
        readFullArticleButton.tintColor = .label
        self.title = "Article"
        
        titleLabel.text = titleString
        contentTextView.text = contentString
        newsImageView.image = newsImage
        
        //for CodeData
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext

    }
    func saveData(){
        do{
            try context?.save()
            basicAlert(title: "Saved!", message: "To see your saved article, go to Saved tab bar.")
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // CoreData logic
    @IBAction func saveArticleButtonTapped(_ sender: Any) {
        //item form CoreData
        let newItem = Items(context: self.context!)
        newItem.newsTitle = titleString
        newItem.newsContent = contentString
        newItem.url = webUrlString
        
        //due to image in our case is Binary Data (Atribute in entity Items in Core data)
        guard let imageData: Data = newsImage?.pngData() else {
            return
        }
        // ! before = is not
        if !imageData.isEmpty{
            newItem.image = imageData
        }
        self.savedItems.append(newItem)
        saveData()
     
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //destination type of Webcontroller
        let destination: WebViewController = segue.destination as! WebViewController
        destination.urlString = webUrlString
        
    }

}
