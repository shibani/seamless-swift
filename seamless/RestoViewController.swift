//
//  RestoViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 1/2/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class RestoViewController: UIViewController, UITableViewDataSource, NSURLConnectionDataDelegate{
    
    var receivedCellIndex = 0
    
    var receivedCellName = ""
    
    var zips = [[String: String]]()
    
    lazy var restoData = NSMutableData()
    
    var restoJSONData:JSON = ""
    
    var menuItems = [[String: String]]()

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
            }
        }
        
        menuItemView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func parseMenuJSON(json: JSON) {
        for(key,subJson):(String, JSON) in json {
            let name = key
            let menuCat = ["name": name]
            
            menuItems.append(menuCat)
            
            for menuItem in subJson.arrayValue {
                let name = menuItem["name"].stringValue
                let price = menuItem["price"].stringValue
                let description = menuItem["description"].stringValue
                let obj = ["name": name, "price": price, "description": description]
                
                menuItems.append(obj)
            }
        }
    }
    
    
    func tableView(menuItemView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(menuItemView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        
        //print(indexPath.row)
        
        cell.textLabel?.text = menuItems[indexPath.row]["name"]
        
        if menuItems[indexPath.row]["price"] == nil {
            cell.backgroundColor = UIColor.blueColor()
        } else {
            cell.detailTextLabel?.text = menuItems[indexPath.row]["price"]
        }
        
        return cell
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }*/
    
}
