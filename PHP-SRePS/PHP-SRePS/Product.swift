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
}
