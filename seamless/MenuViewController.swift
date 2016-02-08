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
    
    var zips = [[String: String]]()
    
    var restoData = NSMutableData()
    
    var restoJSONData:JSON = ""
    
    var menuItemsArray = [[String: String]]()

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
                
                print(restoJSONData)
            }
        }
        
        menuItemView.dataSource = self
        
        menuItemView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseMenuJSON(json: JSON) {
        menuItemsArray = []
        for menuItem in json.arrayValue {
            let name = menuItem["name"].stringValue
            let price = menuItem["price"].stringValue
            let description = menuItem["description"].stringValue
            let obj = ["name": name, "price": price, "description": description]
            menuItemsArray.append(obj)
        }
    }
    
    
    func tableView(menuItemView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsArray.count
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
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }*/
    
}
