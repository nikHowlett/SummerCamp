//
//  ActivityTableViewController.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/6/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import CoreData

class ActivityTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var corpAcc: String?
    var thereforeName: String?
    var people = [NSManagedObject]()
    var activities: [Activity] = [Activity]()
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
        checkServer()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Activity")
        activities = []
        activitiesonly = []
        if (activitiesonly.count == 0) {
            activitiesonly = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as! [Activity]
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleWatchKitNotification:"), name: "WatchKitReq", object: nil)
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            //self.checkServer()
            //print("Dispatch Timer")
            var timer2 = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "checkServer", userInfo: nil, repeats: true)
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return activitiesonly.count
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
        let url = NSURL(string: "\(superfirst)\(firstpart)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let json = JSON(data: data)
            let id = json["id"].int
            let text = json["text"].stringValue
            let icon = json["icon"].stringValue
            let type = json["type"].stringValue
            print(id)
            print(text)
            print(type)
            print(icon)
            self.saveActivity(id!, icon: icon, type: type, text: text)
            var array = [text, icon, type]
            NSUserDefaults.standardUserDefaults().setObject(array, forKey: "Activity \(id)")
        }
        task.resume()
    }
    
    func notifysomeone() {
        let localNotification = UILocalNotification()
        localNotification.soundName = "beep-01a.wav"
        localNotification.alertTitle = "An activity has been sent to you!"
        localNotification.alertBody = "Please complete the Activity or Question on the Apple Watch! Thank you!"
        localNotification.alertAction = "Now"
        localNotification.category = "surveySession"
        //print(seconds, appendNewline: false)
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 2)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
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
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as! UITableViewCell
        let thisActivity : Activity = activities[indexPath.row] as Activity
        cell.textLabel?.text = thisActivity.text
        cell.detailTextLabel?.text = "\(thisActivity.id)"
        return cell
    }
    
    func surveyAtIndexPath(indexPath: NSIndexPath) -> Activity
    {
        let productLine = activities[indexPath.section]
        return activities[indexPath.row] as Activity
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    /*  /*var serverResponse = NSString(data: data!, encoding: NSUTF8StringEncoding)!
    var serverResponseStr = serverResponse as! String
    var array : [String] = serverResponseStr.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ":{}[], "))
    var jizz = array.count
    var newarray : [String] = []
    
    for (var i=0; i < jizz; i++) {
    var thisone = array[i]
    if thisone == "" {
    
    } else {
    newarray.append(array[i])
    //print(array[i])
    }
    }*/*/

}
