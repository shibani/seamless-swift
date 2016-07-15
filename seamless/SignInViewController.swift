//
//  SignInViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/28/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    var valid:Bool = true
    
    var err: NSError?
    
    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        //username.text = "Enter username"
        username.placeholder = "Enter email"
        username.textColor = UIColor.lightGrayColor()
        username.font = UIFont.italicSystemFontOfSize(13)
        username.autocorrectionType = UITextAutocorrectionType.No
        username.autocapitalizationType = UITextAutocapitalizationType.None
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
        
        let emailText: String = username.text!
        let passwordText: String = password.text!
        
        //no validation necessary, just submit to server and do the checks there
        //let string = "https://sm-seamless.herokuapp.com/users"
        let string = "http://localhost:3030//users/sign_in"
        let url = NSURL(string: string)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
            
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
            
        let params = ["user" : ["email" : emailText, "password" : passwordText ] ]
            
        print(params)
            
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options:NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print("error serializing JSON 1: \(error)")
        }
            
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                
            if (response as? NSHTTPURLResponse != nil) {
                do{
                    let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        
                    print("server response: \(responseJSON)")
                    
                    if let userId = responseJSON["user_id"] as? (String){
                        
                        if NSUserDefaults.standardUserDefaults().objectForKey("userInfo") != nil{
                            print("User: \(userId)")
                        
                            let keychain = KeychainSwift()
                            keychain.set(userId, forKey: emailText)
                        
                            //set NSUserDefaults to say loginKey = true
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(emailText, forKey: "loginKey")
                        
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.performSegueWithIdentifier("loadRestoView", sender: self)
                            }
                        } else {
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.performSegueWithIdentifier("loadUserInfoView", sender: self)
                            }
                        }
                    
                    } else if let errors = responseJSON["errors"] as? (String){
                        print("Error: \(errors)")
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            let alert = UIAlertController(title: "Account sign in failed", message: "Please try again", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                    
                } catch {
                    print("error serializing JSON 2: \(error)")
                }
                    
                if(self.err != nil) {
                    print(self.err!.localizedDescription)
                }
            }
        }
            
        task.resume()
    }
    
    @IBAction func signUpBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("loadSignUpView", sender: self)
    }
}