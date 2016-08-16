//
//  UserViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/23/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit
import Foundation

class NewAddressViewController: UIViewController, UITextFieldDelegate {
    
    var err: NSError?
    
    var valid:Bool = true
    
    @IBOutlet weak var userBtn: UIButton!

    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var aptField: UITextField!
    
    @IBOutlet weak var cityField: UITextField!
    
    @IBOutlet weak var stateField: UITextField!
    
    @IBOutlet weak var crossStreetField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var deliveryInstructions: UITextField!
    
    @IBOutlet weak var placeLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.firstName.delegate = self;
        self.lastName.delegate = self;
        self.addressField.delegate = self;
        self.aptField.delegate = self;
        self.cityField.delegate = self;
        self.stateField.delegate = self;
        self.crossStreetField.delegate = self;
        self.phoneField.delegate = self;
        self.deliveryInstructions.delegate = self;
        self.placeLabel.delegate = self;
        
        self.firstName.autocorrectionType = UITextAutocorrectionType.No
        self.firstName.autocapitalizationType = UITextAutocapitalizationType.None
        
        self.lastName.autocorrectionType = UITextAutocorrectionType.No
        self.lastName.autocapitalizationType = UITextAutocapitalizationType.None
        
        self.addressField.autocorrectionType = UITextAutocorrectionType.No
        self.addressField.autocapitalizationType = UITextAutocapitalizationType.None
        
        self.aptField.autocorrectionType = UITextAutocorrectionType.No
        self.aptField.autocapitalizationType = UITextAutocapitalizationType.None
        
        self.cityField.autocorrectionType = UITextAutocorrectionType.No
        self.cityField.autocapitalizationType = UITextAutocapitalizationType.None
        
        self.stateField.autocorrectionType = UITextAutocorrectionType.No
        self.stateField.autocapitalizationType = UITextAutocapitalizationType.None
        
        self.crossStreetField.autocorrectionType = UITextAutocorrectionType.No
        self.crossStreetField.autocapitalizationType = UITextAutocapitalizationType.None
        
        self.phoneField.autocorrectionType = UITextAutocorrectionType.No
        self.phoneField.autocapitalizationType = UITextAutocapitalizationType.None
        
        self.deliveryInstructions.autocorrectionType = UITextAutocorrectionType.No
        self.deliveryInstructions.autocapitalizationType = UITextAutocapitalizationType.None
        
        self.placeLabel.autocorrectionType = UITextAutocorrectionType.No
        self.placeLabel.autocapitalizationType = UITextAutocapitalizationType.None
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func userBtnClicked(sender: UIButton) {
        
        var invalidFields:String = ""
        
        let firstname = self.firstName.text
        let lastname = self.lastName.text
        let address = self.addressField.text
        let apt = self.aptField.text
        let city = self.cityField.text
        let state = self.stateField.text
        let crossStreet = self.crossStreetField.text
        let phone = self.phoneField.text
        let instructions = self.deliveryInstructions.text
        let placeType = self.placeLabel.text
        
        // Validate the text fields
        if firstname!.characters.count < 2 {
            valid = false
            invalidFields += "First name"
        }
        
        if lastname!.characters.count < 2 {
            valid = false
            invalidFields += ", Last name"
        }
        
        if address!.characters.count < 5 {
            valid = false
            invalidFields += ", Address"
        }
        
        if city!.characters.count < 3 {
            valid = false
            invalidFields += ", City"
        }
        
        if state!.characters.count < 2 {
            valid = false
            invalidFields += ", State"
        }
        
        if phone!.characters.count < 10 {
            valid = false
            invalidFields += ", Phone"
        }
        
        if placeType!.characters.count < 2 {
            valid = false
            invalidFields += ", Place label"
        }
        
        if (!valid){
            let alert = UIAlertController(title: "Order cannot be submitted", message: "Please fix the following fields before proceeding: " + invalidFields, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
           print("valid")
           //post to url here
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let emailText = defaults.stringForKey("loginKey")
            
            let keychain = KeychainSwift()
            let token = keychain.get(emailText!)
            print("id: \(token!)")
            
            let jsonEmail: String = emailText!
            let jsonToken: String = token!
            
            let jsonFirstname :String = firstname!
            let jsonLastname :String = lastname!
            let jsonAddress :String = address!
            let jsonCity :String = city!
            let jsonState :String = state!
            let jsonCrossStreet :String = crossStreet!
            let jsonPhone :String = phone!
            let jsonInstruction :String = instructions!
            let jsonPlaceType :String = placeType!
            
            print("jsonEmail: \(jsonEmail)")
            print("jsonToken: \(jsonToken)")
        
            
            let string = "https://sm-seamless.herokuapp.com/add_address"
            //let string = "http://localhost:3030/add_address"
            let url = NSURL(string: string)
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let params = [
                "user" : [
                    "email" : jsonEmail,
                    "token" : jsonToken
                ],
                "address" : [
                    "firstname" : jsonFirstname,
                    "lastname" : jsonLastname,
                    "address" : jsonAddress,
                    "city" : jsonCity,
                    "state" : jsonState,
                    "cross_street" : jsonCrossStreet,
                    "phone" : jsonPhone,
                    "instructions" : jsonInstruction,
                    "place_type" : jsonPlaceType
                ]
            ]
            
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options:NSJSONWritingOptions.PrettyPrinted)
            }
            catch {
                print("error serializing JSON: \(error)")
            }
            
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                if (response as? NSHTTPURLResponse != nil) {
                    do{
                        let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        
                        print(responseJSON)
                        print(responseJSON["message"]! as? (String))
                        
                        if responseJSON["message"]! as? (String) == "success" {
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                let alert = UIAlertController(title: "Thanks", message: "Delivery address successfully added!", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                                    print("Handle Ok logic here")
                                    
                                    defer {
                                        dispatch_async( dispatch_get_main_queue(),{
                                        
                                            orderDetails["deliveryAddress"] = jsonPlaceType
                                        self.performSegueWithIdentifier("loadUserAcctDetailsView", sender: self)
                                        })
                                    }
                                })
                                )
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        
                        } else{
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                let alert = UIAlertController(title: "Oops, something went wrong!", message: "Please re-enter your address info again", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                                    print("Handle Ok logic here")
                                })
                                )
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                        
                    } catch {
                        print("error serializing JSON2: \(error)")
                    }
                    
                    if(self.err != nil) {
                        print(self.err!.localizedDescription)
                        //show these errors
                    }
                }
            }
            
            task.resume()
        }
    }
}
