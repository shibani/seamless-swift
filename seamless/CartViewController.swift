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
    
    var totalAmt:Double = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cartView.dataSource = self
        cartView.delegate = self
        
        cartTotalLabel.text = String(format: "\u{00a0}\u{00a0}$ %.2f", totalAmt)

        self.cartView.reloadData()
    }
    
    func tableView(cartView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return shoppingCartItemsArray.count
    }
    
    
    func tableView(cartView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = cartView.dequeueReusableCellWithIdentifier("cartViewCell", forIndexPath: indexPath) as! cartViewCell
        
        cell.name.text = shoppingCartItemsArray[indexPath.row].name
        cell.price.text = shoppingCartItemsArray[indexPath.row].price
        cell.desc.text = shoppingCartItemsArray[indexPath.row].text
        
        //cell.textLabel?.text = shoppingCartItemsArray[indexPath.row].name
        //cell.detailTextLabel?.text = shoppingCartItemsArray[indexPath.row].text
        return cell
    }
}
