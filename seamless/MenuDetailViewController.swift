//
//  MenuDetailViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 2/9/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit


class MenuDetailViewController: UIViewController {
    
    var receivedCellIndex = 0
    
    var receivedCellName = ""
    
    var receivedCellDescription = ""

    var receivedCellPrice = ""

    @IBOutlet weak var menuItemName: UILabel!
    
    @IBOutlet weak var menuItemDescription: UILabel!
    
    @IBOutlet weak var menuItemPrice: UILabel!
    
    @IBOutlet weak var AddToBag: UIButton!
    
    var quantity = 0
    
    var specialInstructions = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Sent by \(receivedCellName) at \(receivedCellIndex)")
        // Do any additional setup after loading the view.
        
        menuItemName.numberOfLines = 0
        menuItemName.sizeToFit()
        menuItemName.text = "\(receivedCellName)"
        
        menuItemDescription.numberOfLines = 0
        menuItemDescription.sizeToFit()
        menuItemDescription.text = "\(receivedCellDescription)"
        
        menuItemPrice.text = "\(receivedCellPrice)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToBagTouched(sender: UIButton) {
        //print("add to bag clicked")
        
        //+1 to shopping cart badge
        //add to shopping bag element
        
        let newItem = CartItem()
        
        newItem.name = menuItemName.text!
        newItem.text = menuItemDescription.text!
        newItem.price = menuItemPrice.text!

        shoppingCartItemsArray.append(newItem)
        
    }
    
}
