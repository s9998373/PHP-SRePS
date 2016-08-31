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
    
    convenience init(aProduct: Product, aQuanity: Int){
        self.init();
        self.product = aProduct;
        self.quantity = aQuanity;
    }
}
