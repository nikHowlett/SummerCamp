//
//  Activity.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/6/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import Foundation
import CoreData

@objc(Activity)
class Activity: NSManagedObject {
    
    @NSManaged var id: Int
    @NSManaged var icon: String
    @NSManaged var type: String
    @NSManaged var text: String
    
}
