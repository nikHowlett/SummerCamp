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
    var titles: [String] = [String]()
    var titlesCount = 0
    var activitesCount = 0
    var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
    
    @IBOutlet weak var number: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //go to the correct interface based on the closest activity's title
        if titlesCount == 0 {
        //update the interface to go to the screen that says no more activites, a congratulations screen
        //maybe this needs a self.
        presentControllerWithName(“NoMore”,
          context: [“segue”: “pagebased”,
                “data”: “Passed through page-based navigation”])
        } else {
        //go to the correct interface based on the closest activity's title
        var titleString = titlesCount[0]
        //associate the activity.id with the \(i) variable
        
        }
    }
    
    @IBAction func Open() {
        let dict: Dictionary = ["message": "Yammer"]
        print("dataisbeensent", appendNewline: false)
        WKInterfaceController.openParentApplication(dict, reply: {(reply, error) -> Void in print("Data has been sent to target: parent iOS app - UCB Pharma", appendNewline: false)
        })
    }

    override func willActivate() {
        super.willActivate()
        psilocybin = []
        titles = []
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        loadActivites()
        var activitescount = psilocybin.count
        if activitescount == 0 {
            print("try again")
        } else {
            number.setText("\(activitescount)")
            print(activitescount)
        }
        self.setTitle("1 / \(activitescount)")
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func loadActivites() {
        var charlie = false;
        for (var i = 0; i < 275; i++) {
            charlie = false
            var thisActivityTitle = "Activity \(i)"
            var thethingusaved = NSUserDefaults.standardUserDefaults().objectForKey(thisstring) as! NSArray
            psilocybin.append(thethingusaved)
            //find out how "thethingusaved" variable looks when empty or not
            if thethingusaved !=nil {
                charlie = true
            }
            if charlie {
                titles.append(thisActivityTitle)
            }
        }
        //create an array of the titles of "Activity \(i) that you send
        //in another for loop, loop throught the titles, and pull them
        titlesCount = titles.count
        activitesCount = psilocybin.count
    }
    
    
}
//types
//emojis, activity, yes-no, slider

/*var yammerHooks = "window.open('yammer://threads')"
var yammerUrl = NSURL(string: yammerHooks)
if UIApplication.sharedApplication().canOpenURL(yammerUrl!)
{
UIApplication.sharedApplication().openURL(yammerUrl!)

} else {
//redirect to safari because the user doesn't have Yammer
println("App not installed")
UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/in/app/instagram/id389801252?m")!)

}*/
