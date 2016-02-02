//
//  ViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 12/28/15.
//  Copyright © 2015 Shibani Mookerjee. All rights reserved.
//
import UIKit
import CoreLocation

/*struct JsonFeed {
static var JSONData:JSON = ""
}*/

class ViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate, NSURLConnectionDataDelegate, UISearchBarDelegate {
    
    var manager: OneShotLocationManager?
    
    var locationManager:CLLocationManager!
    
    lazy var data = NSMutableData()
    
    var restos = [[String: String]]()
    
    var chosenCellIndex = 0
    
    var chosenCellName = ""
    
    var loc: CLLocation!
    
    var refreshControl = UIRefreshControl()
    
    var cell : UITableViewCell?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchField: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            
            // fetch location or an error
            if (location != nil) {
                self.loc = location
                print("location: \(self.loc)")
            } else if let err = error {
                print(err.localizedDescription)
            }
            self.manager = nil
        }
        
        searchField.delegate = self
        
        searchLocations("10010", clicked: false)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //self.tableView.reloadData()
    }
    
    
    func searchLocations(str:String, clicked:Bool){
        
        let searchString = str
        
        let escapedSearchString = searchString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let urlString = "http://www.bigchomp.com/json/restaurants?search=\(escapedSearchString!)"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                print(json[0]["name"])
                
                let JSONData = json
                
                let clicked = false
                
                parseListJSON(JSONData, clicked:clicked)
                
            }
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("searchText \(searchBar.text!)")
        
        let clicked = true
        
        searchLocations(searchBar.text!, clicked:clicked)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations = \(locations)")
    }
    
    func parseListJSON(json: JSON, clicked:Bool) {
        for resto in json.arrayValue {
            let name = resto["name"].stringValue
            let type = resto["type"].stringValue
            let obj = ["name": name, "type": type]
            restos.append(obj)
        }
        
        if clicked == true {
            //self.tableView?.reloadData()
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                self.tableView?.reloadData()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return sortedKeys.count
        return restos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as UITableViewCell!
        //let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        if !(cell != nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        cell.textLabel?.text = restos[indexPath.row]["name"] //resto.key
        cell.detailTextLabel?.text = restos[indexPath.row]["type"] //resto.value
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        chosenCellIndex = indexPath.row
        chosenCellName = restos[indexPath.row]["name"]!
        
        print("clicked: \(chosenCellName) at row \(chosenCellIndex)")
        
        self.performSegueWithIdentifier("loadRestoView", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        let restoViewController = segue.destinationViewController as! RestoViewController
        
        // set a variable in the second view controller with the data to pass
        restoViewController.receivedCellIndex = chosenCellIndex
        restoViewController.receivedCellName = chosenCellName
    }
    
    
}

