//
//  SignInViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/28/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        //username.text = "Enter username"
        username.placeholder = "Enter username"
        username.textColor = UIColor.lightGrayColor()
        username.font = UIFont.italicSystemFontOfSize(13)
        username.delegate = self
        
        //password.text = "Enter password"
        password.placeholder = "Enter password"
        password.secureTextEntry = true
        password.textColor = UIColor.lightGrayColor()
        password.font = UIFont.italicSystemFontOfSize(13)
        password.delegate = self
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
            //textField.text = "Enter username"
            textField.textColor = UIColor.lightGrayColor()
            textField.font = UIFont.italicSystemFontOfSize(13)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func signInBtnClicked(sender: AnyObject) {
        //if signin credentials validate
        self.performSegueWithIdentifier("loadRestoView", sender: self)
    }
    
    @IBAction func signUpBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("loadSignUpView", sender: self)
    }
}
