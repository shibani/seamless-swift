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
    
    @IBOutlet weak var saveMyInfo: DLRadioButton!
    
    //var newTotal:Double = 0.0
    
    var totalString :String = ""
    
    var err: NSError?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.getCardsList()
        
        let deliveryAddress = orderDetails["deliveryAddress"]
        let cartFinalAmt = orderDetails["cartFinalAmt"]
        
        print("resto name: \(shoppingCartItemsArray[0].restaurant)")
        print("address: \(deliveryAddress)")
        print("totalAmt: \(cartFinalAmt)")
        
        var orderItems : [String : Array<String>] = Dictionary()
        
        for var i = 0; i < shoppingCartItemsArray.count ; ++i {
            let name = shoppingCartItemsArray[i].name
            let qty = shoppingCartItemsArray[i].qty
            let price = shoppingCartItemsArray[i].price
            
            orderItems[name] = [qty, price]
        }
        
        print ("orderItems1: \(orderItems)")
        
        ccNum.placeholder = "Enter Credit Card Number"
        ccNum.textColor = UIColor.lightGrayColor()
        ccNum.font = UIFont.italicSystemFontOfSize(13)
        ccNum.autocorrectionType = UITextAutocorrectionType.No
        ccNum.autocapitalizationType = UITextAutocapitalizationType.None
        ccNum.delegate = self
        
        ccExp.placeholder = "MM/YYYY"
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
        
        // Initiate the card
        let cardParams = STPCardParams()
        
        // Split the expiration date to extract Month & Year
        if self.ccExp.text!.isEmpty == false {
            let expDate = self.ccExp.text!.componentsSeparatedByString("/")
            let expMonth = UInt(expDate[0])
            let expYear = UInt(expDate[1])
            //let expMonth = Int(UInt(expDate[0])!)
            //let expYear = Int(UInt(expDate[1])!)
            
            // Send the card info to Strip to get the token
            cardParams.number = self.ccNum.text
            cardParams.cvc = self.ccCVV.text
            cardParams.expMonth = expMonth!
            cardParams.expYear = expYear!
        }
        
        STPAPIClient.sharedClient().createTokenWithCard(cardParams) { (token, error) in
            if let error = error {
                // show the error to the user
                print(error)
            } else if let token = token {
                print("Got token! Token: \(token)")
                self.postStripeToken(token)
            }
        }
    }
    
    func postStripeToken(token: STPToken) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let emailText = defaults.stringForKey("loginKey")
        
        let keychain = KeychainSwift()
        let userId = keychain.get(emailText!)
        print("id: \(userId!)")
        
        let string = "https://sm-seamless.herokuapp.com/submit_token"
        //let string = "http://localhost:3030/submit_token"
        
        let deliveryLoc = orderDetails["deliveryAddress"]!
        //parse shopping cart here
        //for items in shopping cart print item.name, item.qty and item.price.
        
        //var orderItems = [String: Dictionary]()
        var orderItems : [String : Array<String>] = Dictionary()
        
        for var i = 0; i < shoppingCartItemsArray.count ; ++i {
            let name = shoppingCartItemsArray[i].name
            let qty = shoppingCartItemsArray[i].qty
            let price = shoppingCartItemsArray[i].price
            
            orderItems[name] = [qty, price]
        }
        
        print ("orderItems2: \(orderItems)")
        
        //post to rails db
        let params = [
            "user" : [
                "email" : emailText!,
                "token" : userId!
            ],
            "charge" : [
                "stripeToken" : token.tokenId,
                "amount" : cartFinalAmt,
                "currency" : "usd",
                "description" : emailText!
            ],
            "orderDetails" : [
                "restoName" : shoppingCartItemsArray[0].restaurant,
                "deliveryLoc" : deliveryLoc,
                "taxAmt": orderDetails["orderTax"]!,
                "tipAmt": orderDetails["orderTip"]!
            ],
            "shoppingCart" : orderItems
        ]
        
        print(params)
        
        let url = NSURL(string: string)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params as! [String: AnyObject], options:NSJSONWritingOptions.PrettyPrinted)
            
        } catch {
            print("error serializing JSON 1: \(error)")
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (response as? NSHTTPURLResponse != nil) {
                //returning from server
                do{
                    let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    
                    print(responseJSON)
                    
                    if responseJSON["message"]! as? (String) == "success" {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            let alert = UIAlertController(title: "Thank you for your order!", message: "Your order is being processed", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                                print("Handle Ok logic here")
                                
                                defer {
                                    dispatch_async( dispatch_get_main_queue(),{
                                self.performSegueWithIdentifier("loadOrderPlacedView", sender: self)
                                    })
                                }
                            })
                            )
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    } else {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            let alert = UIAlertController(title: "Oops!", message: "Something went wrong, please try again", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                                print("Handle Ok logic here")
                            })
                            )
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                    
                }catch{
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
    
    func handleError(error: NSError) {
        let alert = UIAlertController(title: "Please Try Again", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getCardsList(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let urlString = defaults.stringForKey("usernameUrl")!
        print("\(urlString)")
        
        let emailText = defaults.stringForKey("loginKey")
        let keychain = KeychainSwift()
        let userId = keychain.get(emailText!)
        print("id: \(userId!)")
        
        let string = "https://sm-seamless.herokuapp.com/submit_token"
        //let string = "http://localhost:3030/submit_token"
        
        //post to rails db
        let params = [
            "user" : [
                "email" : emailText!,
                "token" : userId!
            ],
            
            "card" : [
                "last4" : "true"
            ]
        ]
        
        print(params)
        
        let url = NSURL(string: string)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
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
                    
                    print(responseJSON)
                    
                }catch{
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
