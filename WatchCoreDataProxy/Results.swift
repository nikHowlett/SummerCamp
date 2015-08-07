//
//  Results.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/6/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import Foundation
import CoreData

@objc(Results)
class Results: NSManagedObject {
    
    @NSManaged var q1: Double
    @NSManaged var q2: Double
    @NSManaged var q3: Double
    
}
