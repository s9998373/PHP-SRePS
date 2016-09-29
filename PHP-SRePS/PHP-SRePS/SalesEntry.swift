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
    
    private dynamic var _quantity:Int = 0
    var quantity: Int? {
        get {
            return _quantity
        }
        set {
            _quantity = newValue!
            calculateTotalCost()
        }
    }
    
    dynamic var totalCost:String? = nil
    
    /// Creates a sales entry from a product and quantity.
    ///
    /// - parameter product: The product.
    /// - parameter quanity: The quantity of the product.
    ///
    /// - returns: The SalesEntry for the product and quantity.
    convenience init(product: Product, quanity: Int){
        self.init();
        self.product = product;
        _quantity = quanity;
        calculateTotalCost()
    }
    
    /// Calculates the total value of the SalesEntry.
    func calculateTotalCost(){
        let total = self.product!.price.decimalNumberByMultiplyingBy(NSDecimalNumber.init(long: _quantity))
        totalCost = total.stringValue
    }
    
    /// Translates the total cost to an NSDecimalNumber.
    ///
    /// - returns: An NSDecimalNumber representation of the total cost.z
    func decimalCost() -> NSDecimalNumber{
        let cost = NSDecimalNumber.init(string: totalCost)
        return cost
    }
}
