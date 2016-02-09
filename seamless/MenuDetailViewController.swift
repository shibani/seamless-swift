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
    
    //var chosenCellIndex = 0
    //var chosenCellName = ""

    @IBOutlet weak var menuItemName: UILabel!
    
    @IBOutlet weak var menuItemDescription: UILabel!
    
    @IBOutlet weak var menuItemPrice: UILabel!
    
    @IBOutlet weak var AddToBag: UIButton!
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
