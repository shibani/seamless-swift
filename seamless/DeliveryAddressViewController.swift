//
//  DeliveryAddressViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 7/24/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class DeliveryAddressViewController: UIViewController {
    
    @IBOutlet weak var editAddressBtn: UIButton!

    @IBOutlet weak var newAddressBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBAction func editAddressBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("loadEditAddressView", sender: self)
    }
    
    @IBAction func newAddressBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("loadNewAddressView", sender: self)
    }
    
    @IBAction func continueBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("loadUserAcctView", sender: self)
    }
}
