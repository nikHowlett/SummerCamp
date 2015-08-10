//
//  middle2ViewController.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/7/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import CoreData

class middle2ViewController: UIViewController {

    var corpAcc: String?
    var thereforeName: String?
    var people = [NSManagedObject]()
    var activities: [Activity] = [Activity]()
    var employees: [Employee] = [Employee]()
    var activitiesonly: [Activity] = [Activity]()
    var magikString: String?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    func handleWatchKitNotification(notification: NSNotification) {
        if let userInfo = notification.object as? [String : String] {
            //save survey results!
            print("Watchnotification received")
            magikString = userInfo["message"]!
            if magikString! == "Yammer" {
                print("it is possible that this will open yammer")
                var instagramHooks = "window.open('yammer://threads')"
                instagramHooks = "yammer://threads"
                var instagramUrl = NSURL(string: instagramHooks)
                if UIApplication.sharedApplication().canOpenURL(instagramUrl!) {
                    UIApplication.sharedApplication().openURL(instagramUrl!)
                } else {
                    //redirect to safari because the user doesn't have Yammer
                    println("App not installed")
                    UIApplication.sharedApplication().openURL(NSURL(string:"https://itunes.apple.com/us/app/yammer/id289559439?mt=8")!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Activities"
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Activity")
        let fetchRequest2 : NSFetchRequest = NSFetchRequest(entityName: "Employee")
        activities = []
        employees = []
        activitiesonly = []
        if (activitiesonly.count == 0) {
            activitiesonly = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
                as! [Activity]
            employees = managedObjectContext?.executeFetchRequest(fetchRequest2, error: nil)
                as! [Employee]
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleWatchKitNotification:"), name: "WatchKitReq", object: nil)
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        //corpAcc = defaults!.stringForKey("CorpID")!;
        //corpAcc = defaults!.valueForKey("CorpID")! as? String;
        corpAcc = employees[employees.count-1].corpID
        defaults?.synchronize()
        print(corpAcc)
        checkServer()
        backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            //self.checkServer()
            //print("Dispatch Timer")
            var timer2 = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "checkServer", userInfo: nil, repeats: true)
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
        } else {
            return nil
        }
        }()
    
    
    func checkServer() {
        //check for an update
        /* The app checks for actions
        Periodically (every 2 mins) the app will request actions from the server (u=U026686&a=q)
        If a polling request exists for the user the server will return the session (s=3+5&a=p)
        */
        print("checkServer called!!!!!!!!")
        let thisCorpacc = corpAcc!
        let superfirst = "http://sc.ucbweb-acc.com/svc/GetActions"
        let firstpart = "?u=\(thisCorpacc)&a=gp"
        print(thisCorpacc)
        let url = NSURL(string: "\(superfirst)\(firstpart)")
        print(url)
        print("THAT IS THE URL")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let json = JSON(data: data)
            print("RAWJSON: \(json)")
            /*func parseJSON(json: JSON) {
                for result in json["activities"].arrayValue {
                    let type = result["title"].stringValue
                    let id = result["id"].int
                    let text = result["text"].stringValue
                    let icon = result["icon"].stringValue
                    print(type)
                    print("PARSER////////////")
                }
            }*/
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
                } else if type == "" {
                    stillmoreactivites = false
                } else {
                i++
                print("QUESTION ID \(id!)")
                print(text)
                print(type)
                print(icon)
                //self.saveActivity(id!, icon: icon, type: type, text: text)
                    var shit = "\(id!)"
                var array = [text, icon, type, shit] as NSArray
                var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
                var globalActivities: NSArray = []
                var activitytitlearray = defaults?.dictionaryRepresentation().keys.array
                for (var p = 0; p < activitytitlearray!.count-1; p++) {
                    var thisobjectatindexp = activitytitlearray![p] as? String
                    if thisobjectatindexp! == "globalActivities" {
                        globalActivities = defaults?.objectForKey("globalActivities") as! NSArray
                    }
                }
                /*if defaults?.objectForKey("globalActivities") != nil {
                    globalActivities = defaults?.objectForKey("globalActivities") as! NSMutableArray
                }*/
                //defaults?.setObject(array, forKey: "Activity \(id!)")
                //globalActivities.append(array)
                //globalActivities.append("hello")
                globalActivities.arrayByAddingObject(array)
                    //globalActivities.addObject([text, icon, type, shit])
                defaults?.setObject(globalActivities, forKey: "globalActivities")
                //defaults?.synchronize()
                //var thethingusaved = defaults?.objectForKey("Activity \(id)") as! NSArray
                var thingtext: AnyObject = array[2]
                var iconstring = array[1] as? String
                self.notifysomeone(iconstring!)
                print(thingtext)
                    print("DIDTHATWORK&&&&&&&&&&&&&&&&&&&&&&&")
                }
            }
            /* println("Textfield Text: \(usernameTextfield.text)")
            
            var myValue:NSString = usernameTextfield.text
            
            NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"Username")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            var myOutput: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("Username")
            println(myOutput)
*/
        }
        task.resume()
    }

    private func saveActivity(id: Int, icon: String, type: String, text: String) {
        if managedObjectContext != nil {
            let entity = NSEntityDescription.entityForName("Activity", inManagedObjectContext: managedObjectContext!)
            let ucb = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!) as! SummerCamp.Activity
            ucb.id = id
            ucb.icon = icon
            ucb.type = type
            ucb.text = text
            let ucbs = ucb
            activities.append(ucb)
            if ucb.type == "Activity" {
                activitiesonly.append(ucb)
                //add refresh table view!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            }
            var error: NSError? = nil
            managedObjectContext!.save(nil)
        } else {
            print("Could not get managed object context")
        }
    }
    
    func notifysomeone(icIm: String) {
        print("SENDINGNOTIFICATION")
        let localNotification = UILocalNotification()
        localNotification.soundName = "beep-01a.wav"
        if icIm == "activity" {
            localNotification.alertTitle = "New Activity!"
            localNotification.alertBody = "Yammer Feedback Requested."
        } else {
        localNotification.alertTitle = "An activity has been sent to you!"
        localNotification.alertBody = "Please complete the Activity or Question on the Apple Watch! Thank you!"
        }
        localNotification.alertAction = "Now"
        localNotification.category = icIm
        //print(seconds, appendNewline: false)
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 2)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
