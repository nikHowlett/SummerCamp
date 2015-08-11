//
//  sliderengagement.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/10/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation
import CoreData

class sliderengagement: WKInterfaceController {
    //make this the file for the slider and just have that be the first option i guess
    var psilocybin: [NSArray] = [NSArray]()
    var titles: [String] = [String]()
    var activityTitles: [String] = [String]()
    var activityNumbers: [Int] = [Int]()
    var titlesCount = 0
    var activitesCount = 0
    var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
    var thisPageType = "slider"
    var Nub = 3
    var janet = "Update"
    //@IBOutlet weak var iconOutlet: WKInterfaceImage!
    //@IBOutlet weak var number: WKInterfaceLabel!
    @IBOutlet weak var thisslider: WKInterfaceSlider!
    @IBOutlet weak var thisText: WKInterfaceLabel!
    @IBOutlet weak var sliderUpdater: WKInterfaceLabel!
    @IBOutlet weak var activitylabel: WKInterfaceLabel!
    var thisSingleActivityInAnArray = []
    var globalArray = []
    var thisName = ""
    var thisCorpac = ""
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //go to the correct interface based on the closest activity's title
        //openNextPage()
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.synchronize()
        thisName = defaults?.objectForKey("Name") as! String
        thisCorpac = defaults?.objectForKey("CorpID") as! String
    }
    
    func loadThisPage() {
        thisText.setText(thisSingleActivityInAnArray[0] as? String)
    }
    
    @IBAction func submit() {
        responses2Server()
        var newArray = [] as NSArray
        for (var miguel = 1; miguel < globalArray.count-1; miguel++) {
            newArray = newArray.arrayByAddingObject(globalArray[miguel])
        }
        //var jankRay = newArray as! NSMutableArray
        print("Replacing global with this!")
        print(newArray)
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.setObject(newArray, forKey: "globalActivities")
        defaults?.synchronize()
        openNext()
    }
    
    func openNext() {
        print("opening next")
        if globalArray.count > 0 {
            var nextObj = globalArray[0] as! NSArray
            print("NEXT OBJ ")
            print(nextObj)
            var nextType = nextObj[2] as! String
            if nextType == thisPageType {
                thisSingleActivityInAnArray = nextObj
                loadThisPage()
            }
            print(nextType)
            pushControllerWithName("\(nextType)", context: self)
        } else {
            pushControllerWithName("NoMore", context: self)
        }
    }
    
    func openNextPage() {
        func openNext() {
            print("opening next")
            if globalArray.count > 0 {
                var nextObj = globalArray[0] as! NSArray
                print("NEXT OBJ ")
                print(nextObj)
                var nextType = nextObj[2] as! String
                if nextType == thisPageType {
                    thisSingleActivityInAnArray = nextObj
                    loadThisPage()
                }
                print(nextType)
                pushControllerWithName("\(nextType)", context: self)
            } else {
                pushControllerWithName("NoMore", context: self)
            }
        }
        /*var thisType = ""
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
        }*/
        //ok so this is watch nav so its different than phone nav
        //instead of passing the activity object to the next page like usual,
        //we're gonna load the activites the same way we did on this page, but its gonna be the right page, each page will have a type
    }

    
    @IBAction func sleepSliderDidMove(value: Float) {
        Nub = Int(value)
        if Nub == 0 {
            janet = "0"
        } else if Nub == 1 {
            janet = "1"
        } else if Nub == 2 {
            janet = "2"
        } else if Nub == 3 {
            janet = "3"
        } else if Nub == 4 {
            janet = "4"
        } else if Nub == 5 {
            janet = "5"
        }
        sliderUpdater.setText(janet)
        //sqLabelText = "Quality: \(sliderValue)"
        //sqLabel.setText(sqLabelText)
    }
    
    override func willActivate() {
        super.willActivate()
        psilocybin = []
        titles = []
        activityTitles = []
        globalArray = []
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.synchronize()
        globalArray = defaults?.objectForKey("globalActivities") as! NSArray
        if globalArray.count > 0 {
            thisText.setText(globalArray[0][0] as? String)
            self.setTitle("1 / \(globalArray.count)")
            activitylabel.setText("Question \(globalArray[0][3])")
        } else if globalArray.count == 0 {
            pushControllerWithName("NoMore", context: self)
        }
        print("Load GLOBAL")
        print(globalArray)
        var firstobject: NSArray = globalArray[0] as! NSArray
        //print("L FIRST")
        //print(firstobject)
        var firstobjectype: String = firstobject[2] as! String
        thisSingleActivityInAnArray = firstobject
        if firstobject == thisPageType {
            thisText.setText(thisSingleActivityInAnArray[0] as? String)
            loadThisPage()
            thisText.setText(thisSingleActivityInAnArray[0] as? String)
        } else if firstobject[2] as! String == "yes-no" {
            self.pushControllerWithName("yes-no", context: self)
        } else if firstobject[2] as! String == "slider-engagement" {
            self.pushControllerWithName("slider-engagement", context: self)
        } else if firstobject[2] as! String == "activity" {
            self.pushControllerWithName("activity", context: self)
        } else if firstobject[2] as! String == "emoji" {
            self.pushControllerWithName("emoji", context: self)
        }
        /*psilocybin = []
        titles = []
        activityTitles = []
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        //loadActivites()
        var activitescount = psilocybin.count
        if activitescount == 0 {
            print("try again")
        } else {
            //number.setText("\(activitescount)")
            print(activitescount)
        }
        self.setTitle("1 / \(activitescount)")*/
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func responses2Server() {
        let thisCorpacc = thisCorpac
        let superfirst = "http://sc.ucbweb-acc.com/svc/GetActions"
        var quesid = thisSingleActivityInAnArray[3] as! String
        let firstpart = "?u=\(thisCorpacc)&a=r&id=\(quesid)&r=\(Nub)"
        print(thisCorpacc)
        let url = NSURL(string: "\(superfirst)\(firstpart)")
        print(url)
        print("THAT IS THE URL")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let json = JSON(data: data)
        }
    }
    
   /* func loadActivites() {
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
    }*/
    
    
}//types

