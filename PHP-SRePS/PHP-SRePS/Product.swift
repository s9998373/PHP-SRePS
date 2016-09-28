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

public class Product: Object {
    dynamic var name = ""
//    dynamic var price:String? = "0"
    private dynamic var _price = ""
    
    public var price: NSDecimalNumber {
        get { return NSDecimalNumber(string: _price) }
        set { _price = newValue.stringValue }
    }
    
    public override class func ignoredProperties() -> [String] {
        return ["price"]
    }
    
    convenience init(aName: String, aPrice: String){
        self.init();
        self.name = aName;
        self.price = NSDecimalNumber.init(string: aPrice);
    }
    
    static let formatter = NSNumberFormatter()
    
    /// Returns a localised string with currency symbol.
    ///
    /// - returns: A price prefixed with a currency symbol.
    func localisedPrice() -> String{
        let ret = DataAdapters.numberFormatter().stringFromNumber(self.price)!
        return ret
    }
}
