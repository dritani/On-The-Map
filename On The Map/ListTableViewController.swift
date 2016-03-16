//
//  ListTableViewController.swift
//  On The Map
//
//  Created by Dritani on 2016-03-12.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    

    
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
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("infoPosting2") as! InfoPostingViewController
        self.navigationController!.presentViewController(detailController, animated: true, completion: nil)
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        StudentList.sharedInstance().students.removeAll()
        theTable.reloadData()
        ParseAPI.sharedInstance().parseGet(self,completion: {(complete) in
            dispatch_async(dispatch_get_main_queue(), {
                if complete == true {
                    self.theTable.reloadData()
                }
            })
        })
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentList.sharedInstance().students.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("student2") as! ListCell
        
        let student = StudentList.sharedInstance().students[indexPath.row]
        
        cell.studentName.text = "\(student.firstName) \(student.lastName)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = StudentList.sharedInstance().students[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL)!)
    }
}
