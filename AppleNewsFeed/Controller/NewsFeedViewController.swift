//
//  NewsFeedViewController.swift
//  AppleNewsFeed
//
//  Created by olga.krjuckova on 11/08/2021.
//

import UIKit
import Gloss
import WebKit


class NewsFeedViewController: UIViewController {
    //First(!) drag from table view and connect as dataSource and as delegate!!
    
    
    //before create MODEL
    var items: [Item] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Apple News"
        activityIndicatorView.isHidden = true
        //to avoid news request pressing any time -> addes hangleGetData()
        handleGetData()
    }
    
    func activityIndicator(animated: Bool){
        DispatchQueue.main.async {
            if animated{
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            }else{
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
        
    }
    
    @IBAction func infoBarItem(_ sender: Any) {
        basicAlert(title: "News Feed Info.", message: "Press Plane Item to Fetch Apple News Feed articles.")
    }
    
    @IBAction func getDataTapped(_ sender: Any) {
        self.activityIndicator(animated: true)
        handleGetData()
    }
    
    func handleGetData(){
        let jsonUrl = "https://newsapi.org/v2/everything?q=apple&from=2021-08-13&to=2021-08-11&sortBy=popularity&apiKey=8b14d98abae14dd9ac3e37adbd3d60f5"
        
        guard let url = URL(string: jsonUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let sessionUrl = URLSession(configuration: .default)
        let task = sessionUrl.dataTask(with: urlRequest) { data, response, err in
            print("response:", response as Any)
            
            if let err = err {
                self.basicAlert(title: "Error!", message: "\(err.localizedDescription)")
            }
            guard let data = data else {
                
                self.basicAlert(title: "Error!", message: "Something went wrong, no data")
                
                return
            }
            
            do{
                if let dictionaryData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    print("dictionaryData: ", dictionaryData)
                    self.populateData(dictionaryData)
                    
                }
            }catch{
                
            }
        }
        //to call the session
        task.resume()
        
    }
    //(_) -> no name
    func populateData(_ dictionary: [String: Any]){
        guard  let responseDict = dictionary["articles"] as? [Gloss.JSON] else {
            return
        }
        items = [Item].from(jsonArray: responseDict) ?? []
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator(animated: false)
        }
    }
    
    
}
//MARK:UITableViewDelegate, UITableViewDataSource

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeed", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.newsTitleLabel.text = item.title
        cell.newsTitleLabel.numberOfLines = 0
        
        if let image = item.image{
            cell.newsImageView.image = image
        }
        
        let date = String(item.publishedAt.prefix(10))
        self.title = "Apple News \(date)"
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //clicking on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //not using segue
        //Main storyboard need to accesed 
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "ArticleDetailViewController") as? ArticleDetailViewController else {
            return
        }
        let item = items[indexPath.row]
        vc.contentString = item.description
        vc.titleString = item.title
        vc.webUrlString = item.url
        vc.newsImage = item.image
        
        //to present Modally
       //present(vc, animated: true, completion: nil)
        
        //to present Navigation Controller together with selected News cell
        navigationController?.pushViewController(vc, animated: true)
    }
}
