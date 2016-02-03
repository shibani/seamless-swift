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
    
    //TO-DO - load a location based resto set dynamically
    //TO-DO - optimize json feed
    //TO-DO - sort json feed
    //TO-DO - reload tableView on search bar submit
    //TO-DO - add code to load more restos on scrolling in tableView: cellForRowAtIndexPath
    
    var locationManager:CLLocationManager!
    
    var loc: CLLocation!
    
    var manager: OneShotLocationManager?
    
    var data = NSMutableData()
    
    var restos = [[String: String]]()
    
    var chosenCellIndex = 0
    
    var chosenCellName = ""
    
    var refreshControl = UIRefreshControl()
    
    var cell : UITableViewCell?
    
    var zip : String?
    
    var isLoadingRestaurants = false
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet weak var searchField: UISearchBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView?.contentInset = UIEdgeInsetsMake(80.0, 0.0, 0.0, 0.0);
        
        searchField.delegate = self
        
        tableView?.dataSource = self
        
        tableView?.delegate = self
        
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            
            // fetch location or an error
            if let loc = location {
                
                print(loc.coordinate.latitude)
                print("loc: \(loc)")
                
                let latitude :CLLocationDegrees = loc.coordinate.latitude
                let longitude :CLLocationDegrees = loc.coordinate.longitude
                let newLocation = CLLocation(latitude: latitude, longitude: longitude)
                
                self.loadFirstRestos("10010")
                
            } else if let err = error {
                print(err.localizedDescription)
            }
            self.manager = nil
        }
        
        print("location: \(loc)")
        //self.getLocation()
        //self.loadFirstRestos(zip!)
        //self.loadFirstRestos("10010")
        self.tableView?.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocation(){
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            
            // fetch location or an error
            if let loc = location {
                
                print(loc.coordinate.latitude)
                
                let latitude :CLLocationDegrees = loc.coordinate.latitude
                let longitude :CLLocationDegrees = loc.coordinate.longitude
                let newLocation = CLLocation(latitude: latitude, longitude: longitude)
                
                let geocoder = CLGeocoder()
                
                geocoder.reverseGeocodeLocation(newLocation, completionHandler: {(placemarks, error)->Void in
                    
                    //var placemark:CLPlacemark!
                    
                    if (error != nil) {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                        return
                    }
                    
                    if let placemark = placemarks?.first {
                        self.displayLocationInfo(placemark)
                    }
                    
                    else {
                        print("No Placemarks!")
                        return
                    }
                })
            } else if let err = error {
                print(err.localizedDescription)
            }
            self.manager = nil
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark){
        //self.LocationManager.stopUpdatingLocation()
        print(placemark.thoroughfare)
        print(placemark.locality)
        print(placemark.postalCode)
        print(placemark.administrativeArea)
        print(placemark.country)
        
        zip = placemark.postalCode
        
        //self.loadFirstRestos(zip!)
    }
    
    func loadFirstRestos(str:String){
        
        isLoadingRestaurants = true
        
        let searchString = str
        
        let escapedSearchString = searchString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let urlString = "http://www.bigchomp.com/json/restaurants?search=\(escapedSearchString!)"
        
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
        
        let escapedSearchString = searchString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let urlString = "http://www.bigchomp.com/json/restaurants?search=\(escapedSearchString!)"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                print(json[0]["name"])
                
                let JSONData = json
                
                parseListJSON(JSONData)
                
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
        
        print("restos: \(restos)")
        self.isLoadingRestaurants = false
        //self.tableView?.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(restos.count)")
        return restos.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "RestoCell")
        
        cell.textLabel?.text = restos[indexPath.row]["name"] //resto.key
        cell.detailTextLabel?.text = restos[indexPath.row]["type"] //resto.value
        
        //TO-DO - add code to load more restos on scrolling here
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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