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
    
    convenience init(date: NSDate) {
        self.init()
        self.date = date;
    }
    
    func addSalesEntry(salesEntry: SalesEntry){
//        SalesDataSource.safeWriteBlock { (result) in
        SalesDataSource.openWrite()
        self.items.append(salesEntry)
        SalesDataSource.closeWrite()
//        }
    }
    
    func descriptiveString() -> String{
        var numberOfItems = 0
        let numberOfItemTypes = items.count
        for item in items {
            numberOfItems += item.quantity
        }
        struct constant{
            static let pluralProduct = "products"
            static let pluralItem = "items"
            static let singleProduct = "products"
            static let singleItem = "items"
        }
        
        var productString:String, itemString:String
        if (numberOfItems == 1) {
            itemString = constant.singleItem
        }else{
            itemString = constant.pluralItem
        }
        if (numberOfItemTypes == 1) {
            productString = constant.singleItem
        }else{
            productString = constant.pluralItem
        }
        
        let result = "\(numberOfItemTypes) \(productString), \(numberOfItems). \(itemString)"
        
        return result
    }
    
    func dateString() -> String{
        return dateFormatter().stringFromDate(self.date!)
    }
    
    func dateFormatter() -> NSDateFormatter{
        struct Singleton {
            static let instance = NSDateFormatter()
            static let initialised = false;
        }
        
        if (!Singleton.initialised) {
            Singleton.instance.dateFormat = "yyyy-MM-dd"
        }
        
        return Singleton.instance
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
