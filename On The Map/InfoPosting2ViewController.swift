//
//  InfoPosting2ViewController.swift
//  On The Map
//
//  Created by Dritani on 2016-03-10.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import UIKit
import MapKit

class InfoPosting2ViewController: UIViewController {

    var location: String = ""
    var coordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var theMap: MKMapView!

    @IBAction func submitPressed(sender: AnyObject) {
  
        ParseAPI.sharedInstance().parsePost(Constants.uniqueID, firstName: Constants.firstName, lastName: Constants.lastName, mapString: location, URL: linkField.text!, latitude: coordinates.latitude, longitude: coordinates.longitude,completion:({(complete) in
            dispatch_async(dispatch_get_main_queue(), {
                if complete == true {
                    self.backToMap(true)
                }
            })
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // forward geocoding
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates,
            regionRadius * 2.0, regionRadius * 2.0)
        theMap.setRegion(coordinateRegion, animated: true)
        let me = Student(title: "Me",
            link: "",
            coordinate: coordinates)
        theMap.addAnnotation(me)
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        //backToMap(false)
        back2Map()
    }
    
    func backToMap(posted: Bool) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MavViewController") as! MapViewController
        detailController.posted = posted
        self.navigationController!.presentViewController(detailController, animated: true, completion: nil)
    }
    
    func back2Map() {
        //let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MavViewController") as! MapViewController
        self.navigationController!.popToRootViewControllerAnimated(true)
    }

}
