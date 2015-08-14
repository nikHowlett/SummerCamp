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
    
    var psilocybin: [NSArray] = [NSArray]()
    var titles: [String] = [String]()
    var activityTitles: [String] = [String]()
    var activityNumbers: [Int] = [Int]()
    var titlesCount = 0
    var activitesCount = 0
    var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
    var thisPageType = "slider"
    var Nub = 2
    var janet = "Update"
    @IBOutlet weak var thisText: WKInterfaceLabel!
    var thisSingleActivityInAnArray = []
    var globalArray = []
    @IBOutlet weak var emojiImage: WKInterfaceImage!
    @IBOutlet weak var pbut: WKInterfaceButton!
    @IBOutlet weak var mbut: WKInterfaceButton!
    var thisName = ""
    var thisCorpac = ""
    @IBOutlet weak var activityLabel: WKInterfaceLabel!
    var imageTitleArray = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.synchronize()
        thisName = defaults?.objectForKey("Name") as! String
        thisCorpac = defaults?.objectForKey("CorpID") as! String
        imageTitleArray = ["01_sleeping", "02_neutral", "03_content", "04_happy", "05_knocked_out"]
    }
    
    func loadThisPage() {
        thisText.setText(thisSingleActivityInAnArray[0] as? String)
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
            activityLabel.setText("Question \(globalArray[0][3])")
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
        } else if firstobject[2] as! String == "activity" {
            self.pushControllerWithName("activity", context: self)
        }

    }
    
    @IBAction func minus() {
        if Nub != 0 {
            Nub = Nub - 1
        }
        var imgStr = (imageTitleArray[Nub] as! String)
        emojiImage.setImageNamed(imgStr)
    }
    
    @IBAction func plus() {
        if Nub != 4 {
            Nub = Nub + 1
        }
        var imgStr = (imageTitleArray[Nub] as! String)
        emojiImage.setImageNamed(imgStr)
    }
    
    func responses2Server() {
        let thisCorpacc = thisCorpac
        let superfirst = "http://sc.ucbweb-acc.com/svc/GetActions"
        var quesid = thisSingleActivityInAnArray[3] as! String
        var jub = Nub+1
        let firstpart = "?u=\(thisCorpacc)&a=r&id=\(quesid)&r=\(jub)"
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

    
    @IBAction func Submit() {
        responses2Server()
        var newArray = [] as NSArray
        for (var miguel = 1; miguel < globalArray.count; miguel++) {
            newArray = newArray.arrayByAddingObject(globalArray[miguel])
        }
        print("Replacing global with this!")
        print(newArray)
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.setObject(newArray, forKey: "globalActivities")
        defaults?.synchronize()
        openNext()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}
//types

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

/*func openNextPage() {
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
}//make this the file for the slider and just have that be the first option i guess

}
//ok so this is watch nav so its different than phone nav
//instead of passing the activity object to the next page like usual,
//we're gonna load the activites the same way we did on this page, but its gonna be the right page, each page will have a type
}*/


