//
//  HomeViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/28/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if let emailText = NSUserDefaults.standardUserDefaults().stringForKey("loginKey") {
            print("key: \(emailText)")
            
            let keychain = KeychainSwift()
            let token = keychain.get(emailText)
            print("id: \(token!)")
            
            self.performSegueWithIdentifier("loadRestoView", sender: self)
            //self.performSegueWithIdentifier("loadSignInView", sender: self)
            
        } else {
            print("no key")
            self.performSegueWithIdentifier("loadSignInView", sender: self)
        }

    }

}
