//
//  StudentInformation.swift
//  On The Map
//
//  Created by Dritani on 2016-03-16.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    
    init(dictionary: [String: AnyObject]) {
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
   }
    
}