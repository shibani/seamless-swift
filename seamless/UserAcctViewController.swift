//
//  UserAcctViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 7/24/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class UserAcctViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("item: \(shoppingCartItemsArray[0].name)")
        print("address: \(deliveryAddress)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
