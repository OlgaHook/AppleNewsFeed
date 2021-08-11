//
//  NewsFeedViewController.swift
//  AppleNewsFeed
//
//  Created by olga.krjuckova on 11/08/2021.
//

import UIKit
import Gloss

class NewsFeedViewController: UIViewController {
    //First(!) drag from table view and connect as dataSource and as delegate!!
    
    
    //before create MODEL
    var items: [Item] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Apple News"
        activityIndicator(animated: true)
    }
    
    func activityIndicator(animated: Bool){
        DispatchQueue.main.async {
            if animated{
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.startAnimating()
            }else{
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.stopAnimating()
            }
        }
        
    }
    
    @IBAction func infoBarItem(_ sender: Any) {
        basicAlert(title: "News Feed Info.", message: "Press Plane Item to Fetch Apple News Feed articles.")
    }
    
    @IBAction func getDataTapped(_ sender: Any) {
        handleGetData()
    }
    
    func handleGetData(){
        let jsonUrl = "https://newsapi.org/v2/everything?q=apple&from=2021-08-01&to=2021-08-08&sortBy=popularity&apiKey=8b14d98abae14dd9ac3e37adbd3d60f5"
        
        guard let url = URL(string: jsonUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let sessionUrl = URLSession(configuration: .default)
        let task = sessionUrl.dataTask(with: urlRequest) { data, response, err in
            
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
                }
            }catch{
                
            }
        }
        //to call the session
        task.resume()
        
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
        
        return cell
    }
    
    
    
}
