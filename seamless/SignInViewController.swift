//
//  SignInViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/28/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
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
    
    @IBAction func signInBtnClicked(sender: AnyObject) {
        //if signin credentials validate
        self.performSegueWithIdentifier("loadRestoView", sender: self)
    }
    
    @IBAction func signUpBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("loadSignUpView", sender: self)
    }
}
