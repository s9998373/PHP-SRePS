//
//  Transaction.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit
import RealmSwift

class Transaction: Object {
    dynamic var name = ""
    dynamic var picture: NSData? = nil // optionals supported
    let items = List<Product>()
    
    
    
    func addProduct(product: Product){
        items.append(product)
    }
    
    func removeProduct(product: Product){
        items.delete(product)
    }

}
