//
//  ViewController.swift
//  SampleGetTable
//
//  Created by v-20 on 6/30/17.
//  Copyright © 2017 VividInfotech. All rights reserved.
//

import UIKit
import CoreData


class LabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblOne: UILabel!
    @IBOutlet weak var lblTwo: UILabel!
}


class ViewController: UITableViewController,UISearchControllerDelegate,UISearchResultsUpdating,NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<Place>!
    var Candies = [Place]()
    var filteredCandies = [Place]()
    open var context: NSManagedObjectContext!
    var people11: [NSManagedObject] = []
    var people111: [NSManagedObjectContext] = []
    var content : NSArray = NSArray()
    var result : NSArray = NSArray()
    var identifier: NSArray = NSArray()
    var fetchRequest: NSFetchRequest<NSFetchRequestResult>!
    var fetchResult: NSFetchedResultsController<NSFetchRequestResult>!
    var filteredList: NSArray = NSArray()
    var str : NSArray = NSArray()
    var componentArray : NSMutableArray = NSMutableArray()
    var searchController: UISearchController?
    var data = [String]()
    var filteredData = [String]()
    var isDataFiltered: Bool = false
    @IBOutlet var tableListView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = ({
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.scopeButtonTitles = ["All"]
            
            //setup the search bar
            searchController.searchBar.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
//            self.searchBarContainer?.addSubview(searchController.searchBar)
            self.tableListView.addSubview(searchController.searchBar)
            searchController.searchBar.sizeToFit()
            
            return searchController
        })()
        doRequestGet()
        
//        configureFetchedResultsController()
//        
//        do {
//            try fetchedResultsController.performFetch()
//            print("feterds",fetchedResultsController)
//        } catch {
//            print("An error occurred in fetching")
//            
//        }
        
//        self.greetAgain(withData: result)
        DispatchQueue.main.async {
            self.tableListView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
           }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return str.count
//        let numberOfItems = isDataFiltered ? filteredData.count : str.count
//        return numberOfItems
        
//        if (self.searchController?.isActive)!
//        {
//            return self.filteredList.count
//        }
//        else
//        {
//            return str.count
//        }
        if (searchController?.isActive)! && searchController?.searchBar.text != "" {
            return filteredCandies.count
        }
        print("string compoundedds",str.count)
        return str.count-1


    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelTableViewCell
        
        let candy: Place
        if (searchController?.isActive)! && searchController?.searchBar.text != "" {
            candy = filteredCandies[indexPath.row]
        } else {
            print(Candies)
            candy = Candies[indexPath.row]
            
        }
        cell.lblOne?.text = candy.titleplace
        cell.lblTwo?.text = candy.bodyplace

        
        return cell
    }
    
    
    func configureFetchedResultsController() {
//        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let animalsFetchRequest = NSFetchRequest<Place>(entityName: "Place")
        let primarySortDescriptor = NSSortDescriptor(key: "titleplace", ascending: true)
//      let secondarySortDescriptor = NSSortDescriptor(key: "commonName", ascending: true)
        animalsFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        self.fetchedResultsController = NSFetchedResultsController<Place>(
            fetchRequest: animalsFetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        self.fetchedResultsController.delegate = self
        
    }
    
    func serviceCall()  {
        let urlPath = "http://jsonplaceholder.typicode.com/posts"
        let url = NSURL(string: urlPath)
        let session = URLSession.shared
        let task = session.dataTask(with: url! as URL, completionHandler: {data, response, error -> Void in
            
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    
                    print("resullllt",jsonResult)
                    
                }
            }
            catch{
                
                print("Somthing wrong")
                
            }
        })
        
        task.resume()
    }
    
    
    
    func doRequestGet(){
        
        let task = URLSession.shared.dataTask(with: NSURL(string: "http://jsonplaceholder.typicode.com/posts")! as URL, completionHandler: { (data, response, error) -> Void in
            do{
                self.str = try JSONSerialization.jsonObject(with: data!, options:[]) as! NSArray
//                print("json data: \(self.str)")
//                print("json data: \(self.str.count)")
//              self.greetAgain(withData: self.str)
                self.save(withData: self.str)
                self.tableListView.reloadData()
                
            }
            catch {
                print("json error: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    func greetAgain(withData: NSArray){
        
        for _ in withData {
            content = withData.value(forKey: "title") as! NSArray
            identifier = withData.value(forKey: "body") as! NSArray
        }//
        
        tableListView.reloadData()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        //dismiss the keyboard if the search results are scrolled
        searchController?.searchBar.resignFirstResponder()
    }
    
    func searchIsEmpty() -> Bool
    {
        if let searchTerm = self.searchController?.searchBar.text {
            return searchTerm.isEmpty
        }
        return true
    }
    
//    func updateSearchResults(for searchController: UISearchController)
//    {
//        filterData()
//        tableListView?.reloadData()
//    }
    
    func searchString(_ string: String, searchTerm:String) -> Array<AnyObject>
    {
        var matches:Array<AnyObject> = []
        do {
            let regex = try NSRegularExpression(pattern: searchTerm, options: [.caseInsensitive, .allowCommentsAndWhitespace])
            let range = NSMakeRange(0, string.characters.count)
            matches = regex.matches(in: string, options: [], range: range)
        } catch _ {
        }
        return matches
    }
    
    func textForIndexPath(_ indexPath: IndexPath) -> String
    {
        let text = isDataFiltered ? filteredData[indexPath.row] : str[indexPath.row] as! String
        return text
    }
    
    func labelFont() -> UIFont
    {
        return UIFont.systemFont(ofSize: 17)
    }

    
    func filterData()
    {
        if searchIsEmpty() {
            isDataFiltered = false
        } else {
            filteredData = str.filter({ (string) -> Bool in
                if let searchTerm = self.searchController?.searchBar.text {
                    let searchTermMatches = self.searchString(string as! String, searchTerm: searchTerm).count > 0
                    if searchTermMatches {
                        return true
                    }
                }
                return false
            }) as! [String]
            isDataFiltered = true
        }
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCandies = Candies.filter({( candy : Place) -> Bool in
            let categoryMatch = (scope == "All") || (candy.titleplace == scope)
            return categoryMatch && candy.bodyplace!.lowercased().contains(searchText.lowercased())
        })
        tableListView.reloadData()
    }

    
    func save(withData: NSArray) {
        
        
        for i in 0 ... withData.count-1
        {
                
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
            
          
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Place",
                                                in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
            
          person.setValue((withData[i] as AnyObject).value(forKey: "title") as! String, forKey: "titleplace")
          person.setValue((withData[i] as AnyObject).value(forKey: "body") as! String, forKey: "bodyplace")
        
        do {
            try managedContext.save()
            Candies.append(person as! Place)
            print("fsdfsdfsd",people11.count)
//            print("getvalueeee",people11)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
        print("fsdfsdfsd--",people11.count)
//        print("getvalueeee",people11)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        tableListView?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }

}

