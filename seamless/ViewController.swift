//
//  ViewController.swift
//  newseamless
//
//  Created by Shibani Mookerjee on 2/2/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate, UITableViewDelegate, NSURLConnectionDataDelegate, UISearchBarDelegate {
    
    //DONE - load a location based resto set dynamically
    //DONE - reload tableView on search bar submit
    //DONE - sort json feed
    //TO-DO - optimize json feed/memory - limit results to 10 and then load more on scroll? in tableView: cellForRowAtIndexPath
    
    var loc: CLLocation!
    
    var currentLocation: CLLocation!
    
    var manager: OneShotLocationManager?
    
    var data = NSMutableData()
    
    var restos = [[String: String]]()
    
    var chosenCellIndex = 0
    
    var chosenCellName = ""
    
    var refreshControl = UIRefreshControl()
    
    var cell : UITableViewCell?
    
    var zip : String?
    
    var isLoadingRestaurants = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView?.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        
        searchBar.delegate = self
        
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            
            // fetch location or an error
            if let loc = location {
                
                print("latitude: \(loc.coordinate.latitude)")
                print("longitude: \(loc.coordinate.longitude)")
                
                let str :String = "latitude=\(loc.coordinate.latitude)&longitude=\(loc.coordinate.longitude)"
            
                self.loadSearchRestos(str)
                
            } else if let err = error {
                print(err.localizedDescription)
            }
            self.manager = nil
        }
        
        tableView?.dataSource = self
        
        tableView?.delegate = self
        
        //var str = "search=455 Graham Ave, Brooklyn, NY 11222"
        //let latlongstr = "latitude=40.759211&longitude=-73.984638"
        //self.loadFirstRestos(escapedString(str))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func escapedString(str: String) -> String{
        return str.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        dismissKeyboard()
        
        let str :String = "search=\(searchBar.text!)"
        loadSearchRestos(escapedString(str))
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.searchBar.endEditing(true)
    }
    
    func refreshUI() {
        dispatch_async(dispatch_get_main_queue(),{
            self.tableView!.reloadData()
        });
    }
    
    // MARK: - Load and Parse JSON
    
    func loadFirstRestos(str:String){
        
        isLoadingRestaurants = true
        
        let searchString = str
        
        let urlString = "http://www.bigchomp.com/json/restaurants?\(searchString)"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                print(json[0]["name"])
                
                let JSONData = json
                parseListJSON(JSONData)
            }
        }
    }
    
    func loadSearchRestos(str:String){
        
        self.isLoadingRestaurants = true
        
        let searchString = str
        
        let urlString = "http://www.bigchomp.com/json/restaurants?\(searchString)"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                print(json[0]["name"])
                
                let JSONData = json
                
                parseListAndRefresh(JSONData)
            }
        }
    }
    
    func parseListJSON(json: JSON) {
        restos = []
        for resto in json.arrayValue {
            let name = resto["name"].stringValue
            let type = resto["type"].stringValue
            let obj = ["name": name, "type": type]
            restos.append(obj)
        }
        
        self.isLoadingRestaurants = false
    }
    
    func parseListAndRefresh(json: JSON) {
        restos = []
        for resto in json.arrayValue {
            let name = resto["name"].stringValue
            let type = resto["type"].stringValue
            let obj = ["name": name, "type": type]
            restos.append(obj)
        }
        
        //print("restos: \(restos)")
        self.isLoadingRestaurants = false
        if restos.count > 0 {
            self.refreshUI()
            print("called from search")
        } else {
            let obj = ["name": "Sorry no listings were found", "type": ""]
            restos.append(obj)
            self.refreshUI()
        }
        //self.tableView?.reloadData()
        print("jsoncount: \(restos.count)")
    }
    
    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(restos.count)")
        return restos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "RestoCell")
        
        cell.textLabel?.text = restos[indexPath.row]["name"] //resto.key
        cell.detailTextLabel?.text = restos[indexPath.row]["type"] //resto.value
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dismissKeyboard()
        
        chosenCellIndex = indexPath.row
        chosenCellName = restos[indexPath.row]["name"]!
        
        print("clicked: \(chosenCellName) at row \(chosenCellIndex)")
        
        self.performSegueWithIdentifier("loadMenuView", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        let menuViewController = segue.destinationViewController as! MenuViewController
        
        // set a variable in the second view controller with the data to pass
        menuViewController.receivedCellIndex = chosenCellIndex
        menuViewController.receivedCellName = chosenCellName
    }
    
    
}