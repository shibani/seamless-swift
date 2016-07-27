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
    
    var err: NSError?
    
    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confPassword: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.placeholder = "Enter username"
        username.textColor = UIColor.lightGrayColor()
        username.font = UIFont.italicSystemFontOfSize(13)
        username.autocorrectionType = UITextAutocorrectionType.No
        username.autocapitalizationType = UITextAutocapitalizationType.None
        username.delegate = self
        
        password.placeholder = "Enter password"
        password.secureTextEntry = true
        password.textColor = UIColor.lightGrayColor()
        password.font = UIFont.italicSystemFontOfSize(13)
        password.delegate = self
        
        confPassword.placeholder = "Confirm password"
        confPassword.secureTextEntry = true
        confPassword.textColor = UIColor.lightGrayColor()
        confPassword.font = UIFont.italicSystemFontOfSize(13)
        confPassword.delegate = self
        
        email.placeholder = "Enter email"
        email.textColor = UIColor.lightGrayColor()
        email.font = UIFont.italicSystemFontOfSize(13)
        email.autocorrectionType = UITextAutocorrectionType.No
        email.autocapitalizationType = UITextAutocapitalizationType.None
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
        let confPasswordText: String = confPassword.text!
        let emailText: String = email.text!
        
        
        if usernameText.characters.count < 2 {
            valid = false
            invalidFields += "\n\nUsername must be longer than 2 characters"
        }
        
        if passwordText.characters.count < 8 {
            valid = false
            invalidFields += "\n\nPassword must be greater than 8 characters"
        }
        
        if confPasswordText != passwordText {
            valid = false
            invalidFields += "\n\nPasswords do not match"
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
            //post to url here
            
            //let string = "https://sm-seamless.herokuapp.com/users"
            let string = "http://localhost:3030/users"
            let url = NSURL(string: string)
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
           
            let params = [ "user" : ["email" : emailText, "username" : usernameText, "password" : passwordText, "password_confirmation" : confPasswordText] ]
            
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options:NSJSONWritingOptions.PrettyPrinted)
            }
            catch {
                print("error serializing JSON: \(error)")
            }
            
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                if (response as? NSHTTPURLResponse != nil) {
                
                    //let code = answer.statusCode
                    
                    //let responseString: String = String(data: data!, encoding: NSUTF8StringEncoding)!
                    
                    do{
                        let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        if let userId = responseJSON["user_id"] as? (String){
                            print("User: \(userId)")
                        
                            let keychain = KeychainSwift()
                            keychain.set(userId, forKey: emailText)
                        
                            //set NSUserDefaults to say loginKey = true
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(emailText, forKey: "loginKey")
                            defaults.setObject(usernameText, forKey: "username")
                        
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                
                                self.performSegueWithIdentifier("loadUserInfoView", sender: self)
                            }
                        /*} else if let errors = responseJSON["errors"] as? (String){*/
                        } else {
                            print(responseJSON)
                            //parse this JSON properly
                            //print("Error: \(errors)")
                            //response from server
                            /*{
                                errors =     {
                                    email =         (
                                        "has already been taken"
                                    );
                                };
                            }*/

                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                let alert = UIAlertController(title: "Account sign up failed", message: "Your account could not be created, please try again", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                        
                    } catch{
                        print("error serializing JSON2: \(error)")
                    }
                    
                    if(self.err != nil) {
                        print(self.err!.localizedDescription)
                        //show these error
                    }
                }
            }
            
            task.resume()
        }
    }
}
