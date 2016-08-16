//
//  CartViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 4/17/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

var shoppingCartItemsArray:[CartItem] = []
var deliveryAddress :String = "acct_primary"
var cartFinalAmt :Double = 0.0
var orderDetails = [String: String]()


class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var newTotal:Double = 0.0
    
    @IBOutlet weak var cartView: UITableView!
    
    @IBOutlet weak var cartTotalLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var checkOutBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        cartView.dataSource = self
        cartView.delegate = self
        
        cartTotalLabel.text = Helper.totalAmtText()
        
        self.cartView.reloadData()
        
        if(shoppingCartItemsArray.count > 0){
            self.titleLabel.text = "Your Order: " + shoppingCartItemsArray[0].restaurant
        } else {
            self.titleLabel.text = "Your Order: cart is empty"
        }
    }
    
    func tableView(cartView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return shoppingCartItemsArray.count
    }
    
    func tableView(cartView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = cartView.dequeueReusableCellWithIdentifier("cartViewCell", forIndexPath: indexPath) as! CartViewCell
        
        let price = Helper.menuItemPriceDouble(shoppingCartItemsArray[indexPath.row].price)
        let qty = Double(shoppingCartItemsArray[indexPath.row].qty)
        
        cell.name?.text = shoppingCartItemsArray[indexPath.row].name
        cell.desc?.text = shoppingCartItemsArray[indexPath.row].desc
        cell.qty?.text = shoppingCartItemsArray[indexPath.row].qty
        
        let itemTotal = Double(price * qty!)
        
        cell.itemTotalPrice?.text = String(format: "$ %.2f", itemTotal)
        if(qty > 1.0){
            cell.price?.text = String(format: "$ %.2f ea.", price)
        } else {
            cell.price?.text = ""
        }
        
        //cell.textLabel?.text = shoppingCartItemsArray[indexPath.row].name
        //cell.detailTextLabel?.text = shoppingCartItemsArray[indexPath.row].desc
        return cell
    }
    
    func tableView(cartView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            shoppingCartItemsArray.removeAtIndex(indexPath.row)
            cartView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            cartView.reloadData()
            
            for item in shoppingCartItemsArray{
                let price = Helper.menuItemPriceDouble(item.price)
                let qty = Double(item.qty)
                newTotal += Double(price * qty!)
            }
            //update total price
            cartTotalLabel.text = String(format: "$ %.2f", newTotal)
        }
    }
    
    @IBAction func checkOutBtnClicked(sender: AnyObject) {
        
        for item in shoppingCartItemsArray{
            let price = Helper.menuItemPriceDouble(item.price)
            let qty = Double(item.qty)
            newTotal += Double(price * qty!)
        }
        
        cartFinalAmt += newTotal
        
        //each shopping cart item has the resto name in line item to check if
        //the user was adding from the same restaurant
        //orderDetails["restoName"] = shoppingCartItemsArray[0].restaurant
        
        orderDetails["cartFinalAmt"] = String(format: "%.2f", newTotal)
        orderDetails["deliveryAddress"] = "acct_primary"
        orderDetails["orderTax"] = String(format: "%.2f", 3.25)
        orderDetails["orderTip"] = String(format: "%.2f", 2.25)
        
        print("newTotal: \(newTotal)")
        
        self.performSegueWithIdentifier("loadAddressView", sender: self)
    }
}
