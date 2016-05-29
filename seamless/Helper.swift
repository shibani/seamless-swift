//
//  Helper.swift
//  seamless
//
//  Created by Shibani Mookerjee on 5/2/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit
import Foundation

var totalAmt:Double = 0.00

class Helper{
    
    static func dblToFormattedPrice(double: Double) -> String{
        return String(format: "\u{00a0}\u{00a0}$ %.2f", double)
    }
    
    static func totalAmtText() -> String {
        return String(format: "\u{00a0}\u{00a0}$ %.2f", totalAmt)
    }
    
    static func menuItemPriceDouble(mip:String) -> Double {
        let s: String = mip
        let index: String.Index = s.startIndex.advancedBy(1)
        let finalString:String = s.substringFromIndex(index)
        let replaceTrimmed = finalString.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let finalDouble = Double(replaceTrimmed)
        
        return finalDouble!
    }
}
