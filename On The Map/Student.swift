//
//  Student
//  On The Map
//
//  Created by Dritani on 2016-03-08.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import Foundation
import MapKit

class Student: NSObject, MKAnnotation {
    var title: String?
    var link: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, link: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.link = link
        self.coordinate = coordinate

        super.init()
    }

    var subtitle: String? {
        return link
    }
    
}