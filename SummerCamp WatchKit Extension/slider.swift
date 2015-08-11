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

class slider: WKInterfaceController {
    
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
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        thisName = defaults?.objectForKey("Name") as! String
        thisCorpac = defaults?.objectForKey("CorpID") as! String
    }
    
    func loadThisPage() {
        thisText.setText(thisSingleActivityInAnArray[0] as? String)
    }
    
    func openNextPage() {
        if globalArray.count > 0 {
            var nextObj = globalArray[0] as! NSArray
            var nextType = nextObj[2] as! String
            pushControllerWithName("\(nextType)", context: self)
        } else {
            pushControllerWithName("NoMore", context: self)
        }
    }
    
    @IBAction func sleepSliderDidMove(value: Float) {
        Nub = Int(value)
        if Nub == 0 {
            //janet = "Unengaging"
            janet = "Bored"
        } else if Nub == 1 {
            //janet = "Uninteresting"
            janet = "Bored"
        } else if Nub == 2 {
            //janet = "Sub-Par"
            janet = "Not Interested"
        } else if Nub == 3 {
            //janet = "Good"
            janet = "Neutral"
        } else if Nub == 4 {
            //janet = "Very Good"
            janet = "Interested"
        } else if Nub == 5 {
            //janet = "Extremely Engaging"
            janet = "Highly Interested"
        }
        sliderUpdater.setText(janet)
    }
    
    override func willActivate() {
        super.willActivate()
        psilocybin = []
        titles = []
        activityTitles = []
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        globalArray = defaults?.objectForKey("globalActivities") as! NSArray
        var firstobject: NSArray = globalArray[0] as! NSArray
        var firstobjectype: String = firstobject[2] as! String
        thisSingleActivityInAnArray = firstobject
        if firstobject == thisPageType {
            loadThisPage()
        } else if firstobject[2] as! String == "yes-no" {
            self.pushControllerWithName("yes-no", context: self)
        } else if firstobject[2] as! String == "activity" {
            self.pushControllerWithName("activity", context: self)
        } else if firstobject[2] as! String == "slider1-5" {
            self.pushControllerWithName("slider1-5", context: self)
        }
        /*var activitytitlearray = defaults?.dictionaryRepresentation().keys.array
        print(activitytitlearray!)
        for (var p = 0; p < activitytitlearray!.count-1; p++) {
            var activityWord = ""
            var thisobjectatindexp = activitytitlearray![p] as? String
            print(thisobjectatindexp)
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
            globalArray = defaults?.objectForKey("globalActivities") as! NSArray
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
            } else if currentActivity[2] as! String == "yes-no" {
                self.pushControllerWithName("yes-no", context: self)
            } else if currentActivity[2] as! String == "activity" {
                self.pushControllerWithName("activity", context: self)
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
            pushControllerWithName("\(nextType)", context: self)
        } else {
            pushControllerWithName("NoMore", context: self)
        }
    }

    @IBAction func Submit() {
        responses2Server()
        var newArray = [] as NSArray
        for (var miguel = 1; miguel < globalArray.count-1; miguel++) {
            newArray = newArray.arrayByAddingObject(globalArray[miguel])
        }
        //var jankRay = newArray as! NSMutableArray
        print("Replacing global with this!")
        print(newArray)
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.setObject(newArray, forKey: "globalActivities")
        defaults?.synchronize()
        openNext()
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
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}