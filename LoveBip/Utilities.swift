//
//  Utilities.swift
//  LoveBip
//
//  Created by Marco Montalto on 25/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

class Utilities {
    
    static func setTimeoutNoRepeat(delay:NSTimeInterval, block:()->Void) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(delay, target: NSBlockOperation(block: block), selector: #selector(NSOperation.main), userInfo: nil, repeats: false)
    }
}
