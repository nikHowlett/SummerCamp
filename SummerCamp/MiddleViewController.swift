//
//  MiddleViewController.swift
//  SummerCamp
//
//  Created by MAC-ATL019922 on 8/6/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit

class MiddleViewController: UIViewController {

    var corpAcc: String?
    var thereforeName: String?
    @IBOutlet weak var employee_name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(corpAcc!)
        print(thereforeName!)
        employee_name.text = thereforeName!
        var defaults = NSUserDefaults(suiteName: "group.UCBAuth")
        defaults?.synchronize()
        var chewtoy = thereforeName! as NSString
        if (chewtoy.length < 2) {
            print("damnit")
        } else {
            NSUserDefaults.standardUserDefaults().setObject(thereforeName!, forKey: "Name")
            NSUserDefaults.standardUserDefaults().setObject(corpAcc!, forKey: "CorpID")
            print("Name and CORPID saved")
        }
        jerry()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func jerry() {
        self.performSegueWithIdentifier("next", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "next" {
            print("NEXTNEXTNEXT")
            if let happinessViewController = segue.destinationViewController as? ActivityTableViewController {
                happinessViewController.corpAcc = corpAcc!
                happinessViewController.thereforeName = thereforeName!
            }
        }
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
