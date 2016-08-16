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
            let userInfoText = NSUserDefaults.standardUserDefaults().stringForKey("userInfo")
            print("key: \(emailText)")
            print("userInfo: \(userInfoText)")
            
            if userInfoText == "true"{
                print("key: \(emailText)")
                
                let keychain = KeychainSwift()
                let token = keychain.get(emailText)
                print("id: \(token!)")
                
                self.performSegueWithIdentifier("loadRestoView", sender: self)
                //self.performSegueWithIdentifier("loadSignInView", sender: self)
            } else {
                //self.performSegueWithIdentifier("loadRestoView", sender: self)
                self.performSegueWithIdentifier("loadUserInfoView", sender: self)
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                
                /*if let emailText = userDefaults.stringForKey("loginKey") {
                    
                    let keychain = KeychainSwift()
                    keychain.delete(emailText)
                    
                    userDefaults.removeObjectForKey("loginKey")
                    userDefaults.removeObjectForKey("userInfo")
                    userDefaults.removeObjectForKey("username")
                    userDefaults.removeObjectForKey("userId")
                    userDefaults.removeObjectForKey("usernameUrl")
                    userDefaults.synchronize()
                }*/
            }
            
        } else {
            print("no key")
            self.performSegueWithIdentifier("loadSignInView", sender: self)
        }

    }

}
