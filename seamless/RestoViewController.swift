//
//  RestoViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 1/2/16.
//  Copyright © 2016 Shibani Mookerjee. All rights reserved.
//

import UIKit

class RestoViewController: UIViewController {
    
    var receivedCellIndex = 0
    var receivedCellName = ""
    
    var zips = [[String: String]]()

    @IBOutlet weak var restoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Sent by \(receivedCellName) at \(receivedCellIndex)")
        restoLabel.text = receivedCellName
        
        //print(JsonFeed.JSONData)
        
        parseDetailJSON(JsonFeed.JSONData)
        print(zips)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseDetailJSON(json: JSON) {
        for resto in json.arrayValue {
            let name = resto["name"].stringValue
            if name == receivedCellName {
                let zip = resto["zip"].stringValue
                let obj = ["name": name, "zip": zip]
                zips.append(obj)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
