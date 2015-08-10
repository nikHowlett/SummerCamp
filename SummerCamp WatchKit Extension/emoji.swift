//
//  EmojiInterfaceController.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/7/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation
import CoreData

class emoji: WKInterfaceController {
    //make this the file for the slider and just have that be the first option i guess
    var psilocybin: [NSArray] = [NSArray]()
    var titles: [String] = [String]()
    var activityTitles: [String] = [String]()
    var activityNumbers: [Int] = [Int]()
    var titlesCount = 0
    var activitesCount = 0
    var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
    var thisPageType = "slider"
    var Nub = 3
    var janet = "Update"
    @IBOutlet weak var iconOutlet: WKInterfaceImage!
    //@IBOutlet weak var number: WKInterfaceLabel!
    @IBOutlet weak var thisslider: WKInterfaceSlider!
    @IBOutlet weak var thisText: WKInterfaceLabel!
    @IBOutlet weak var sliderUpdater: WKInterfaceLabel!
    @IBOutlet weak var activitylabel: WKInterfaceLabel!
    var thisSingleActivityInAnArray = []
    var globalArray = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //go to the correct interface based on the closest activity's title
        openNextPage()
    }
    
    func loadThisPage() {
        thisText.setText(thisSingleActivityInAnArray[0] as? String)
        var outletimage = thisSingleActivityInAnArray[1] as? String
        //iconOutlet.setImage(outletimage!)
        iconOutlet.setImageNamed(outletimage!)
    }
    
    func openNextPage() {
        var thisType = ""
        if titlesCount == 0 {
            //update the interface to go to the screen that says no more activites, a congratulations screen
            //maybe this needs a self.
            //self.pushControllerWithName(“NoMore”, context: [“segue”: “hierarchical”,
            //“data”:“Passed through hierarchical navigation”])
            self.pushControllerWithName("NoMore", context: self)
        } else {
            //go to the correct interface based on the closest activity's title
            var thisActivityID = titles[0]
            //associate the activity.id with the \(i) variable
            //go through psilocybin and pull activity.type
            //find the index where activity.id = thisActivityID
            //then pull activity
            var thisActObj = []
            for (var p = 0; p < psilocybin.count-1; p++) {
                thisActObj = psilocybin[p]
                var thisID: String = thisActObj[3] as! String
                if thisID == thisActivityID {
                    //get the type
                    thisType = thisActObj[2] as! String
                }
            }
            if thisType != thisPageType {
                thisSingleActivityInAnArray = thisActObj
                loadThisPage()
            } else {
                pushControllerWithName("\(thisType)", context: self)
            }
        }
        //ok so this is watch nav so its different than phone nav
        //instead of passing the activity object to the next page like usual,
        //we're gonna load the activites the same way we did on this page, but its gonna be the right page, each page will have a type
    }

    
    @IBAction func sleepSliderDidMove(value: Float) {
        Nub = Int(value)
        if Nub == 0 {
            janet = "Unengaging"
        } else if Nub == 1 {
            janet = "Uninteresting"
        } else if Nub == 2 {
            janet = "Sub-Par"
        } else if Nub == 3 {
            janet = "Good"
        } else if Nub == 4 {
            janet = "Very Good"
        } else if Nub == 5 {
            janet = "Extremely Engaging"
        }
        activitylabel.setText(janet)
        //sqLabelText = "Quality: \(sliderValue)"
        //sqLabel.setText(sqLabelText)
    }
    
    /*@IBAction func Open() {
        let dict: Dictionary = ["message": "Yammer"]
        print("dataisbeensent", appendNewline: false)
        WKInterfaceController.openParentApplication(dict, reply: {(reply, error) -> Void in print("Data has been sent to target: parent iOS app - UCB Pharma", appendNewline: false)
        })
    }*/
    
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
            //number.setText("\(activitescount)")
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
            var thethingusaved = NSUserDefaults.standardUserDefaults().objectForKey(thisActivityTitle) as! NSArray
            //psilocybin.append(thethingusaved)
            //find out how "thethingusaved" variable looks when empty or not
            if (thethingusaved.count > 0) {
                charlie = true
                psilocybin.append(thethingusaved)
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
    
    
}//types

