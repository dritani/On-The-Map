//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Dritani on 2016-03-14.
//  Copyright © 2016 AquariusLB. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}