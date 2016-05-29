//
//  SignUpViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/28/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func signUpBtnClicked(sender: AnyObject) {
        //if signup credentials validate
        self.performSegueWithIdentifier("loadRestoView", sender: self)
    }
}

