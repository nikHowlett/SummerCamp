//
//  AppDelegate.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/6/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var newItems = []
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier =
    UIBackgroundTaskInvalid
    
    var myTimer: NSTimer?


    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        NSNotificationCenter.defaultCenter().postNotificationName("WatchKitReq", object: userInfo)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))  // types are UIUserNotificationType members\
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        var snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "Later"
        snoozeAction.title = "Later"
        snoozeAction.activationMode = .Background
        snoozeAction.destructive = true
        snoozeAction.authenticationRequired = false
        
        var boozeAction = UIMutableUserNotificationAction()
        boozeAction.identifier = "Now"
        boozeAction.title = "Now"
        boozeAction.activationMode = .Foreground
        boozeAction.destructive = false
        boozeAction.authenticationRequired = false
        
        // Notification category
        let defaultActions = [boozeAction]
        let minimalActions = [boozeAction]
        var mainCategory = UIMutableUserNotificationCategory()
        mainCategory.identifier = "space"
        var someCategory = UIMutableUserNotificationCategory()
        someCategory.identifier = "signal"
        var valueCategory = UIMutableUserNotificationCategory()
        valueCategory.identifier = "value"
        var helpfulCategory = UIMutableUserNotificationCategory()
        helpfulCategory.identifier = "helpful"
        var defaultCategory = UIMutableUserNotificationCategory()
        defaultCategory.identifier = "default"
        someCategory.setActions(defaultActions, forContext: UIUserNotificationActionContext.Default)
        someCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        helpfulCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Default)
        helpfulCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        mainCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Default)
        mainCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        valueCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Default)
        valueCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        defaultCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Default)
        defaultCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert, categories: NSSet(array:[mainCategory, someCategory, helpfulCategory, valueCategory]) as Set<NSObject>))
        
        return true
    }

    class func newItemsChangedNotification() -> String {
        return "\(__FUNCTION__)"
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier:String?, forLocalNotification notification:UILocalNotification, completionHandler: (() -> Void)){
            if (identifier == "helpful"){
                NSNotificationCenter.defaultCenter().postNotificationName("helpful", object: nil)
            } else if (identifier == "space"){
                NSNotificationCenter.defaultCenter().postNotificationName("space", object: nil)
                
            } else if (identifier == "signal"){
                NSNotificationCenter.defaultCenter().postNotificationName("signal", object: nil)
            } else if (identifier == "value"){
                NSNotificationCenter.defaultCenter().postNotificationName("value", object: nil)
            } else if (identifier == "default"){
                NSNotificationCenter.defaultCenter().postNotificationName("default", object: nil)
        }
            completionHandler()
    }
    
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = 0
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        var charlie = 0
        var banana = 0
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        if (defaults?.objectForKey("CorpID") != nil) {
            print("Conditional Discharge")
            var corpAcc = (defaults?.objectForKey("CorpID") as! String)
            let superfirst = "http://sc.ucbweb-acc.com/svc/GetActions"
            let firstpart = "?u=\(corpAcc)&a=gp"
            newItems = []
            let url = NSURL(string: "\(superfirst)\(firstpart)")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                let json = JSON(data: data)
                print("DELEGATOR RAWJSON: \(json)")
                var stillmoreactivites = true
                var i = 0
                while stillmoreactivites {
                    let type = json[i]["type"].stringValue
                    let id = json[i]["id"].int
                    let text = json[i]["text"].stringValue
                    let icon = json[i]["icon"].stringValue
                    let response = json[i]["response"].stringValue
                    if response != "" {
                        stillmoreactivites = false
                        println("OH NO THE MOB BOSS")
                        charlie++
                    } else if type == "" {
                        stillmoreactivites = false
                        println("OH NO THE MOB BOSS")
                        charlie++
                    } else {
                        banana++
                        println("OH NO THE BOB ROSS")
                        i++
                        print("QUESTION ID \(id!)")
                        print(text)
                        print(type)
                        print(icon)
                        var shit = "\(id!)"
                        var array = [text, icon, type, shit] as NSArray
                        self.newItems.arrayByAddingObject(array)
                        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
                        var globalActivities: NSArray = []
                        var activitytitlearray = defaults?.dictionaryRepresentation().keys.array
                        for (var p = 0; p < activitytitlearray!.count-1; p++) {
                            var thisobjectatindexp = activitytitlearray![p] as? String
                            if thisobjectatindexp! == "globalActivities" {
                                globalActivities = defaults?.objectForKey("globalActivities") as! NSArray
                            }
                        }
                        print("CURRENT GLOBAL")
                        print(globalActivities)
                        var jeanie = globalActivities.arrayByAddingObject(array)
                        print("SAVING THIS AS NEW GLOBAL")
                        print(jeanie)
                        defaults?.setObject(jeanie, forKey: "globalActivities")
                        self.notifysomeone(icon, type: type)
                        print("DIDTHATWORK&&&&&&&&&&&&&&&&&&&&&&&")
                    }
                }
            }
            task.resume()
        }
        println("DELEGATOR END")
        if banana != 0 {
            completionHandler(.NewData)
        } else {
            completionHandler(.NoData)
        }
        if self.fetchNewItems() {
            completionHandler(.NewData)
        } else {
            completionHandler(.NoData)
        }
    }
    
    func fetchNewItemz(sender: NSTimer) -> Bool {
        print("this is the delegator")
        NSNotificationCenter.defaultCenter().postNotificationName(
            self.classForCoder.newItemsChangedNotification(),
            object: nil)
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.synchronize()
        newItems = []
        var charlie = 0
        var banana = 0
        if (defaults?.objectForKey("CorpID") != nil) {
            var corpAcc = (defaults?.objectForKey("CorpID") as! String)
            print("checkServer called!!!!!!!!")
            let thisCorpacc = corpAcc
            let superfirst = "http://sc.ucbweb-acc.com/svc/GetActions"
            let firstpart = "?u=\(thisCorpacc)&a=gp"
            print(thisCorpacc)
            let url = NSURL(string: "\(superfirst)\(firstpart)")
            print(url!)
            println("THAT IS THE URL DELEGATOR")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                let json = JSON(data: data)
                print("DELEGATOR RAWJSON: \(json)")
                var stillmoreactivites = true
                var i = 0
                while stillmoreactivites {
                    let type = json[i]["type"].stringValue
                    let id = json[i]["id"].int
                    let text = json[i]["text"].stringValue
                    let icon = json[i]["icon"].stringValue
                    let response = json[i]["response"].stringValue
                    if response != "" {
                        stillmoreactivites = false
                        charlie++
                    } else if type == "" {
                        stillmoreactivites = false
                        charlie++
                    } else {
                        banana++
                        i++
                        print("QUESTION ID \(id!)")
                        print(text)
                        print(type)
                        print(icon)
                        var shit = "\(id!)"
                        var array = [text, icon, type, shit] as NSArray
                        self.newItems.arrayByAddingObject(array)
                        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
                        var globalActivities: NSArray = []
                        var activitytitlearray = defaults?.dictionaryRepresentation().keys.array
                        for (var p = 0; p < activitytitlearray!.count-1; p++) {
                            var thisobjectatindexp = activitytitlearray![p] as? String
                            if thisobjectatindexp! == "globalActivities" {
                                globalActivities = defaults?.objectForKey("globalActivities") as! NSArray
                            }
                        }
                        print("CURRENT GLOBAL")
                        print(globalActivities)
                        var jeanie = globalActivities.arrayByAddingObject(array)
                        print("SAVING THIS AS NEW GLOBAL")
                        print(jeanie)
                        defaults?.setObject(jeanie, forKey: "globalActivities")
                        self.notifysomeone(icon, type: type)
                        print("DIDTHATWORK&&&&&&&&&&&&&&&&&&&&&&&")
                    }
                }
            }
            task.resume()
        }
        if banana != 0 {
            return true
        } else {
            return false
        }
    }
    
    func fetchNewItems() -> Bool {
        print("this is the delegator")
        NSNotificationCenter.defaultCenter().postNotificationName(
            self.classForCoder.newItemsChangedNotification(),
            object: nil)
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.synchronize()
        newItems = []
        var charlie = 0
        var banana = 0
        if (defaults?.objectForKey("CorpID") != nil) {
            var corpAcc = (defaults?.objectForKey("CorpID") as! String)
        print("checkServer called!!!!!!!!")
            let thisCorpacc = corpAcc
            let superfirst = "http://sc.ucbweb-acc.com/svc/GetActions"
            let firstpart = "?u=\(thisCorpacc)&a=gp"
            print(thisCorpacc)
            let url = NSURL(string: "\(superfirst)\(firstpart)")
            print(url!)
            println("THAT IS THE URL DELEGATOR")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                let json = JSON(data: data)
                print("DELEGATOR RAWJSON: \(json)")
                var stillmoreactivites = true
                var i = 0
                while stillmoreactivites {
                    let type = json[i]["type"].stringValue
                    let id = json[i]["id"].int
                    let text = json[i]["text"].stringValue
                    let icon = json[i]["icon"].stringValue
                    let response = json[i]["response"].stringValue
                    if response != "" {
                        stillmoreactivites = false
                        charlie++
                    } else if type == "" {
                        stillmoreactivites = false
                        charlie++
                    } else {
                        banana++
                        i++
                        print("QUESTION ID \(id!)")
                        print(text)
                        print(type)
                        print(icon)
                        var shit = "\(id!)"
                        var array = [text, icon, type, shit] as NSArray
                        self.newItems.arrayByAddingObject(array)
                        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
                        var globalActivities: NSArray = []
                        var activitytitlearray = defaults?.dictionaryRepresentation().keys.array
                        for (var p = 0; p < activitytitlearray!.count-1; p++) {
                            var thisobjectatindexp = activitytitlearray![p] as? String
                            if thisobjectatindexp! == "globalActivities" {
                                globalActivities = defaults?.objectForKey("globalActivities") as! NSArray
                            }
                        }
                        print("CURRENT GLOBAL")
                        print(globalActivities)
                        var jeanie = globalActivities.arrayByAddingObject(array)
                        print("SAVING THIS AS NEW GLOBAL")
                        print(jeanie)
                        defaults?.setObject(jeanie, forKey: "globalActivities")
                        self.notifysomeone(icon, type: type)
                        print("DIDTHATWORK&&&&&&&&&&&&&&&&&&&&&&&")
                    }
                }
            }
            task.resume()
        }
        if banana != 0 {
            return true
        } else {
            return false
        }
    }
    
    func notifysomeone(icon: String, type: String) {
        print("SENDINGNOTIFICATION")
        let localNotification = UILocalNotification()
        localNotification.soundName = "beep-01a.wav"
        if icon == "signal.png" {
            localNotification.alertTitle = "Yammer Feedback Requested."
            localNotification.alertBody = "Yammer Feedback Requested"
            //"Please complete the Activity or Question on the Apple Watch! Thank you!"
            localNotification.category = "signal"
        } else if icon == "value.png" {
            localNotification.alertTitle = "Yammer Feedback Requested."
            localNotification.alertBody = "Yammer Feedback Requested"
            localNotification.category = "value"
        } else if icon == "helpful.png" {
            localNotification.alertTitle = "Yammer Feedback Requested."
            localNotification.alertBody = "Yammer Feedback Requested"
            localNotification.category = "helpful"
        } else if icon == "space.png" {
            localNotification.alertTitle = "Yammer Feedback Requested."
            localNotification.alertBody = "Yammer Feedback Requested"
            localNotification.category = "space"
        } else {
            localNotification.alertTitle = "An activity has been sent to you!"
            localNotification.alertBody = "Yammer Feedback Requested"
            localNotification.category = "Default"
        }
        if type != "activity" {
            localNotification.alertTitle = "New Question!"
            localNotification.alertBody = "New Question"
        }
        localNotification.alertAction = "Now"
        
        //print(seconds, appendNewline: false)
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 2)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        fetchNewItems()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            if(background != nil){ background!(); }
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()) {
                if(completion != nil){ completion!(); }
            }
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        fetchNewItems()
        
        myTimer = NSTimer.scheduledTimerWithTimeInterval(4.0,
            target: self,
            selector: "fetchNewItemz:",
            userInfo: nil,
            repeats: true)
        
        backgroundTaskIdentifier =
            application.beginBackgroundTaskWithName("task1",
                expirationHandler: {[weak self] in
                    self!.endBackgroundTask()
                })
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        if (defaults?.objectForKey("CorpID") != nil) {
            print("here we are")
            let root : ViewController = self.window!.rootViewController! as! SummerCamp.ViewController
            let master : middle2ViewController = middle2ViewController() as middle2ViewController
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        backgroundThread(delay: 30.0, background: {
            print("in motion")
            master.checkServer()
            var timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkServe", userInfo: nil, repeats: true)
        });
        }
    }
    
    func checkServe() {
        print("CheckServe called from AppDelegate.swift")
        let root : UINavigationController = self.window!.rootViewController! as! UINavigationController
        if let master : middle2ViewController = root.topViewController as? middle2ViewController {
            master.checkServer()
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        if backgroundUpdateTask != UIBackgroundTaskInvalid{
            endBackgroundTask()
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func endBackgroundTask(){
        
        let mainQueue = dispatch_get_main_queue()
        
        dispatch_async(mainQueue, {[weak self] in
            if let timer = self!.myTimer{
                timer.invalidate()
                self!.myTimer = nil
                UIApplication.sharedApplication().endBackgroundTask(
                    self!.backgroundTaskIdentifier)
                self!.backgroundTaskIdentifier = UIBackgroundTaskInvalid
            }
            })
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ucb.apps.dev.SummerCamp" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SummerCamp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SummerCamp.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}