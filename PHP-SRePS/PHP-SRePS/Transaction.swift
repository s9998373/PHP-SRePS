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
    let items = List<SalesEntry>()
    
    func addSalesEntry(salesEntry: SalesEntry, qty: Int){
        
        items.append(salesEntry)
    }
    
    func removeSalesEntry(salesEntry: SalesEntry, qty: Int){
        items.delete(salesEntry)
    }
    
    func updateSalesEntry(salesEntry: SalesEntry, qty: Int){
        let idx = items.indexOf(salesEntry);
        if idx == NSNotFound {
            // Couldn't find.
            print("Unable to find entry.");
            return;
        }
        
        items.replace(idx!, object: salesEntry);
    }

}
