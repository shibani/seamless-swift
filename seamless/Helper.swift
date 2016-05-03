//
//  Helper.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/2/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import Foundation

var totalAmt:Double = 0.00

class Helper{
    
    static func totalAmtText() -> String {
        return String(format: "\u{00a0}\u{00a0}$ %.2f", totalAmt)
    }
}
