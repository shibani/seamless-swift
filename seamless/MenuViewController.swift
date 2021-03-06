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
    
    var chosenCellSection = 0
    
    var rowNumber = 0
    
    var chosenCellName = ""
    
    var chosenCellDescription = ""
    
    var chosenCellPrice = ""
    
    var zips = [[String: String]]()
    
    var restoData = NSMutableData()
    
    var restoJSONData:JSON = ""
    
    var menuItemsArray = [[String: String]]()
    
    var subMenuItemsArray = [[String: String]]()
    
    var sectionItemsArray = [[String: String]]()
    
    var sectionCount = 0
    
    var itemCount = 0

    var row = 0

    @IBOutlet weak var restoLabel: UILabel!
    
    @IBOutlet weak var menuItemView: UITableView!
    
    @IBOutlet weak var cartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print("Sent by \(receivedCellName) at \(receivedCellIndex)")
        restoLabel.text = receivedCellName
        
        let escapedString = receivedCellName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let urlString = "https://sm-seamless.herokuapp.com/restaurants/\(escapedString!)"
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        updateCartButton()
        
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
            let section = menuItem["section"].stringValue
            if price == "" && description == "" {
                let header_obj = ["name": name]
                sectionItemsArray.append(header_obj)
            } else {
                let obj = ["name": name, "price": price, "description": description, "section":section]
                menuItemsArray.append(obj)
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionItemsArray.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = sectionItemsArray[section].first! //this returns a tuple
        return "\(sectionTitle.1)"
    }
    
    func tableView(menuItemView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        for var i = 0; i < sectionItemsArray.count ; ++i {
            
            if section == i {
                
                //print("mit: section \(i): \(sectionItemsArray[i].first!.1)")
                //itemCount = [menuItemsArray[i]["section"]! == sectionItemsArray[section].first!.1].count
                //print(menuItemsArray[i]["section"]!) //works
                //print(sectionItemsArray[section].first!.1) //works
                
                itemCount = 0

                for var j = 0; j < menuItemsArray.count ; ++j {
                    
                    if menuItemsArray[j]["section"]! == sectionItemsArray[i].first!.1 {
                        itemCount += 1
                    }
                }
                
                //itemCount = 2
                //print(itemCount)
            }
        }
        
        return itemCount
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blueColor()
        header.textLabel?.textColor = UIColor.whiteColor() //make the text white
        //header.alpha = 0.5 //make the header transparent
    }
    
    func tableView(menuItemView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = menuItemView.dequeueReusableCellWithIdentifier("MenuTableViewCell", forIndexPath: indexPath) as! MenuTableViewCell
        
        
        for var i = 0; i < sectionItemsArray.count ; ++i {
            
            if indexPath.section == i {
                
                subMenuItemsArray = []
                
                for var j = 0; j < menuItemsArray.count ; ++j {
                    
                    if menuItemsArray[j]["section"]! == sectionItemsArray[indexPath.section].first!.1 {
                        
                        subMenuItemsArray.append(menuItemsArray[j])
                    }
                }
                
                //print(subMenuItemsArray.count)
                
                cell.menuItemName?.text = subMenuItemsArray[indexPath.row]["name"]
                cell.menuItemPrice?.text = subMenuItemsArray[indexPath.row]["price"]
                
                cell.itemDescription = subMenuItemsArray[indexPath.row]["description"]!
                
            }
        }
        
        return cell
    }
    
    
    func tableView(menuTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = menuTableView.cellForRowAtIndexPath(indexPath) as! MenuTableViewCell
        
        chosenCellName = (selectedCell.menuItemName?.text)!
        chosenCellPrice = (selectedCell.menuItemPrice?.text)!
        
        chosenCellDescription = selectedCell.itemDescription
        
        if chosenCellPrice != "" {
        
            self.performSegueWithIdentifier("loadMenuDetailView", sender: self)
            
        }
        
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "loadMenuDetailView" {
            // get a reference to the second view controller
            let menuDetailViewController = segue.destinationViewController as! MenuDetailViewController
        
            // set a variable in the second view controller with the data to pass
            menuDetailViewController.receivedCellName = chosenCellName
            menuDetailViewController.receivedCellPrice = chosenCellPrice
            menuDetailViewController.receivedCellDescription = chosenCellDescription
            
            menuDetailViewController.receivedResto = receivedCellName
        }
    }
    
    func updateCartButton(){
        
        var cartTotal = 0.0
        
        for item in shoppingCartItemsArray{
            let price = Helper.menuItemPriceDouble(item.price)
            let qty = Double(item.qty)
            cartTotal += Double(price * qty!)
        }
        
        cartButton?.setTitle(Helper.dblToFormattedPrice(cartTotal), forState: .Normal)
        cartButton?.setImage(UIImage(named: "cart.png"), forState: .Normal)
        //print("MVCcartButtonLoaded!")
    }
    
    @IBAction func cartButtonClicked(sender: AnyObject) {
        
        self.performSegueWithIdentifier("loadShoppingCart", sender: self)
        
    }
    
}
