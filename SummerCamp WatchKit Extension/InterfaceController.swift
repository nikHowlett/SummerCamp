//
//  InterfaceController.swift
//  SummerCamp WatchKit Extension
//
//  Created by MAC-ATL019922 on 8/6/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation
import CoreData


class InterfaceController: WKInterfaceController {

    var psilocybin: [NSArray] = [NSArray]()
    var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
    
    @IBOutlet weak var number: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        loadActivites()
        var activitescount = psilocybin.count
        if activitescount == 0 {
            print("try again")
        } else {
            number.description == "\(activitescount)"
            print(activitescount)
            //number.
        }
    }
    
    @IBAction func Open() {
        let dict: Dictionary = ["message": "Yammer"]
        print("dataisbeensent", appendNewline: false)
        WKInterfaceController.openParentApplication(dict, reply: {(reply, error) -> Void in print("Data has been sent to target: parent iOS app - UCB Pharma", appendNewline: false)
        })
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadActivites() {
        for (var i = 0; i < 275; i++) {
            var thisstring = "Activity \(i)"
            var thethingusaved = NSUserDefaults.standardUserDefaults().objectForKey(thisstring) as! NSArray
            psilocybin.append(thethingusaved)
        }
    }
    
    
}
//types
//emojis, activity, yes-no, slider

/*var instagramHooks = "window.open('yammer://threads')"
var instagramUrl = NSURL(string: instagramHooks)
if UIApplication.sharedApplication().canOpenURL(instagramUrl!)
{
UIApplication.sharedApplication().openURL(instagramUrl!)

} else {
//redirect to safari because the user doesn't have Instagram
println("App not installed")
UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/in/app/instagram/id389801252?m")!)

}*/
