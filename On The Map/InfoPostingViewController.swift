//
//  InfoPostingViewController.swift
//  On The Map
//
//  Created by Dritani on 2016-03-09.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import UIKit
import CoreLocation

class InfoPostingViewController: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    
    @IBOutlet weak var debugField: UILabel!
    
    var location = ""
    var coordinates: CLLocationCoordinate2D!
    
    @IBAction func cancelButton(sender: AnyObject) {
        print("WTF")
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MavViewController") as! MapViewController
        self.navigationController!.presentViewController(detailController, animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        
        var coordinates:CLLocationCoordinate2D
        var geocoder = CLGeocoder()
        location = locationField.text!
        
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                self.debugField.text = "Error in geocoding."
            }
            if let placemark = placemarks?.first {
                var coordinates:CLLocationCoordinate2D!
                coordinates = placemark.location!.coordinate
                self.coordinates = coordinates
                // update map here
                //
                //
                self.performSegueWithIdentifier("info2info", sender: self)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailController = segue.destinationViewController as! InfoPosting2ViewController
        detailController.location = locationField.text!
        detailController.coordinates = coordinates

    }

}
