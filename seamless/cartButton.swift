//
//  cartButton.swift
//  seamless
//
//  Created by Shibani Mookerjee on 4/26/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit
//import Foundation

class cartButton: UIButton {
    
    var price_string:String = String(format: "\u{00a0}\u{00a0}$ %.2f", CartViewController().totalAmt)
        
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        // self.layer.cornerRadius = 5.0;
        // self.layer.borderColor = UIColor.redColor().CGColor
        // self.layer.borderWidth = 1.5
        // self.backgroundColor = UIColor.blueColor()
        // self.tintColor = UIColor.whiteColor()
        
        //self.setFAIcon(FAType.FAShoppingCart, iconSize: 35, forState: .Normal)
        
        self.setFAText(prefixText: "", icon: FAType.FAShoppingCart, postfixText: price_string, size: 25, forState: .Normal, iconSize: 35)
        
        self.setFATitleColor(UIColor.redColor(), forState: .Normal)
        
    }
    
}

