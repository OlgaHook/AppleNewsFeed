//
//  SavedNevsTableViewController.swift
//  AppleNewsFeed
//
//  Created by olga.krjuckova on 16/08/2021.
//

import UIKit
import CoreData

class SavedNevsTableViewController: UITableViewController {
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    //var webUrlStringForSource = Int()
    
    @IBOutlet weak var editButtonLabel: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        //for Core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        // here loadData()
        loadData()
        counItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        counItems()
    }
    func saveData(){
        do{
            try context?.save()
            basicAlert(title: "Deleted", message: "Article was deleted")
        }catch{
            print(error.localizedDescription)
            
        }
        loadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<Items> =
            Items.fetchRequest()
        do{
            savedItems = try (context?.fetch(request))!
            tableView.reloadData()
        }catch{
            fatalError("Error in retrieving Saved Items")
        }
        
        tableView.reloadData()
    }
    //how many items saved
    func counItems(){
        let itemsInTable = String(self.tableView.numberOfRows(inSection: 0))
        self.title = "Saved(\(itemsInTable))"
    }
    
    //edit button
    @IBAction func infoButtonTapped(_ sender: Any) {
        //basicAllert
        basicAlert(title: "Info - saved Items", message: "This section is for saved articles.To DELETE article press \"Edit\" button !")
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing{
            editButtonLabel.title = "Save"
        }else{
            editButtonLabel.title = "Edit"
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return savedItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedNewsCell", for: indexPath) as? NewsTableViewCell else{
            return UITableViewCell()
        }
        //Core data
        let item = savedItems[indexPath.row]
        cell.newsTitleLabel.text = item.newsTitle
        cell.newsTitleLabel.numberOfLines = 0
        
        if let image = UIImage(data: item.image!){
            cell.newsImageView.image = image
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //ddidSelectRow means, when I gonna tap on specific indexPath row then Ill go to mentioned View or another controller
    //and Im gonna pass value vc
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //see in storyboardId
        //need to pass item.url
        //The WebViewController StoryBoard ID must be set
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController else {
            return
        }
        self.title = "Saved"
        vc.urlString = self.savedItems[indexPath.row].url ??
            "https://newsapi.org/v2/everything?q=apple&from=2021-08-13&to=2021-08-11&sortBy=popularity&apiKey=8b14d98abae14dd9ac3e37adbd3d60f5"
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Delete the row from the data source
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Do you want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
                let item = self.savedItems[indexPath.row]
                self.context?.delete(item)
                self.saveData()
            }))
            self.present(alert, animated: true)
            //need AllertController with closure
            //safeData and load Data
        }
    }
    
    
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let row = savedItems.remove(at: fromIndexPath.row)
        savedItems.insert(row, at: to.row)
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
