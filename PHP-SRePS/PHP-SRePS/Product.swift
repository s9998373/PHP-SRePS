//
//  Product.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class Product: Object {
    dynamic var name = ""
    dynamic var price = ""
    
    convenience init(aName: String, aPrice: String){
        self.init();
        self.name = aName;
        self.price = aPrice;
    }
    
    static let formatter = NSNumberFormatter()
    
    func localisedPrice() -> String{
        let decimal = NSDecimalNumber.init(string: price) as NSDecimalNumber
        return numberFormatter().stringFromNumber(decimal)!
    }
    
    func numberFormatter() -> NSNumberFormatter{
        struct Singleton {
            static let instance = NSNumberFormatter()
            static let initialised = false;
        }
        
        if (!Singleton.initialised) {
            Singleton.instance.numberStyle = .CurrencyStyle
            Singleton.instance.locale = NSLocale.systemLocale()
        }
        
        return Singleton.instance
    }
}
