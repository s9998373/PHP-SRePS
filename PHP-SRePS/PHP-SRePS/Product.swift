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
        _price = aPrice;
    }
    
    static let formatter = NSNumberFormatter()
    
    func localisedPrice() -> String{
//        let decimal = NSDecimalNumber.init(string: price) as NSDecimalNumber
        return DataAdapters.numberFormatter().stringFromNumber(self.price)!
    }
}
