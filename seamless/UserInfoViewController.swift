//
//  UserInfoViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 7/13/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, UITextFieldDelegate {
    
    var valid:Bool = true
    
    var err: NSError?
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var billAddress1: UITextField!
    
    @IBOutlet weak var billAddress2: UITextField!
    
    @IBOutlet weak var billCity: UITextField!
    
    @IBOutlet weak var billState: UITextField!
    
    @IBOutlet weak var billZip: UITextField!
    
    @IBOutlet weak var primaryPhone: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        firstName.placeholder = "Enter First Name"
        firstName.textColor = UIColor.lightGrayColor()
        firstName.font = UIFont.italicSystemFontOfSize(13)
        firstName.autocorrectionType = UITextAutocorrectionType.No
        firstName.autocapitalizationType = UITextAutocapitalizationType.None
        firstName.delegate = self

        lastName.placeholder = "Enter Last Name"
        lastName.textColor = UIColor.lightGrayColor()
        lastName.font = UIFont.italicSystemFontOfSize(13)
        lastName.autocorrectionType = UITextAutocorrectionType.No
        lastName.autocapitalizationType = UITextAutocapitalizationType.None
        lastName.delegate = self
        
        billAddress1.placeholder = "Address 1"
        billAddress1.textColor = UIColor.lightGrayColor()
        billAddress1.font = UIFont.italicSystemFontOfSize(13)
        billAddress1.autocorrectionType = UITextAutocorrectionType.No
        billAddress1.autocapitalizationType = UITextAutocapitalizationType.None
        billAddress1.delegate = self
        
        billAddress2.placeholder = "Address 2"
        billAddress2.textColor = UIColor.lightGrayColor()
        billAddress2.font = UIFont.italicSystemFontOfSize(13)
        billAddress2.autocorrectionType = UITextAutocorrectionType.No
        billAddress2.autocapitalizationType = UITextAutocapitalizationType.None
        billAddress2.delegate = self

        billCity.placeholder = "City"
        billCity.textColor = UIColor.lightGrayColor()
        billCity.font = UIFont.italicSystemFontOfSize(13)
        billCity.autocorrectionType = UITextAutocorrectionType.No
        billCity.autocapitalizationType = UITextAutocapitalizationType.None
        billCity.delegate = self
        
        billState.placeholder = "State"
        billState.textColor = UIColor.lightGrayColor()
        billState.font = UIFont.italicSystemFontOfSize(13)
        billState.autocorrectionType = UITextAutocorrectionType.No
        billState.autocapitalizationType = UITextAutocapitalizationType.None
        billState.delegate = self
        
        billZip.placeholder = "Zip"
        billZip.textColor = UIColor.lightGrayColor()
        billZip.font = UIFont.italicSystemFontOfSize(13)
        billZip.autocorrectionType = UITextAutocorrectionType.No
        billZip.autocapitalizationType = UITextAutocapitalizationType.None
        billZip.delegate = self
        
        primaryPhone.placeholder = "Primary Phone: XXX-XXX-XXXX"
        primaryPhone.textColor = UIColor.lightGrayColor()
        primaryPhone.font = UIFont.italicSystemFontOfSize(13)
        primaryPhone.autocorrectionType = UITextAutocorrectionType.No
        primaryPhone.autocapitalizationType = UITextAutocapitalizationType.None
        primaryPhone.delegate = self
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
    
    @IBAction func submitBtnClicked(sender: AnyObject) {
        
        var invalidFields:String = ""
        
        let firstname = self.firstName.text
        let lastname = self.lastName.text
        let address1 = self.billAddress1.text
        let address2 = self.billAddress2.text
        let city = self.billCity.text
        let state = self.billState.text
        let zip = self.billZip.text
        let phone = self.primaryPhone.text
        
        
        if firstname!.characters.count < 2 {
            valid = false
            invalidFields += "First Name"
        }
        
        if lastname!.characters.count < 2 {
            valid = false
            invalidFields += ", Last Name"
        }
        
        if address1!.characters.count < 6 {
            valid = false
            invalidFields += ", Address 1"
        }
        
        if city!.characters.count < 2 {
            valid = false
            invalidFields += ", City"
        }
        
        if state!.characters.count < 2 {
            valid = false
            invalidFields += ", State"
        }
        
        if zip!.characters.count < 5 {
            valid = false
            invalidFields += ", Zip"
        }
        
        if phone!.characters.count < 10 {
            valid = false
            invalidFields += ", Phone"
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
            
            let params = [ "user_info" : ["email" : emailText, "username" : usernameText, "password" : passwordText, "password_confirmation" : confPasswordText] ]
            
            
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
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                let alert = UIAlertController(title: "Account created", message: "Welcome! Your account was successfully created!", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                                    print("Handle Ok logic here")
                                    
                                    defer {
                                        dispatch_async( dispatch_get_main_queue(),{
                                        //self.performSegueWithIdentifier("loadRestoView", sender: self)
                                        self.performSegueWithIdentifier("loadUserInfoView", sender: self)
                                        })
                                    }
                                })
                                )
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                            /*} else if let errors = responseJSON["errors"] as? (String){*/
                        } else {
                            print(responseJSON)
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
