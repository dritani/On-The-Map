//
//  MapViewController.swift
//  On The Map
//
//  Created by Dritani on 2016-03-07.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var posted:Bool = false
    let applicationDelegate =  (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    @IBOutlet weak var theMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if posted {
            refreshMap()
        }
        theMap.delegate = self
        theMap.addAnnotations(applicationDelegate.students)
    }

    @IBAction func logoutButton(sender: AnyObject) {
        UdacityAPI.sharedInstance().udacityLogout()
        let loginVC = self.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
        self.presentViewController(loginVC, animated: true, completion: nil)

    }
    
    @IBAction func newPin(sender: AnyObject) {
        // push view controller: info posting 1
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("infoPosting") as! InfoPostingViewController
        self.navigationController!.presentViewController(detailController, animated: true, completion: nil) 
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        refreshMap()
    }
    
    func refreshMap() {
        applicationDelegate.students.removeAll()
        theMap.removeAnnotations(theMap.annotations)
        ParseAPI.sharedInstance().parseGet({(complete) in
            dispatch_async(dispatch_get_main_queue(), {
                if complete == true {
                    self.theMap.addAnnotations(self.applicationDelegate.students)
                }
            })
        })
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Student {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = theMap.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let student = view.annotation as! Student
        UIApplication.sharedApplication().openURL(NSURL(string: student.subtitle!)!)
    }
}
    
    
    

