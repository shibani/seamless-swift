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
    
    var receivedResto = ""

    @IBOutlet weak var menuItemName: UILabel!
    
    @IBOutlet weak var menuItemDescription: UILabel!
    
    @IBOutlet weak var menuItemPrice: UILabel!
    
    @IBOutlet weak var menuItemQuantity: UILabel!
    
    @IBOutlet weak var menuItemTotal: UILabel!
    
    @IBOutlet weak var AddToBag: UIButton!
    
    @IBOutlet weak var stepper: UIStepper!

    
    //var quantity = 0
    
    //var specialInstructions = ""
    
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
        
        menuItemQuantity.text = "1"
        
        let a = Double(menuItemQuantity.text!)
        
        let b:Double = Helper.menuItemPriceDouble(menuItemPrice.text!)
        
        let finalTotal = (a! * b)
        
        menuItemTotal.text = String(format: "$ %.2f", finalTotal)
        
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 10
        stepper.minimumValue = 1
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepperClicked(sender: UIStepper) {
        
        menuItemQuantity.text = Int(sender.value).description
        let newTotal:Double = Double((sender.value).description)! * Helper.menuItemPriceDouble(menuItemPrice.text!)
        
        menuItemTotal.text = String(format: "$ %.2f", newTotal)
        
    }
    
    @IBAction func addToBagTouched(sender: UIButton) {
        //print("add to bag clicked")
        
        //+1 to shopping cart badge
        //add to shopping bag element
        print("Restaurant from AddToBag:  \(receivedResto)")
        
        let newItem = CartItem()
        
        newItem.name = menuItemName.text!
        newItem.desc = menuItemDescription.text!
        newItem.price = menuItemPrice.text!
        newItem.total = menuItemTotal.text!
        newItem.qty = menuItemQuantity.text!
        newItem.restaurant = receivedResto
        
        print("Count: \(shoppingCartItemsArray.count)")
        
        if(shoppingCartItemsArray.count > 0){
            
            if (shoppingCartItemsArray.first?.restaurant != newItem.restaurant){
                
                showAlertButtonTapped(self.AddToBag)
                
            } else{
                
                shoppingCartItemsArray.append(newItem)
                
                let itemPrice = Helper.menuItemPriceDouble(menuItemTotal.text!)
                totalAmt += (itemPrice)
                
                print("itemprice: \(itemPrice)")
                print("totalamt: \(totalAmt)")
                
                ViewController().updateCartButton()
                MenuViewController().updateCartButton()
                
                navigationController!.popViewControllerAnimated(true)
            }
        } else {
            shoppingCartItemsArray.append(newItem)
            
            let itemPrice = Helper.menuItemPriceDouble(menuItemTotal.text!)
            totalAmt += (itemPrice)
            
            print("itemprice: \(itemPrice)")
            print("totalamt: \(totalAmt)")
            
            ViewController().updateCartButton()
            MenuViewController().updateCartButton()
            
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func showAlertButtonTapped(sender: UIButton) {
        
        // create the alert
        let alert = UIAlertController(title: "UIAlertController", message: "Would you like to continue learning how to use iOS alerts?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
