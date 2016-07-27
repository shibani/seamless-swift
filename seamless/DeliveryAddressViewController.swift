//
//  DeliveryAddressViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 7/24/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class DeliveryAddressViewController: UIViewController, NSURLConnectionDataDelegate  {
    
    var err: NSError?
    
    @IBOutlet weak var editAddressBtn: UIButton!

    @IBOutlet weak var newAddressBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.stringForKey("username")
        let userId = defaults.stringForKey("userId")
        let emailText = defaults.stringForKey("loginKey")
        
        let keychain = KeychainSwift()
        let token = keychain.get(emailText!)
        print("id: \(token!)")
        
        let jsonEmail: String = emailText!
        let jsonToken: String = token!
        
        print("username: \(username!)")
        print("userId: \(userId!)")
        print("jsonEmail: \(jsonEmail)")
        print("jsonToken: \(jsonToken)")
        
        //let urlString = "https://sm-seamless.herokuapp.com/json/\(userId)/\(username)"
        let urlString = "http://localhost:3030/json/\(userId!)/\(username!)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let params = [
            "user" : [
                "email" : jsonEmail,
                "token" : jsonToken
            ]
        ]
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params as [String: Dictionary], options:NSJSONWritingOptions.PrettyPrinted)
            
        } catch {
            print("error serializing JSON 1: \(error)")
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (response as? NSHTTPURLResponse != nil) {
                //returning from server
                do{
                    let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    
                    print("coming from server: \(responseJSON)")
                    
                    /*let firstname = responseJSON["firstname"]!
                    let lastname = responseJSON["lastname"]!
                    let address1 = responseJSON["address1"]!
                    let address2 = responseJSON["address2"]!
                    let city = responseJSON["city"]!
                    let state = responseJSON["state"]!
                    let zip = responseJSON["zip"]!
                    let primary_phone = responseJSON["primary_phone"]!*/
                    
                }catch{
                    print("error serializing JSON2: \(error)")
                }
                
                if(self.err != nil) {
                    print(self.err!.localizedDescription)
                }
            }
        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
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
