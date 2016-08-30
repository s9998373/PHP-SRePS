//
//  SaleTransaction.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit
import RealmSwift

class SaleTransaction: Object {
    dynamic var name = ""
    dynamic var picture: NSData? = nil // optionals supported
    let items = List<SaleProduct>()
    
    
    
    func addProduct(product: SaleProduct){
        items.append(product)
    }
    
    func removeProduct(product: SaleProduct){
        items.delete(product)
    }

}
