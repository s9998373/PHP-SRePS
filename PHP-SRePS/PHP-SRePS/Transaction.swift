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
    dynamic var date:NSDate? = nil
    dynamic var totalCost:String? = nil
    
    func addSalesEntry(salesEntry: SalesEntry){
//        SalesDataSource.safeWriteBlock { (result) in
        SalesDataSource.openWrite()
        self.items.append(salesEntry)
        SalesDataSource.closeWrite()
//        }
    }
    
    func removeSalesEntry(salesEntry: SalesEntry){
        let idx = indexOfProduct(salesEntry.product!)
        if idx != NSNotFound {
            items.removeAtIndex(idx)
        }
    }
    
    func mergeSalesEntry(salesEntry: SalesEntry){
        var oldEntry: SalesEntry!
        for entry in items{
            if entry.product!.name == salesEntry.product!.name{
                oldEntry = entry
                break
            }
        }
        
        oldEntry.quantity += salesEntry.quantity
    }
    
    func doesProductExistInTransaction(product: Product) -> Bool{
//        for entry in items{
//            if entry.product!.name == product.name {
//                return true;
//            }
//        }
        let idx = indexOfProduct(product)
        return idx != NSNotFound
    }
    
    func updateSalesEntry(oldSalesEntry: SalesEntry, newSalesEntry: SalesEntry){
        let idx = items.indexOf(oldSalesEntry);
        if idx == NSNotFound {
            // Couldn't find.
            print("Unable to find entry.");
            return;
        }
        
        items.replace(idx!, object: newSalesEntry);
    }
    
    func indexOfProduct(product : Product) -> Int{
        for entry in items{
            if entry.product == product{
                return items.indexOf(entry)!
            }
        }
        return NSNotFound
    }
    
    func salesEntryAtIndex(index: Int) -> SalesEntry{
        return items[index]
    }
    
    func numberOfItems() -> Int{
        return self.items.count
    }
    
    func calculateTotal(){
        var total = NSDecimalNumber.init(long: 0)
        for entry in items{
            total = total.decimalNumberByAdding(entry.decimalCost())
        }
        totalCost = total.stringValue
    }

}
