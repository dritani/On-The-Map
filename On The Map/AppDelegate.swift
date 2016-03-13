//
//  AppDelegate.swift
//  On The Map
//
//  Created by Dritani on 2016-02-09.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import UIKit

// MARK: - AppDelegate: UIResponder, UIApplicationDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    
    var window: UIWindow?
    
    var students = [Student]()
    
    // MARK: UIApplicationDelegate
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // if necessary, update the configuration...
        
        return true
    }
}

