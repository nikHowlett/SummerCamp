//
//  loadInterfaceController.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/7/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation


class loadInterfaceController: WKInterfaceController {

    @IBOutlet weak var gobutt: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    @IBAction func nextaction() {
        self.presentControllerWithName("YesNo", context: self)
        self.presentControllerWithName("Emoji", context: self)
        self.presentControllerWithName("Activity", context: self)
        self.presentControllerWithName("Slide", context: self)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
