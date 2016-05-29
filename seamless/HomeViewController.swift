//
//  HomeViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/28/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

var isLoggedIn:Int = 0

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
        
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("loadSignInView", sender: self)
        } else {
            //self.usernameLabel.text = prefs.valueForKey("USERNAME") as NSString
            self.performSegueWithIdentifier("loadRestoView", sender: self)
        }
    }

}
