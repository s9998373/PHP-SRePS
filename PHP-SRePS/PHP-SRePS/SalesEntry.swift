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
    dynamic var _product:Product? = nil
    var product: Product? {
        get {
            return _product
        }
        set {
            _product = newValue!
            calculateTotalCost()
        }
    }
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
    
    convenience init(product: Product, quanity: Int){
        self.init();
        _product = product;
        _quantity = quanity;
        calculateTotalCost()
        
//        let itemPrice = NSDecimalNumber(string: aProduct.price)
    }
    
//    dynamic var quantity:Int{
//        set{
//            _quantity = newValue
//            calculateTotalCost()
//        }
//        get{
//            return _quantity
//        }
//    }
//    
//    dynamic var product:Product{
//        set{
//            _product = newValue
//            calculateTotalCost()
//        }
//        get{
//            return _product!
//        }
//    }
    
    func calculateTotalCost(){
        let total = _product!.price.decimalNumberByMultiplyingBy(NSDecimalNumber.init(long: _quantity))
        totalCost = total.stringValue
    }
    
//    func totalCostString() -> String{
//        return
//    }
//    
//    func quantity() -> Int{
//        
//    }
    
    func decimalCost() -> NSDecimalNumber{
        let cost = NSDecimalNumber.init(string: totalCost)
        return cost
    }
}
