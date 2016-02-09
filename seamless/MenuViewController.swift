//
//  MenuViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 1/2/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate{
    
    var receivedCellIndex = 0
    
    var receivedCellName = ""
    
    var chosenCellIndex = 0
    
    var chosenCellName = ""
    
    var chosenCellDescription = ""
    
    var chosenCellPrice = ""
    
    var zips = [[String: String]]()
    
    var restoData = NSMutableData()
    
    var restoJSONData:JSON = ""
    
    var menuItemsArray = [[String: String]]()
    
    var sectionItemsArray = [[String: String]]()

    @IBOutlet weak var restoLabel: UILabel!
    
    @IBOutlet weak var menuItemView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Sent by \(receivedCellName) at \(receivedCellIndex)")
        restoLabel.text = receivedCellName
        
        let escapedString = receivedCellName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let urlString = "http://www.bigchomp.com/json/restaurants/\(escapedString!)"
        
        
        if let url = NSURL(string: urlString) {
            if let restoData = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: restoData)
                
                restoJSONData = json
                
                parseMenuJSON(restoJSONData)
                
                //print(restoJSONData)
            }
        }
        
        menuItemView.dataSource = self
        
        menuItemView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Parse JSON
    
    func parseMenuJSON(json: JSON) {
        menuItemsArray = []
        for menuItem in json.arrayValue {
            let name = menuItem["name"].stringValue
            let price = menuItem["price"].stringValue
            let description = menuItem["description"].stringValue
            if price == "" && description == "" {
                let header_obj = ["name": name]
                sectionItemsArray.append(header_obj)
            } else {
                let obj = ["name": name, "price": price, "description": description]
                menuItemsArray.append(obj)
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionItemsArray.count
    }
    
    func tableView(menuItemView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsArray.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = sectionItemsArray[section].first! //this returns a tuple
        return "\(sectionTitle.1)"
    }
    
    func tableView(menuItemView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "MenuCell")
        
        //print(indexPath.row)
        
        cell.textLabel?.text = menuItemsArray[indexPath.row]["name"]
        
        if menuItemsArray[indexPath.row]["price"] == "" {
            cell.backgroundColor = UIColor.blueColor()
            cell.textLabel?.textColor = UIColor.whiteColor()
        } else {
            cell.detailTextLabel?.text = menuItemsArray[indexPath.row]["price"]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        chosenCellIndex = indexPath.row
        chosenCellName = menuItemsArray[indexPath.row]["name"]!
        chosenCellDescription = menuItemsArray[indexPath.row]["description"]!
        chosenCellPrice = menuItemsArray[indexPath.row]["price"]!
        
        //print("clicked: \(chosenCellName) at row \(chosenCellIndex)")
        
        if chosenCellPrice != "" {
        
            self.performSegueWithIdentifier("loadMenuDetailView", sender: self)
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        let menuDetailViewController = segue.destinationViewController as! MenuDetailViewController
        
        // set a variable in the second view controller with the data to pass
        menuDetailViewController.receivedCellIndex = chosenCellIndex
        menuDetailViewController.receivedCellName = chosenCellName
        menuDetailViewController.receivedCellDescription = chosenCellDescription
        menuDetailViewController.receivedCellPrice = chosenCellPrice
        
    }
    
}
