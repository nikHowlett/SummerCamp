//
//  middle2ViewController.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/7/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import CoreData

class middle2ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var corpAcc: String?
    var thereforeName: String?
    var people = [NSManagedObject]()
    var activities: [NSArray] = [NSArray]()
    var employees: [Employee] = [Employee]()
    var activitiesonly: [NSArray] = [NSArray]()
    var magikString: String?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableOutlet: UITableView!
    var globalActivities = []
    var mustReloadView = false
    var newItems: [NSArray] {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.newItems as! [NSArray]
    }
    
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
            } else {
                sendResponse(magikString!)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return activitiesonly.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        var shrinkage = activitiesonly[indexPath.row][0] as? String
        var shrinkage4 = shrinkage! as NSString
        var indexer = "What elements from the workpl"
        if shrinkage4.length > 29 {
            shrinkage = shrinkage!.substringToIndex(indexer.endIndex)
        }
        var shrinkage3 = "\(shrinkage)..."
        cell.textLabel!.text = activitiesonly[indexPath.row][3] as? String
        cell.detailTextLabel!.text = activitiesonly[indexPath.row][0] as? String
        
        //var image : UIImage = UIImage(named: activitiesonly[indexPath.row])!
        //cell.imageView!.image = image
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var indx = 0
            var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
            var newArray = []
            if globalActivities.containsObject(activitiesonly[indexPath.row]) {
                indx = globalActivities.indexOfObject(activitiesonly[indexPath.row])
                for (var u = 0; u < globalActivities.count-1; u++) {
                    var thisObj = globalActivities[u] as! NSArray
                    newArray = newArray.arrayByAddingObject(thisObj)
                }
                defaults?.setObject(newArray, forKey: "globalActivities")
            }
            activitiesonly.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var rownumber = indexPath.row
        var sdf = indexPath
        let alertController = UIAlertController(title: "Activity Selected", message:
            "Have you completed this Activity and would like to remove it from your Activity List?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title:"Yes", style: UIAlertActionStyle.Default,handler: {alertAction in
            let superfirst = "http://sc.ucbweb-acc.com/svc/GetActions"
            var quesid = self.activitiesonly[indexPath.row][3] as! String
            let firstpart = "?u=\(self.corpAcc!)&a=r&id=\(quesid)&r=1"
            self.sendResponse("\(superfirst)\(firstpart)")
            self.deletedat(rownumber, sdf: sdf)
        }))
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
        /*if   dataToDisplay[rownumber] == sampleData[0] {
            println("red")
        }*/
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
        }()
    
    func deletedat(rownumber: Int, sdf: NSIndexPath) {
        var indx = 0
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        var newArray = []
        if self.globalActivities.containsObject(self.activitiesonly[rownumber]) {
            indx = self.globalActivities.indexOfObject(self.activitiesonly[rownumber])
            for (var u = 0; u < self.globalActivities.count-1; u++) {
                if u != indx {
                    var thisObj = self.globalActivities[u] as! NSArray
                    newArray = newArray.arrayByAddingObject(thisObj)
                }
            }
            defaults?.setObject(newArray, forKey: "globalActivities")
        }
        self.activitiesonly.removeAtIndex(rownumber)
        self.tableOutlet.reloadData()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.synchronize()
        var globalShave = []
        if (defaults?.objectForKey("globalActivities") != nil) {
            globalShave = defaults?.objectForKey("globalActivities") as! NSArray
            globalActivities = defaults?.objectForKey("globalActivities") as! NSArray
        }
        print(globalActivities)
        if (activitiesonly.count == 0) {
            var activz = activitiesonly as NSArray
            for (var y = 0; y <= globalShave.count-1; y++) {
                var wattype = (globalShave[y][2] as! String)
                if wattype == "activity" {
                    if activz.containsObject(globalShave[y]) {
                    } else {
                        activz = activz.arrayByAddingObject(globalShave[y])
                        (globalShave[y] as! NSArray)
                        print("activz")
                        print(activz)
                        print("activzend")
                    }
                }
            }
            activitiesonly = activz as! [NSArray]
        }
        self.tableOutlet.reloadData()
        refreshControl.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Activities"
        self.tableOutlet.addSubview(self.refreshControl)
        activities = []
        employees = []
        activitiesonly = []
        globalActivities = []
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        defaults?.synchronize()
        thereforeName = defaults?.objectForKey("Name") as? String
        corpAcc = (defaults?.objectForKey("CorpID") as! String)
        welcomeLabel.text = "Welcome \(thereforeName!)!"
        if corpAcc != nil {
            if thereforeName != nil {
                checkServer()
            }
        }
        var globalShave = []
        if (defaults?.objectForKey("globalActivities") != nil) {
            globalShave = defaults?.objectForKey("globalActivities") as! NSArray
            globalActivities = defaults?.objectForKey("globalActivities") as! NSArray
        }
        if (activitiesonly.count == 0) {
            for (var y = 0; y <= globalShave.count-1; y++) {
                var wattype = (globalShave[y][2] as! String)
                if wattype == "activity" {
                    var activz = activitiesonly as NSArray
                    if activz.containsObject(globalShave[y]) {
                    } else {
                        activitiesonly.append(globalShave[y] as! NSArray)
                    }
                }
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleWatchKitNotification:"), name: "WatchKitReq", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNewItemsChanged:", name: AppDelegate.newItemsChangedNotification(), object: nil)
        /*NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleAppIsBroughtToForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)*/
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
    
    func handleAppIsBroughtToForeground(notification: NSNotification) {
        if mustReloadView  {
            tableOutlet.reloadData()
        }
        /*for (var x = 0; x < newItems.count; x++) {
            notifysomeone(newItems[x][1] as! String, type: newItems[x][2] as! String)
        }*/
    }
    
    func handleNewItemsChanged(notification: NSNotification) {
        if self.isBeingPresented() {
            tableOutlet.reloadData()
        } else {
            mustReloadView = true
        }
        for (var x = 0; x < newItems.count; x++) {
            notifysomeone(newItems[x][1] as! String, type: newItems[x][2] as! String)
        }
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
    
    func sendResponse(url: String) {
        var url2use = NSURL(string: "\(url)")
        print(url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url2use!) {(data, response, error) in
            let json = JSON(data: data)
            print("RAWJSON: \(json)")
        }
        task.resume()
    }
    
    func checkServer() {
        //check for an update
        /* The app checks for actions
        Periodically (every 2 mins) the app will request actions from the server (u=U026686&a=q)
        If a polling request exists for the user the server will return the session (s=3+5&a=p)
        */
        var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
        var thisCorpacc = ""
        print("checkServer called!!!!!!!!")
        if (defaults?.objectForKey("CorpID") != nil) {
            thisCorpacc = (defaults?.objectForKey("CorpID") as! String)
        } else {
            thisCorpacc = corpAcc!
        }
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
                var defaults = NSUserDefaults(suiteName: "group.ucb.apps.meetingassist")
                var globalActivities: NSArray = []
                    if (defaults?.objectForKey("globalActivities") != nil) {
                        //globalShave = defaults?.objectForKey("globalActivities") as! NSArray
                        globalActivities = defaults?.objectForKey("globalActivities") as! NSArray
                    }
                /*print("CURRENT GLOBAL")
                    print(globalActivities)
                /*if defaults?.objectForKey("globalActivities") != nil {
                    globalActivities = defaults?.objectForKey("globalActivities") as! NSMutableArray
                }*/
                //defaults?.setObject(array, forKey: "Activity \(id!)")
                //globalActivities.append(array)
                //globalActivities.append("hello")
                    
                    var beanie: NSArray = [array]
                var jeanie = beanie.arrayByAddingObject(globalActivities)
                    print("SAVING THIS AS NEW GLOBAL")
                    print(jeanie)
                    //globalActivities.addObject([text, icon, type, shit])
                defaults?.setObject(jeanie, forKey: "globalActivities")
                //defaults?.synchronize()
                //var thethingusaved = defaults?.objectForKey("Activity \(id)") as! NSArray
                //var thingtext: AnyObject = array[2]
                //var iconstring = array[1] as? String*/
                    print("CURRENT GLOBAL")
                    print(globalActivities)
                    var beanie: NSArray = [array]
                    for (var fd = 0; fd <= globalActivities.count-1; fd++) {
                        beanie = beanie.arrayByAddingObject(globalActivities[fd])
                    }
                    print("SAVING THIS AS NEW GLOBAL")
                    print(beanie)
                    defaults?.setObject(beanie, forKey: "globalActivities")
                self.notifysomeone(icon, type: type)
                //print(thingtext)
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

    /*private func saveActivity(id: Int, icon: String, type: String, text: String) {
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
    }*/
    
    func notifysomeone(icon: String, type: String) {
        print("SENDINGNOTIFICATION")
        let localNotification = UILocalNotification()
        localNotification.soundName = "beep-01a.wav"
        if icon == "signal.png" {
            localNotification.alertTitle = "Yammer Feedback Requested."
            localNotification.alertBody = "Yammer Feedback Requested."
            localNotification.category = "signal"
        } else if icon == "value.png" {
            localNotification.alertTitle = "Yammer Feedback Requested."
            localNotification.alertBody = "Yammer Feedback Requested."
            localNotification.category = "value"
        } else if icon == "helpful.png" {
            localNotification.alertTitle = "Yammer Feedback Requested."
            localNotification.alertBody = "Yammer Feedback Requested."
            localNotification.category = "helpful"
        } else if icon == "space.png" {
            localNotification.alertTitle = "Yammer Feedback Requested."
            localNotification.alertBody = "Yammer Feedback Requested."
            localNotification.category = "space"
        } else {
        localNotification.alertTitle = "An activity has been sent to you!"
        localNotification.alertBody = "New Activity!"
            //"Please complete the Activity or Question on the Apple Watch! Thank you!"
        localNotification.category = "Default"
        }
        if type != "activity" {
            localNotification.alertTitle = "New Question!"
            localNotification.alertBody = "New Question!"
        }
        localNotification.alertAction = "Now"
        
        //print(seconds, appendNewline: false)
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 2)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    /*
    // MARK: - Navigation
    //corpAcc = defaults!.stringForKey("CorpID")!;
    //corpAcc = defaults!.valueForKey("CorpID")! as? String;
    //corpAcc = employees[employees.count-1].corpID
    //defaults?.synchronize()
    //print(corpAcc)
    /*let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Activity")
    let fetchRequest2 : NSFetchRequest = NSFetchRequest(entityName: "Employee")
    activitiesonly = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
    as! [Activity]
    employees = managedObjectContext?.executeFetchRequest(fetchRequest2, error: nil)
    as! [Employee]
    }*/
    //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
