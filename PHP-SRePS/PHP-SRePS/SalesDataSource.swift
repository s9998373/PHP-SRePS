//
//  SalesDataSource.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    
    func toNSArray() -> NSArray {
        return self.map{$0}
    }
}

extension RealmSwift.List {
    
    func toNSArray() -> NSArray {
        return self.map{$0}
    }
}

extension NSDate {
    func dateLiesBetweenDates(beginDate: NSDate, endDate: NSDate) -> Bool {
        if self.compare(beginDate) == .OrderedAscending {
            return false
        }
        
        if self.compare(endDate) == .OrderedDescending {
            return false
        }
        
        return true
    }
}

class SalesDataSource: NSObject {
    static let sharedManager = SalesDataSource();
    
    var realm: Realm!;
    
    override init() {
        super.init();
        self.realm = try! Realm();
        print(self.realm);
    }
    
    func addSalesProduct(item: Product) -> Bool{
        return abstractAdd(item);
    }
    
    func removeSalesProduct(item: Product) -> Bool{
        return abstractDelete(item);
    }
    
    func allProducts() -> NSArray{
        return realm.objects(Product).toNSArray();
    }
    
    func addTransaction(item: Transaction) -> Bool{
        return abstractAdd(item);
    }
    
    func allTransactions() -> NSArray{
        let result = realm.objects(Transaction).toNSArray();
        print(result)
        return result;
    }
    
    func transactionsInMonth(month:Int, year:Int) -> NSArray{
        let transactions = allTransactions()
        let calendar = DataAdapters.calendar()
        let results = NSMutableArray()
        
        for transaction in transactions {
            let components = calendar.components([.Month, .Year], fromDate: transaction.date!!)
            if (components.year == year && components.month == month) {
                results.addObject(transaction as! Transaction)
            }
        }
        
        return results as NSArray
    }
    
    func transactionsInWeek(week:Int, year:Int) -> NSArray{
        let transactions = allTransactions()
        let calendar = DataAdapters.calendar()
        let results = NSMutableArray()
        
        for transaction in transactions {
            let components = calendar.components([.WeekOfYear, .Year], fromDate: transaction.date!!)
            if (components.year == year && components.weekOfYear == week) {
                results.addObject(transaction as! Transaction)
            }
        }
        
        return results as NSArray
    }
    
    func transactionsBetweenDates(start:NSDate, end:NSDate) -> NSArray{
        let transactions = allTransactions()
        let results = NSMutableArray()
        
        for transaction in transactions {
            if (transaction.date!!.dateLiesBetweenDates(start, endDate: end)) {
                results.addObject(transaction as! Transaction)
            }
        }
        
        return results as NSArray
    }
    
    func removeTransaction(item: Transaction) -> Bool{
        return abstractDelete(item);
    }
    
    private func abstractAdd(item: Object) -> Bool{
        SalesDataSource.openWrite();
        self.realm.add(item);
        return SalesDataSource.closeWrite();
    }
    
    private func abstractDelete(item: Object) -> Bool{
        SalesDataSource.openWrite();
        self.realm.delete(item);
        return SalesDataSource.closeWrite();
    }

    class func openWrite(){
        sharedManager.realm.beginWrite();
    }
    
    class func closeWrite() -> Bool{
        do{
            try sharedManager.realm.commitWrite();
        }
        catch{
            return false;
        }
        return true;
    }
}
