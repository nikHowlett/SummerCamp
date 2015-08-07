//
//  Employee.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/7/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import Foundation
import CoreData

@objc(Employee)
class Employee: NSManagedObject {
    
    @NSManaged var corpID: String
    @NSManaged var name: String
    
    
}
