//
//  LoginViewController.swift
//  On The Map
//
//  Created by Dritani on 2016-03-07.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import UIKit
import MapKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var students: [Student] = []
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var keyboardOnScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        subscribeToNotification(UIKeyboardWillShowNotification, selector: "keyboardWillShow:")
        subscribeToNotification(UIKeyboardWillHideNotification, selector: "keyboardWillHide:")
        subscribeToNotification(UIKeyboardDidShowNotification, selector: "keyboardDidShow:")
        subscribeToNotification(UIKeyboardDidHideNotification, selector: "keyboardDidHide:")
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }

    @IBAction func loginPressed(sender: AnyObject) {
        if emailField.text!.isEmpty || passwordField.text!.isEmpty {
            print("Username or Password Empty.")
        } else {

            UdacityAPI.sharedInstance().udacityLogin(emailField.text!, password: passwordField.text!, completion: {
                (complete) in
                if (complete != nil) {
                    ParseAPI.sharedInstance().parseGet({(complete) in
                        dispatch_async(dispatch_get_main_queue(), {
                            if complete == true {
                                self.performSegueWithIdentifier("afterLogin", sender: self)
                            }
                        })
                    })
                }
            })
        }
        
    }

    @IBAction func signUp(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string:"https://www.udacity.com/account/auth#!/signup")!)
    }
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
            //movieImageView.hidden = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
            //movieImageView.hidden = false
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
}





