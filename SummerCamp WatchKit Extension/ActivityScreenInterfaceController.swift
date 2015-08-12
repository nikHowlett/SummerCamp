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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        activitiesLeft = []
        globalArray = []
        var globalArray1 = []
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.synchronize()
        if (defaults?.objectForKey("activitiesOnly") != nil) {
            activitiesLeft = defaults?.objectForKey("activitiesOnly") as! NSArray
        }
        if (defaults?.objectForKey("globalActivities") != nil) {
            globalArray1 = defaults?.objectForKey("globalActivities") as! NSArray
        }
        if activitiesLeft.count > 0 {
            globalArray = globalArray.arrayByAddingObjectsFromArray(activitiesLeft as! [NSArray])
        }
        if globalArray.count > 0 {
            pushControllerWithName("activity", context: self)
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
