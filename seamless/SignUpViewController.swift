//
//  SignUpViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/28/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var valid:Bool = true
    
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
        
        var invalidFields: String = ""
        
        let usernameText: String = username.text!
        let passwordText: String = password.text!
        let emailText: String = email.text!
        let formText: String = "remote_signup"
        
        if usernameText.characters.count < 2 {
            valid = false
            invalidFields += "\n\nUsername must be longer than 2 characters"
        }
        
        if passwordText.characters.count < 8 {
            valid = false
            invalidFields += "\n\nPassword must be greater than 8 characters"
        }
        
        if !Helper.validateEmail(emailText){
            valid = false
            invalidFields += "\n\nEmail is invalid"
        }
        
        if (!valid){
            let alert = UIAlertController(title: "Signup failed", message: "Please fix the following fields\nbefore proceeding: " + invalidFields, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            print("valid")
            //self.performSegueWithIdentifier("loadRestoView", sender: self)
            //post to url here
            
            let myUrl = NSURL(string: "https://sm-seamless.herokuapp.com/signup");
            let request = NSMutableURLRequest(URL:myUrl!);
            request.HTTPMethod = "POST";
            
            let postString = "email=\(emailText)&name=\(usernameText)&password=\(passwordText)&form=\(formText)";
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error in
                
                if error != nil{
                    print("error=\(error)")
                    return
                }
                
                //print out response object
                print("***** response = \(response)");
                
                //print out response body
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("***** response date = \(responseString)");
                
                var err: NSError?
            }
            
            task.resume()
        }
    }
}

