//
//  StudentList.swift
//  On The Map
//
//  Created by Dritani on 2016-03-16.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import Foundation

private let studentList = StudentList()

class StudentList {
    
    class func sharedInstance() -> StudentList {
        return studentList
    }
    
    var students = [StudentInformation]()
    
}
