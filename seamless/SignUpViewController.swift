//
//  SignUpViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/28/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.placeholder = "Enter username"
        username.textColor = UIColor.lightGrayColor()
        username.font = UIFont.italicSystemFontOfSize(13)
        username.delegate = self
        
        password.placeholder = "Enter password"
        password.secureTextEntry = true
        password.textColor = UIColor.lightGrayColor()
        password.font = UIFont.italicSystemFontOfSize(13)
        password.delegate = self
        
        /*confirmPassword.placeholder = "Confirm password"
        confirmPassword.secureTextEntry = true
        confirmPassword.textColor = UIColor.lightGrayColor()
        confirmPassword.font = UIFont.italicSystemFontOfSize(13)
        confirmPassword.delegate = self*/
        
        email.placeholder = "Enter email"
        email.textColor = UIColor.lightGrayColor()
        email.font = UIFont.italicSystemFontOfSize(13)
        email.delegate = self
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
    
    @IBAction func signUpBtnClicked(sender: AnyObject) {
        //if signup credentials validate
        self.performSegueWithIdentifier("loadRestoView", sender: self)
    }
}

