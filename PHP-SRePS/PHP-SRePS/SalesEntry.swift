//
//  SalesEntry.swift
//  PHP-SRePS
//
//  Created by School on 24/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit
import RealmSwift

class SalesEntry: Object {
    dynamic var product:Product? = nil
    dynamic var quantity:Int = 0
    dynamic var totalCost:String? = nil
    
    convenience init(aProduct: Product, aQuanity: Int){
        self.init();
        self.product = aProduct;
        self.quantity = aQuanity;
        
        let itemPrice = NSDecimalNumber(string: aProduct.price)
        let total = itemPrice.decimalNumberByMultiplyingBy(NSDecimalNumber.init(long: aQuanity))
        totalCost = total.stringValue
    }
    
    func decimalCost() -> NSDecimalNumber{
        let cost = NSDecimalNumber.init(string: totalCost)
        return cost
    }
}
