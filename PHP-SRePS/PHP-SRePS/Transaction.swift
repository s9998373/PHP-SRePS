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
    
    /// Adds a sales entry to the transaction.
    ///
    /// - parameter salesEntry: The SalesEntry to be added.
    func addSalesEntry(salesEntry: SalesEntry){
        SalesDataSource.openWrite()
        self.items.append(salesEntry)
        salesEntriesChanged()
        SalesDataSource.closeWrite()
    }
    
    /// A readable string representation of the transaction.
    ///
    /// - returns: The descriptive string.
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
    
    /// A string that represents the transaction date.
    ///
    /// - returns: The date string.
    func dateString() -> String{
        return DataAdapters.dateFormatter().stringFromDate(self.date!)
    }
    
    /// Removes a SalesEntry from the transation.
    ///
    /// - parameter salesEntry: The SalesEntry to be removed.
    func removeSalesEntry(salesEntry: SalesEntry){
        let idx = indexOfProduct(salesEntry.product!)
        if idx != NSNotFound {
            SalesDataSource.openWrite()
            items.removeAtIndex(idx)
            salesEntriesChanged()
            SalesDataSource.closeWrite()
        }
    }
    
    /// Merges two SalesEntries.
    ///
    /// - parameter salesEntry: The new SalesEntry that will be merged.
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
    
    /// Determines if a given product is already a part of the transaction.
    ///
    /// - parameter product: The product in question.
    ///
    /// - returns: True if the product exists in the transaction, otherwise, false.
    func doesProductExistInTransaction(product: Product) -> Bool{
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
    
    
    /// The index of the product in the transaction's entry list.
    ///
    /// - parameter product: The product in question.
    ///
    /// - returns: The index of the product, if unfound, NSNotFound.
    func indexOfProduct(product : Product) -> Int{
        for entry in items{
            if entry.product == product{
                return items.indexOf(entry)!
            }
        }
        return NSNotFound
    }
    
    /// Returns a SalesEntry at a given index.
    ///
    /// - parameter index: The index to retrieve a sales entry from.
    ///
    /// - returns: The SalesEntry at the provided index.
    func salesEntryAtIndex(index: Int) -> SalesEntry{
        return items[index]
    }
    
    /// Returns the number of items in the transaction.
    ///
    /// - returns: The number of items in the transaction.
    func numberOfItems() -> Int{
        return self.items.count
    }
    
    /// Returns a string representing the number of items in the transaction.
    ///
    /// - returns: The string representing the number of items in the transaction.
    func numberOfItemsString() -> String{
        let numItems = self.numberOfItems()
        if (numItems == 1) {
            return "\(numItems) item"
        }
        return "\(numItems) items"
    }
    
    /// Calculates the total cost of the transaction and saves it to the database.
    func calculateTotal(){
        var total = NSDecimalNumber.init(long: 0)
        for entry in items{
            print("Decimal", entry.decimalCost())
            total = total.decimalNumberByAdding(entry.decimalCost())
        }
        totalCost = DataAdapters.numberFormatter().stringFromNumber(total)
    }
    
    /// Returns the total value of the transaction in the form of a string.
    ///
    /// - returns: The total value of the transaction in the form of a string.
    func totalCostString() -> String{
        return totalCost!
    }

}
