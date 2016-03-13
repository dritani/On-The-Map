//
//  ListTableViewController.swift
//  On The Map
//
//  Created by Dritani on 2016-03-12.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    let applicationDelegate =  (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    @IBOutlet var theTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        UdacityAPI.sharedInstance().udacityLogout()
        let loginVC = self.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func newPin(sender: AnyObject) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("infoPosting") as! InfoPostingViewController
        self.navigationController!.presentViewController(detailController, animated: true, completion: nil)
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        applicationDelegate.students.removeAll()
        theTable.reloadData()
        ParseAPI.sharedInstance().parseGet({(complete) in
            dispatch_async(dispatch_get_main_queue(), {
                if complete == true {
                    self.theTable.reloadData()
                }
            })
        })
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicationDelegate.students.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("student2") as! ListCell
        
        let student = applicationDelegate.students[indexPath.row]
        
        cell.studentName.text = student.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = applicationDelegate.students[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: student.subtitle!)!)
    }
}
