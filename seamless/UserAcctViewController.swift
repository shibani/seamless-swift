//
//  UserAcctViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 7/24/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class UserAcctViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var ccNum: UITextField!
    
    @IBOutlet weak var ccExp: UITextField!
    
    @IBOutlet weak var ccCVV: UITextField!
    
    @IBOutlet weak var ccName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("item: \(shoppingCartItemsArray[0].name)")
        print("address: \(deliveryAddress)")
        
        ccNum.placeholder = "Enter Credit Card Number"
        ccNum.textColor = UIColor.lightGrayColor()
        ccNum.font = UIFont.italicSystemFontOfSize(13)
        ccNum.autocorrectionType = UITextAutocorrectionType.No
        ccNum.autocapitalizationType = UITextAutocapitalizationType.None
        ccNum.delegate = self
        
        ccExp.placeholder = "MM-DD-YYYY"
        ccExp.textColor = UIColor.lightGrayColor()
        ccExp.font = UIFont.italicSystemFontOfSize(13)
        ccExp.autocorrectionType = UITextAutocorrectionType.No
        ccExp.autocapitalizationType = UITextAutocapitalizationType.None
        ccExp.delegate = self
        
        ccCVV.placeholder = "Enter CVV"
        ccCVV.textColor = UIColor.lightGrayColor()
        ccCVV.font = UIFont.italicSystemFontOfSize(13)
        ccCVV.autocorrectionType = UITextAutocorrectionType.No
        ccCVV.autocapitalizationType = UITextAutocapitalizationType.None
        ccCVV.delegate = self
        
        ccName.placeholder = "Name as it appears on the card"
        ccName.textColor = UIColor.lightGrayColor()
        ccName.font = UIFont.italicSystemFontOfSize(13)
        ccName.autocorrectionType = UITextAutocorrectionType.No
        ccName.autocapitalizationType = UITextAutocapitalizationType.None
        ccName.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        textField.textColor = UIColor.blackColor()
        textField.font = UIFont.systemFontOfSize(13)
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        if textField.text!.isEmpty {
            textField.textColor = UIColor.lightGrayColor()
            textField.font = UIFont.italicSystemFontOfSize(13)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func saveBtnClicked(sender: AnyObject) {
        print("save btn clicked!")
    }

}
