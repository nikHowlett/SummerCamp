//
//  ActivityInterfaceController.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/7/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation


class ActivityInterfaceController: WKInterfaceController {
        //make this the file for the slider and just have that be the first option i guess
        var psilocybin: [NSArray] = [NSArray]()
        var titles: [String] = [String]()
        var activityTitles: [String] = [String]()
        var activityNumbers: [Int] = [Int]()
        var titlesCount = 0
        var activitesCount = 0
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        var thisPageType = "activity"
        var Nub = 3
        var janet = "Update"
        @IBOutlet weak var thisText: WKInterfaceLabel!
        @IBOutlet weak var activitylabel: WKInterfaceLabel!
        var thisSingleActivityInAnArray = []
        @IBOutlet weak var openYammer: WKInterfaceButton!
        var globalArray = []
        var activitiesLeft = []
        var thisName = ""
        var thisCorpac = ""
        @IBOutlet weak var groupObject: WKInterfaceGroup!
        @IBOutlet weak var yammerButton: WKInterfaceButton!
        @IBOutlet weak var laterButton: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.synchronize()
        if (defaults?.objectForKey("Name") != nil) {
            thisName = defaults?.objectForKey("Name") as! String
            thisCorpac = defaults?.objectForKey("CorpID") as! String
        } else {
            pushControllerWithName("NoMore", context: self)
        }
    }
    
        func loadThisPage() {
            thisText.setText(thisSingleActivityInAnArray[0] as? String)
        }
    
    func responses2Server() {
        let thisCorpacc = thisCorpac
        let superfirst = "http://sc.ucbweb-acc.com/svc/GetActions"
        var quesid = thisSingleActivityInAnArray[3] as! String
        let firstpart = "?u=\(thisCorpacc)&a=r&id=\(quesid)&r=1"
        print(thisCorpacc)
        let url = NSURL(string: "\(superfirst)\(firstpart)")
        print(url!)
        let dict: Dictionary = ["message": "\(url!)"]
        WKInterfaceController.openParentApplication(dict, reply: {(reply, error) -> Void in print("URL/Response has been sent to target: parent iOS app - UCB Pharma", appendNewline: false)
        })
        /*print(url)
        print("THAT IS THE URL")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let json = JSON(data: data)
            print("RAWJSON: \(json)")
        }*/
    }
    
        @IBAction func Open() {
            let dict: Dictionary = ["message": "Yammer"]
            print("opening yammer...", appendNewline: false)
            responses2Server()
            WKInterfaceController.openParentApplication(dict, reply: {(reply, error) -> Void in print("Data has been sent to target: parent iOS app - UCB Pharma", appendNewline: false)
            })
            //var id = thisSingleActivityInAnArray[3] as! String
            //defaults?.removeObjectForKey("Activity \(id)")
            //globalArray.delete(thisSingleActivityInAnArray)
            //var globalArrayChicken = globalArray as NSMutableArray
            //globalArray.removeObjectAtIndex(0)
            print("GLOBAL")
            print(globalArray)
            var newArray = [] as NSArray
            for (var miguel = 1; miguel < globalArray.count; miguel++) {
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
    
    @IBAction func Later() {
        //var thisObj = globalArray[0] as! NSArray
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        //activitiesLeft = activitiesLeft.arrayByAddingObject(thisObj)
        //defaults?.setObject(activitiesLeft, forKey: "activitiesOnly")
        //defaults?.synchronize()
        var newArray = [] as NSArray
        for (var miguel = 1; miguel < globalArray.count; miguel++) {
            newArray = newArray.arrayByAddingObject(globalArray[miguel])
        }
        print("newArraycount: \(newArray.count)")
        print(thisSingleActivityInAnArray[0])
        //newArray.arrayByAddingObject(thisSingleActivityInAnArray)
        newArray = newArray.arrayByAddingObject(thisSingleActivityInAnArray as NSArray)
        print("newArraycount: \(newArray.count)")
        defaults?.setObject(newArray, forKey: "globalActivities")
        defaults?.synchronize()
        if newArray.count == 1 {
            pushControllerWithName("NoMore", context: self)
            return
        }
        openNext()
    }
    
    override func willActivate() {
        super.willActivate()
        psilocybin = []
        titles = []
        activityTitles = []
        activitiesLeft = []
        globalArray = []
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.synchronize()
        if (defaults?.objectForKey("activitiesOnly") != nil) {
            activitiesLeft = defaults?.objectForKey("activitiesOnly") as! NSArray
        }
        if (defaults?.objectForKey("globalActivities") != nil) {
            globalArray = defaults?.objectForKey("globalActivities") as! NSArray
        }
        /*if activitiesLeft.count > 0 {
            globalArray = globalArray.arrayByAddingObjectsFromArray(activitiesLeft as! [NSArray])
        }*/
        if globalArray.count > 0 {
            thisText.setText(globalArray[0][0] as? String)
            self.setTitle("1 / \(globalArray.count)")
            activitylabel.setText("Activity \(globalArray[0][3])")
            laterButton.setHidden(false)
            yammerButton.setHidden(false)
            activitylabel.setHidden(false)
            groupObject.setHidden(false)
            thisText.setHidden(false)
        } else if globalArray.count == 0 {
            pushControllerWithName("NoMore", context: self)
            return
        }
        print("Load GLOBAL")
        print(globalArray)
        if globalArray.count == 0 {
            self.pushControllerWithName("NoMore", context: self)
            return
        }
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
        } else if firstobject[2] as! String == "slider1-5" {
            self.pushControllerWithName("slider1-5", context: self)
        } else if firstobject[2] as! String == "emoji" {
            self.pushControllerWithName("emoji", context: self)
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
                activitylabel.setText("Activity \(currentActivity[3])")
                loadThisPage()
            } else if currentActivity[2] as! String == "yes-no" {
                self.pushControllerWithName("yes-no", context: self)
            } else if currentActivity[2] as! String == "slider1-5" {
                self.pushControllerWithName("slider1-5", context: self)
            } else if currentActivity[2] as! String == "slider-engagement" {
                self.pushControllerWithName("sslider-engagement", context: self)
            }
        }*/
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
            dismissController()
            pushControllerWithName("\(nextType)", context: self)
            dismissController()
        } else {
            pushControllerWithName("NoMore", context: self)
        }
        /*var xasString = thisSingleActivityInAnArray[3] as! String
        var x = xasString.toInt() as Int!
        var y = x+1
        var charlie = true
        var newactivitystring = "Activity \(y)"
        var activitescount = psilocybin.count
        for (var x = 0; x < activitescount-1; x++) {
            var currentActivity = psilocybin[x] as NSArray
            print(currentActivity)
            print(thisSingleActivityInAnArray)
            if currentActivity[2] as! String == thisPageType {
                if (currentActivity[0] as! String) == (thisSingleActivityInAnArray[0] as! String) {
                    print("not gonna open the same one lol")
                    charlie = false
                } else {
                    thisSingleActivityInAnArray = currentActivity
                    print("INSTANTIATED ACTIVITY OBJECT")
                    activitylabel.setText("Activity \(currentActivity[3])")
                    loadThisPage()
                }
            if !charlie {
                if currentActivity[2] as! String == "yes-no" {
                    self.pushControllerWithName("yes-no", context: self)
                } else if currentActivity[2] as! String == "slider1-5" {
                    self.pushControllerWithName("slider1-5", context: self)
                } else if currentActivity[2] as! String == "slider-engagement" {
                    self.pushControllerWithName("sslider-engagement", context: self)
                }
            }
        }*/
    }
}
