//
//  ParseAPI.swift
//  On The Map
//
//  Created by Dritani on 2016-03-10.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import Foundation
import MapKit

private let sharedParse = ParseAPI()

class ParseAPI {
    
    class func sharedInstance() -> ParseAPI {
        return sharedParse
    }
    
    func parseGet(viewController: UIViewController, completion: (complete:Bool)->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            func displayError(error: String) {
                print(error)
                performUIUpdatesOnMain {
                    self.alert("The download failed.", viewController: viewController)
                    print("Login Failed (Request Token).")
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            let parsedResult: AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let results = parsedResult["results"] as? [[String: AnyObject]] else {
                displayError("Cannot find results key")
                return
            }
            
            performUIUpdatesOnMain {
                var student: StudentInformation
                
                for i in 0...99 {
                    let result = results[i]
                    let student = StudentInformation(dictionary: result)
                    StudentList.sharedInstance().students.append(student)
                    
//                    let fullName = (result["firstName"] as! String)  + " " + (result["lastName"] as! String)
//                    let link = result["mediaURL"] as! String
//                    let coordinate = CLLocationCoordinate2D(latitude: result["latitude"] as! Double, longitude: result["longitude"] as! Double)
//                    
//                    let student = Student(title: fullName, link: link, coordinate: coordinate)
//                    
//                    
//                    let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
//                    applicationDelegate.students.append(student)

                }
                
                completion(complete:true)
                return

            }
            
        }
        
        task.resume()
    }
    
    func parsePost(uniqueID: String, firstName: String, lastName: String, mapString: String, URL: String, latitude: Double, longitude: Double, viewController: UIViewController, completion: (complete:Bool)->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueID)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(URL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                performUIUpdatesOnMain {
                    self.alert("Posting failed.", viewController: viewController)
                }

                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            completion(complete:true)
            return
        }
        task.resume()
    }
    
    func alert(message: String, viewController: UIViewController) {
        
        let alertController = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        viewController.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
    
}
