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
        
        var invalidFields: String = ""
        
        let emailText: String = username.text!
        let passwordText: String = password.text!
        
        if !Helper.validateEmail(emailText){
            valid = false
            invalidFields = "Email is invalid"
        }
        
        if (!valid){
            let alert = UIAlertController(title: "Signup failed", message: "Please fix the following fields\nbefore proceeding: " + invalidFields, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            //post to url here
            
            //let string = "https://sm-seamless.herokuapp.com/users"
            let string = "http://localhost:3000//users/sign_in"
            let url = NSURL(string: string)
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let params = ["user" : ["email" : emailText, "password" : passwordText] ]
            
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options:NSJSONWritingOptions.PrettyPrinted)
            }
            catch {
                print("error serializing JSON 1: \(error)")
            }
            
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let answer = response as? NSHTTPURLResponse {
                    do{
                        let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        
                        print("server response: \(responseJSON)")
                        
                    } catch{
                        print("error serializing JSON 2: \(error)")
                    }
                    
                    if(self.err != nil) {
                        print(self.err!.localizedDescription)
                    }
                    else {
                        //alert first?
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.performSegueWithIdentifier("loadRestoView", sender: self)
                        }
                        
                    }
                }
            }
            
            task.resume()
        }
    }
    
    @IBAction func signUpBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("loadSignUpView", sender: self)
    }
}
