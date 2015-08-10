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
    //make this the file for the slider and just have that be the first option i guess
    var psilocybin: [NSArray] = [NSArray]()
    var titles: [String] = [String]()
    var activityNumbers: [Int] = [Int]()
    var titlesCount = 0
    var activitesCount = 0
    var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
    var thisPageType = "slider"
    
    @IBOutlet weak var number: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //go to the correct interface based on the closest activity's title
        openNextPage()
    }
    
    func openNextPage() {
        var thisType = ""
        if titlesCount == 0 {
            //update the interface to go to the screen that says no more activites, a congratulations screen
            //maybe this needs a self.
            pushControllerWithName(“NoMore”, context: [“segue”: “hierarchical”,
             “data”:“Passed through hierarchical navigation”])
        } else {
            //go to the correct interface based on the closest activity's title
            var thisActivityID = activityTitles[0]
            //associate the activity.id with the \(i) variable
            //go through psilocybin and pull activity.type
            //find the index where activity.id = thisActivityID
            //then pull activity
            for (var p = 0; p < psilocybin.count-1; p++) {
                var thisActObj = psilocybin[p]
                var thisID = thisActObj.id
                if thisID == thisActivityID {
                    //get the type
                    thisType = thisActObj.type
                }
            }
            if thisType != thisPageType {
               loadThisPage()
            } else {
                pushControllerWithName(“\(thisType)”, context: [“segue”: “hierarchical”,
             “data”:“Passed through hierarchical navigation”])
            }
        }
        //ok so this is watch nav so its different than phone nav
        //instead of passing the activity object to the next page like usual,
        //we're gonna load the activites the same way we did on this page, but its gonna be the right page, each page will have a type
        
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
        activityTitles = []
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
                activityNumbers.append(i)
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
