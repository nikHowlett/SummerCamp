//
//  ActivityScreenInterfaceController.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/7/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation

class ActivityScreenInterfaceController: WKInterfaceController {
    
    var activitiesLeft = []
    var globalArray = []
    var firstTime = true
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        if globalArray.count > 0 {
            pushControllerWithName("activity", context: self)
        }
        activitiesLeft = []
        defaults?.setObject(activitiesLeft, forKey: "activitiesOnly")
        defaults?.synchronize()
        // Configure interface objects here.
    }
    
    func restInPeace() {
        /*if firstTime {
            firstTime = false
            if globalArray.count > 0 {
                self.popToRootController()
            }
            return
        } else {
            firstTime = true
        }
        print("to see")*/
        var globalArray1 = []
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        /*if (defaults?.objectForKey("activitiesOnly") != nil) {
            activitiesLeft = defaults?.objectForKey("activitiesOnly") as! NSArray
            if activitiesLeft.count > 0 {
                self.popToRootController()
            }
        }*/
        if (defaults?.objectForKey("globalActivities") != nil) {
            globalArray1 = defaults?.objectForKey("globalActivities") as! NSArray
            if globalArray1.count > 0 {
                self.popToRootController()
            }
        }
    }
    
    @IBAction func ReFreSh() {
        self.popToRootController()
        return
        //var timer3 = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "restInPeace:", userInfo: nil, repeats: true)
        /*self.dismissController()
        pushControllerWithName("activity", context: self)
        self.dismissController()
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        var baby = []
        if (defaults?.objectForKey("globalActivities") != nil) {
            baby = defaults?.objectForKey("globalActivities") as! NSArray
        }
        if baby.count > 0 {
            pushControllerWithName("activity", context: self)
        }*/
    }

    override func willActivate() {
        super.willActivate()
        print("IS THIS CALLED")
        var timer3 = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "restInPeace", userInfo: nil, repeats: true)
                    /*
            //globalArray = globalArray.arrayByAddingObjectsFromArray(activitiesLeft as! [NSArray])
            for (var miguel = 0; miguel < globalArray1.count; miguel++) {
                globalArray = globalArray.arrayByAddingObject(globalArray1[miguel])
            }
        } else {
            //self.popToRootController()
        }*/
        /*if activitiesLeft.count > 0 {
            //globalArray = globalArray.arrayByAddingObjectsFromArray(activitiesLeft as! [NSArray])
            for (var miguel = 0; miguel < globalArray.count; miguel++) {
                globalArray = globalArray.arrayByAddingObject(activitiesLeft[miguel])
            }
        }*/
        //defaults?.setObject(globalArray, forKey: "globalActivities")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
