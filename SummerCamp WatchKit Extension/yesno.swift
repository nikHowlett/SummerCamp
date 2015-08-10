//
//  YesNoInterfaceController.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/7/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation
import CoreData

class yesno: WKInterfaceController {
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
    @IBOutlet weak var thisText: WKInterfaceLabel!
    @IBOutlet weak var activitylabel: WKInterfaceLabel!
    var thisSingleActivityInAnArray = []
    var globalArray: NSArray = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    func loadThisPage() {
        thisText.setText(thisSingleActivityInAnArray[0] as? String)
    }
    
    override func willActivate() {
        super.willActivate()
        psilocybin = []
        titles = []
        activityTitles = []
        globalArray = []
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        globalArray = defaults?.objectForKey("globalActivities") as! NSMutableArray
        var firstobject: NSArray = globalArray[0] as! NSArray
        var firstobjectype: String = firstobject[2] as! String
        thisSingleActivityInAnArray = firstobject
        if firstobject == thisPageType {
            loadThisPage()
        } else if firstobject[2] as! String == "activity" {
            self.pushControllerWithName("activity", context: self)
        } else if firstobject[2] as! String == "slider-engagement" {
            self.pushControllerWithName("slider-engagement", context: self)
        } else if firstobject[2] as! String == "slider1-5" {
            self.pushControllerWithName("slider1-5", context: self)
        }

        /*psilocybin = []
        titles = []
        activityTitles = []
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        //loadActivites()
        var activitytitlearray = defaults?.dictionaryRepresentation().keys.array
        for (var p = 0; p < activitytitlearray!.count-1; p++) {
            var activityWord = ""
            var thisobjectatindexp = activitytitlearray![p] as? String
            if (thisobjectatindexp! as NSString).length == 10 {
                activityWord = thisobjectatindexp!.substringToIndex(advance(thisobjectatindexp!.startIndex, 8))
            }
            if activityWord == "Activity" {
                activityTitles.append(thisobjectatindexp!)
            }
        }
        print(activityTitles)
        for (var i = 0; i < activityTitles.count-1; i++) {
            var thisActivityTitle = activityTitles[i]
            var datnumba = thisActivityTitle.substringFromIndex(advance(thisActivityTitle.startIndex, 9))
            var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
            var thethingusaved = defaults?.objectForKey("Activity \(datnumba)") as! NSArray
            psilocybin.append(thethingusaved)
        }
        /*
        if you need to sort them in order by activity number
        for (var k = 0; k < psilocybin.count-1; k++) {
        var thispsilo = psilocybin[k]
        var actiivtyID = thispsilo[3] as! String
        var asInt = activityID.toInt()
        }*/
        print(psilocybin)
        var activitescount = psilocybin.count
        if activitescount == 0 {
            print("try again")
        } else {
            print("Activites count:")
            print(activitescount)
        }
        self.setTitle("1 / \(activitescount)")
        var isthistherightone = false
        for (var x = 0; x < activitescount-1; x++) {
            var currentActivity = psilocybin[x] as NSArray
            if currentActivity[2] as! String == thisPageType {
                thisSingleActivityInAnArray = currentActivity
                print("INSTANTIATED ACTIVITY OBJECT")
                loadThisPage()
            } else if currentActivity[2] as! String == "slider-engagement" {
                self.pushControllerWithName("slider-engagement", context: self)
            } else if currentActivity[2] as! String == "activity" {
                self.pushControllerWithName("activity", context: self)
            } else if currentActivity[2] as! String ==  "slider1-5" {
                self.pushControllerWithName("slider1-5", context: self)
            }
            
        }*/
    }
    
    
    func openNext() {
        if globalArray.count > 0 {
            var nextObj = globalArray[1] as! NSArray
            var nextType = nextObj[2] as! String
            pushControllerWithName("\(nextType)", context: self)
        } else {
            pushControllerWithName("NoMore", context: self)
        }
    }
    
    @IBAction func pressNo() {
        var id = thisSingleActivityInAnArray[3] as? String
        var whole = "Activity \(id!)"
        //globalArray.removeObjectAtIndex(0)
        globalArray.delete(thisSingleActivityInAnArray)
        defaults?.setObject(globalArray, forKey: "globalActivities")
        openNext()
        /*NSUserDefaults.standardUserDefaults().removeObjectForKey("Activity \(id!)")
        NSUserDefaults.standardUserDefaults().removeObjectForKey(whole)*/
    }
    
    @IBAction func pressYes() {
        var id = thisSingleActivityInAnArray[3] as? String
        var whole = "Activity \(id!)"
        //globalArray.removeObjectAtIndex(0)
        globalArray.delete(thisSingleActivityInAnArray)
        defaults?.setObject(globalArray, forKey: "globalActivities")
        openNext()
        /*NSUserDefaults.standardUserDefaults().removeObjectForKey("Activity \(id!)")
        NSUserDefaults.standardUserDefaults().removeObjectForKey(whole)*/
    }
    
    
}//types

