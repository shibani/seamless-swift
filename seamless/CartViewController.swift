//
//  CartViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 4/17/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

var shoppingCartItemsArray:[CartItem] = []

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cartView: UITableView!
    
    @IBOutlet weak var cartTotalLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        cartView.dataSource = self
        cartView.delegate = self
        
        cartTotalLabel.text = Helper.totalAmtText()
        
        self.cartView.reloadData()
        
        self.titleLabel.text = "Your Order: " + shoppingCartItemsArray[0].restaurant
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
}
