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
    
    func salesEntriesChanged(){
        calculateTotal()
    }
    
    func addSalesEntry(salesEntry: SalesEntry){
//        SalesDataSource.safeWriteBlock { (result) in
        SalesDataSource.openWrite()
        self.items.append(salesEntry)
        salesEntriesChanged()
        SalesDataSource.closeWrite()
//        }
    }
    
    func descriptiveString() -> String{
        var numberOfItems = 0
        let numberOfItemTypes = items.count
        for item in items {
            numberOfItems += item.quantity!
        }
        struct constant{
            static let pluralProduct = "products"
            static let pluralItem = "items"
            static let singleProduct = "product"
            static let singleItem = "item"
        }
        
        var productString:String, itemString:String
        if (numberOfItems == 1) {
            itemString = constant.singleItem
        }else{
            itemString = constant.pluralItem
        }
        if (numberOfItemTypes == 1) {
            productString = constant.singleProduct
        }else{
            productString = constant.pluralProduct
        }
        
        let result = "\(numberOfItemTypes) \(productString), \(numberOfItems) \(itemString)."
        
        return result
    }
    
    func dateString() -> String{
        return DataAdapters.dateFormatter().stringFromDate(self.date!)
    }
    
    func removeSalesEntry(salesEntry: SalesEntry){
        let idx = indexOfProduct(salesEntry.product!)
        if idx != NSNotFound {
            SalesDataSource.openWrite()
            items.removeAtIndex(idx)
            salesEntriesChanged()
            SalesDataSource.closeWrite()
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
        
        SalesDataSource.openWrite()
        oldEntry.quantity! += salesEntry.quantity!
        salesEntriesChanged()
        SalesDataSource.closeWrite()
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
        
        SalesDataSource.openWrite()
        items.replace(idx!, object: newSalesEntry);
        salesEntriesChanged()
        SalesDataSource.closeWrite()
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
    
    func numberOfItemsString() -> String{
        let numItems = self.numberOfItems()
        if (numItems == 1) {
            return "\(numItems) item"
        }
        return "\(numItems) items"
    }
    
    func calculateTotal(){
        var total = NSDecimalNumber.init(long: 0)
        for entry in items{
            print("Decimal", entry.decimalCost())
            total = total.decimalNumberByAdding(entry.decimalCost())
        }
//        totalCost = ""
//        totalCost = total.stringValue
        totalCost = DataAdapters.numberFormatter().stringFromNumber(total)
    }
    
    func totalCostString() -> String{
        return totalCost!
    }

}
