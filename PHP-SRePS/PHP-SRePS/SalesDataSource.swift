//
//  SalesDataSource.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import Foundation
import RealmSwift
import RealmConverter

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
        self.instateDatabase()
//        print(self.realm);
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
//        print(result)
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
    
    func instateDatabase(){
        self.realm = try! Realm();
    }
    
    func exportToCSV(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString

        let realmBaseFilePath = SalesDataSource.sharedManager.realm.configuration.fileURL!.path! as NSString
        
        // The default Realm database is likely open at the current time, this means we should copy it and backup the copy.
        // This is much more reliable than dereferencing the database handles, which may be untracked.
        let realmFilePath = realmBaseFilePath.stringByAppendingPathExtension("_tmp")
        let outputFolderPath = documentsPath.stringByAppendingPathComponent(".CSV_OUT")
        
        var needsToCreateDirectory = false
        var isDirectory:ObjCBool = false
        var residualFileExists:ObjCBool = false
        
        let fileManager = NSFileManager.defaultManager()
        
        // Determine if we need to create the staging directory in .CSV_OUT
        if (!fileManager.fileExistsAtPath(outputFolderPath, isDirectory: &isDirectory) || !isDirectory) {
            needsToCreateDirectory = true
        }
        
        if fileManager.fileExistsAtPath(realmFilePath!){
            residualFileExists = true
        }
        
        // Create the output directory, also create a copy of the Realm database.
        do {
            // Cleanup old file, if residual staging file remains from previous ocassion.
            if residualFileExists {
                print("[*] Removing risidual file...")
                try fileManager.removeItemAtPath(realmFilePath!)
            }
            
            if needsToCreateDirectory {
                print("[*] Creating staging directory...")
                try fileManager.createDirectoryAtPath(outputFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Copy the file
            print("[1] Cloning database for translation to CSV...")
            try! fileManager.copyItemAtPath(realmBaseFilePath as String, toPath: realmFilePath!)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
        
        print("[2] Opening database for translation to CSV...")
        let csvDataExporter = CSVDataExporter(realmFilePath: realmFilePath!)
        print("[3] Generating CSV files...")
        try! csvDataExporter.exportToFolderAtPath(outputFolderPath)
        print("[4] Backup to CSV complete!")
        
        // Cleanup
        do {
            try fileManager.removeItemAtPath(realmFilePath!)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}
