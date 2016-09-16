//
//  DataAdapters.swift
//  PHP-SRePS
//
//  Created by School on 20/09/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

class DataAdapters {
    static func dateFormatter() -> NSDateFormatter{
        struct Singleton {
            static let instance = NSDateFormatter()
            static let initialised = false;
        }
        
        if (!Singleton.initialised) {
            Singleton.instance.dateFormat = "yyyy-MM-dd"
        }
        
        return Singleton.instance
    }
    
    static func numberFormatter() -> NSNumberFormatter{
        struct Singleton {
            static let instance = NSNumberFormatter()
            static let initialised = false;
        }
        
        if (!Singleton.initialised) {
            Singleton.instance.numberStyle = .CurrencyAccountingStyle
            Singleton.instance.locale = NSLocale.currentLocale()
        }
        
        return Singleton.instance
    }
    
    static func calendar() -> NSCalendar{
        struct Singleton {
            static let instance = NSCalendar.currentCalendar()
            static let initialised = false;
        }
        
        if (!Singleton.initialised) {
            Singleton.instance.minimumDaysInFirstWeek = 4
        }
        
        return Singleton.instance
    }

}
