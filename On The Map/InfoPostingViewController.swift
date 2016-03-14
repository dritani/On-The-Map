//
//  InfoPostingViewController.swift
//  On The Map
//
//  Created by Dritani on 2016-03-09.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class InfoPostingViewController: UIViewController, UITextFieldDelegate {

    
    var keyboardOnScreen = false
    var location = ""
    var coordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var debugField: UILabel!
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationField.delegate = self
        linkField.delegate = self
        subscribeToNotification(UIKeyboardWillShowNotification, selector: "keyboardWillShow:")
        subscribeToNotification(UIKeyboardWillHideNotification, selector: "keyboardWillHide:")
        subscribeToNotification(UIKeyboardDidShowNotification, selector: "keyboardDidShow:")
        subscribeToNotification(UIKeyboardDidHideNotification, selector: "keyboardDidHide:")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findPressed(sender: AnyObject) {
        let coordinates:CLLocationCoordinate2D
        let geocoder = CLGeocoder()
        location = locationField.text!
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                self.debugField.text = "Error in geocoding."
            }
            if let placemark = placemarks?.first {
                var coordinates:CLLocationCoordinate2D!
                coordinates = placemark.location!.coordinate
                self.coordinates = coordinates
                let regionRadius: CLLocationDistance = 10000
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates,
                    regionRadius * 2.0, regionRadius * 2.0)
                self.theMap.setRegion(coordinateRegion, animated: true)
                let me = Student(title: "\(Constants.firstName) \(Constants.lastName)",
                    link: "",
                    coordinate: coordinates)
                self.theMap.addAnnotation(me)
                self.topLabel.hidden = true
                self.linkField.hidden = false
                //self.midView.hidden = true
                self.locationField.hidden = true
                self.debugField.hidden = true
                self.theMap.hidden = false
                self.findButton.hidden = true
                self.submitButton.hidden = false
                
                
            }
        })
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        ParseAPI.sharedInstance().parsePost(Constants.uniqueID, firstName: Constants.firstName, lastName: Constants.lastName, mapString: location, URL: linkField.text!, latitude: coordinates.latitude, longitude: coordinates.longitude,completion:({(complete) in
            dispatch_async(dispatch_get_main_queue(), {
                if complete == true {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }))
    }

    
    // Keyboard functions
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
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
