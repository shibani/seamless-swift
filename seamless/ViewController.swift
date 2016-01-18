//
//  ViewController.swift
//  seamless
//
//  Created by Shibani Mookerjee on 12/28/15.
//  Copyright © 2015 Shibani Mookerjee. All rights reserved.
//
import UIKit

struct JsonFeed {
    static var JSONData:JSON = ""
}

class ViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate, NSURLConnectionDataDelegate {
    
    var manager: OneShotLocationManager?
    //CLLocationManagerDelegate, CLLocationManager
    
    lazy var data = NSMutableData()
    
    var restos = [[String: String]]()
    
    var chosenCellIndex = 0
    
    var chosenCellName = ""
    
    /*var sortedKeys:[String:String] = [
        "Rest-0":"Burgers, Hotdogs",
        "Rest-1":"Pizza",
        "Rest-2":"Chinese",
        "Rest-3":"Indian",
        "Rest-4":"Coffee",
        "Rest-5":"Italian",
        "Rest-6":"American",
        "Rest-7":"Pizza",
        "Rest-8":"Chinese",
        "Rest-9":"Sushi"
    ]*/
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            
            // fetch location or an error
            if let loc = location {
                print("location: \(loc)")
            } else if let err = error {
                print(err.localizedDescription)
            }
            self.manager = nil
        }
        
        
       
        let urlString = "http://www.bigchomp.com/json/feed-for-app.php"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                print(json[0]["name"])
                
                JsonFeed.JSONData = json
                
                if json[0]["name"] == "Rest-0" {
                    parseListJSON(json)
                }
            }
        }
    }
    
    func parseListJSON(json: JSON) {
        for resto in json.arrayValue {
            let name = resto["name"].stringValue
            let type = resto["type"].stringValue
            let obj = ["name": name, "type": type]
            restos.append(obj)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return sortedKeys.count
        return restos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        
        //print(indexPath.row)
        
        cell.textLabel?.text = restos[indexPath.row]["name"] //resto.key
        cell.detailTextLabel?.text = restos[indexPath.row]["type"] //resto.value
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        chosenCellIndex = indexPath.row
        chosenCellName = restos[indexPath.row]["name"]!
        
        print("clicked: \(chosenCellName) at row \(chosenCellIndex)")
        
        self.performSegueWithIdentifier("loadRestoView", sender: self)
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get a reference to the second view controller
        let restoViewController = segue.destinationViewController as! RestoViewController
        
        // set a variable in the second view controller with the data to pass
        restoViewController.receivedCellIndex = chosenCellIndex
        restoViewController.receivedCellName = chosenCellName
    }

      
}

