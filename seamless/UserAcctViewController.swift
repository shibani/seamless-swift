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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("item: \(shoppingCartItemsArray[0].name)")
        print("address: \(deliveryAddress)")
        
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
                /*self.submitTokenToBackend(token, completion: { (error: NSError?) in
                    if let error = error {
                        // show the error to the user
                    } else {
                        // show a receipt page
                        print("success")
                    }
                })*/
                print("Got token! Token: \(token)")
                self.postStripeToken(token)
            }
        }
    }
    
    func submitTokenToBackend(token: STPToken, completion: ( ( NSError? ) -> Void) ){
        
    }
    
    func postStripeToken(token: STPToken) {
        
        
        //let URL = "https://sm-seamless.herokuapp.com/submit_token"
        let URL = "http://localhost:3030/submit_token"
        let params = ["stripeToken": token.tokenId]
        print(params)
        
        //post to rails db
        /*let params = ["stripeToken": token.tokenId,
            "amount": self.amountTextField.text.toInt()!,
            "currency": "usd",
            "description": self.emailTextField.text]*/
        
        /*let manager = AFHTTPRequestOperationManager()
        manager.POST(URL, parameters: params, success: { (operation, responseObject) -> Void in
            
            if let response = responseObject as? [String: String] {
                UIAlertView(title: response["status"],
                    message: response["message"],
                    delegate: nil,
                    cancelButtonTitle: "OK").show()
            }
            
            }) { (operation, error) -> Void in
                self.handleError(error!)
        }*/
    
    }
    
    func handleError(error: NSError) {
        let alert = UIAlertController(title: "Please Try Again", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
