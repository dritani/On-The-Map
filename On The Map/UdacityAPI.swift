//
//  UdacityAPI.swift
//  On The Map
//
//  Created by Dritani on 2016-03-10.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import Foundation
import UIKit

private let sharedUdacity = UdacityAPI()

class UdacityAPI {
    
    class func sharedInstance() -> UdacityAPI {
        return sharedUdacity
    }
    
    func udacityLogin(email:String, password:String, viewController: UIViewController, completion: (complete: Bool?) -> Void) {
        
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
    
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        
        func displayError(error: String) {
            print(error)
            performUIUpdatesOnMain {
                print("Login Failed (Request Token).")
            }
        }
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            
            performUIUpdatesOnMain {
                self.alert("The connection failed.", viewController: viewController)
            }
            
            displayError("There was an error with your request: \(error)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            performUIUpdatesOnMain {
                self.alert("You've entered the wrong credentials.", viewController: viewController)
            }
            

            displayError("Your request returned a status code other than 2xx!")
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            displayError("No data was returned by the request!")
            return
        }
        
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
        let parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            displayError("Could not parse the data as JSON: '\(newData)'")
            return
        }
        
        let account = parsedResult["account"] as? [String:AnyObject]
        Constants.uniqueID = (account!["key"] as? String)!
        completion(complete:true)
        return
        
        }

    task.resume()
        
    }
    
    func udacityGet(completion: (complete:Bool?)->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(Constants.uniqueID)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            let parsedResult: AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            let user = parsedResult["user"] as? [String:AnyObject]
            Constants.lastName = (user!["last_name"] as? String)!
            Constants.firstName = (user!["first_name"] as? String)!
            completion(complete:true)
            return
        }
        task.resume()
        
    }

    func udacityLogout() {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
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
