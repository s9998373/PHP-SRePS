//
//  DataAdapters.swift
//  PHP-SRePS
//
//  Created by School on 20/09/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

/// Uses to provide static objects that are used in various areas throughout PHP-SRePS.
/// There is no reason to create these objects more than once.
class DataAdapters {
    
    /// A date formatter yyyy-MM-dd
    ///
    /// - returns: The configured date formatter.
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
    
    /// A date and time formatter yyyy-MM-dd HHmmss
    ///
    /// - returns: The configured date formatter.
    static func dateTimeFormatter() -> NSDateFormatter{
        struct Singleton {
            static let instance = NSDateFormatter()
            static let initialised = false;
        }
        
        if (!Singleton.initialised) {
            Singleton.instance.dateFormat = "yyyy-MM-dd HHmmss"
        }
        
        return Singleton.instance
    }
    
    /// A number formatter, for currency style numbers.
    ///
    /// - returns: The configured number formatter.
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
    
    /// A standard calendar that requires four days in the first week of the year.
    ///
    /// - returns: The configured calendar.
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
