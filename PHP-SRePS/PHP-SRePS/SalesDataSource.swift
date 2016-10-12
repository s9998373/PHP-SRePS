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
    
    
    /// Allows translation from a Results to an NSArray.
    ///
    /// - returns: The Results in NSArray format.
    func toNSArray() -> NSArray {
        return self.map{$0}
    }
}

extension RealmSwift.List {
    
    /// Allows translation from a Realm list to an NSArray.
    ///
    /// - returns: The Realm list in NSArray format.
    func toNSArray() -> NSArray {
        return self.map{$0}
    }
}

extension NSDate {
    
    /// Determines if a date lies between two dates (inclusive).
    ///
    /// - parameter beginDate: The start date.
    /// - parameter endDate:   The end date.
    ///
    /// - returns: True if the date lies between each of the provided dates, inclusively, otherwise, false
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
    }
    
    
    /// Adds a Product to the database.
    ///
    /// - parameter item: The product to be added.
    ///
    /// - returns: True if the operation was successful, otherwise, false.
    func addSalesProduct(item: Product) -> Bool{
        return abstractAdd(item);
    }
    
    /// Removes a product from the database.
    ///
    /// - parameter item: The product to be removed.
    ///
    /// - returns: True if the operation was successful, otherwise, false.
    func removeSalesProduct(item: Product) -> Bool{
        return abstractDelete(item);
    }
    
    
    /// Returns all products contained within the database.
    ///
    /// - returns: An array of all of the products.
    func allProducts() -> NSArray{
        return realm.objects(Product).toNSArray();
    }
    
    
    /// Adds a transation to the database.
    ///
    /// - parameter item: The transaction to be added.
    ///
    /// - returns: True if the operation was successful, otherwise, false.
    func addTransaction(item: Transaction) -> Bool{
        return addTransaction(item, write: true)
    }
    
    
    /// Adds a transation to the database.
    ///
    /// - parameter item: The transaction to be added.
    ///
    /// - returns: True if the operation was successful, otherwise, false.
    func addTransaction(item: Transaction, write: Bool) -> Bool{
        return abstractAdd(item, write: write);
    }
    
    /// Returns all transactions contained within the database.
    ///
    /// - returns: An array of all of the transactions.
    func allTransactions() -> NSArray{
        let result = realm.objects(Transaction).toNSArray();
        return result;
    }
    
    /// Returns all sales entries contained within the database.
    ///
    /// - returns: An array of all of the sales entries.
    func allSalesEntries() -> NSArray{
        let result = realm.objects(SalesEntry).toNSArray();
        return result;
    }
    
    /// Returns all transactions contained within the database during a given month and year.
    ///
    /// - parameter month: The month where transactions were made.
    /// - parameter year:  The year where transactions were made.
    ///
    /// - returns: An array of all of the transactions that fulfill the date constraints imposed.
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
    
    /// Returns all transactions contained within the database during a given week and year.
    ///
    /// - parameter week: The week where transactions were made.
    /// - parameter year: The year where transactions were made.
    ///
    /// - returns: An array of all of the transactions that fulfill the date constraints imposed.
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
    
    /// Returns all transactions contained within the database between two given months.
    ///
    /// - parameter start: The start month.
    /// - parameter end:   The end month.
    ///
    /// - returns: An array of all of the transactions that fulfill the date constraints imposed.
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
    
    /// Removes a product from the database.
    ///
    /// - parameter item: The product to be removed.
    ///
    /// - returns: True if the operation was successful, otherwise, false.
    func removeTransaction(item: Transaction) -> Bool{
        return abstractDelete(item);
    }
    
    
    /// Abstract method to add an item to the database.
    ///
    /// - parameter item: The item to be added.
    ///
    /// - returns: True if the operation was successful, otherwise, false.
    private func abstractAdd(item: Object) -> Bool{
        return abstractAdd(item, write: true)
    }
    
    
    /// Abstract method to add an item to the database.
    ///
    /// - parameter item: The item to be added.
    ///
    /// - returns: True if the operation was successful, otherwise, false.
    private func abstractAdd(item: Object, write: Bool) -> Bool{
        if write {
            SalesDataSource.openWrite();
        }
        self.realm.add(item);
        if write {
            return SalesDataSource.closeWrite();
        }else{
            return true
        }
    }
    
    
    /// Abstract method to delete an object from the database.
    ///
    /// - parameter item: The item to be deleted from the database.
    ///
    /// - returns: True if the operation was successful, otherwise, false.
    private func abstractDelete(item: Object) -> Bool{
        SalesDataSource.openWrite();
        self.realm.delete(item);
        return SalesDataSource.closeWrite();
    }

    
    /// Opens a write transaction.
    class func openWrite(){
        sharedManager.realm.beginWrite();
    }
    
    
    /// Generic method to end a write transaction.
    ///
    /// - returns: true if the operation was successful, otherwise false.
    class func closeWrite() -> Bool{
        do{
            try sharedManager.realm.commitWrite();
        }
        catch{
            return false;
        }
        return true;
    }
    
    /// Loads the database.
    func instateDatabase(){
        self.realm = try! Realm();
    }
    
    func resetDatabase(){
        SalesDataSource.openWrite()
        realm.deleteAll()
        SalesDataSource.closeWrite()
    }
    
    /*
    /// Exports the database to CSV and returns the path where the zipped backup was saved.
    ///
    /// - returns: The path of the backup.
    func exportToCSV() -> String?{
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString

        let realmBaseFilePath = SalesDataSource.sharedManager.realm.configuration.fileURL!.path! as NSString
        
        // The default Realm database is likely open at the current time, this means we should copy it and backup the copy.
        // This is much more reliable than dereferencing the database handles, which may be untracked.
        let databaseStagingPath = documentsPath.stringByAppendingPathComponent(".REALM") as NSString
        let realmFilePath = databaseStagingPath.stringByAppendingPathComponent(realmBaseFilePath.lastPathComponent)
        let outputFolderPath = documentsPath.stringByAppendingPathComponent(".CSV_OUT")
        let metaDataPath = (outputFolderPath as NSString).stringByAppendingPathComponent("metadata.plist")
        let zipOutputFolderPath = documentsPath.stringByAppendingPathComponent("Backups") as NSString
        let dateTimeString = DataAdapters.dateTimeFormatter().stringFromDate(NSDate())
        let zipSavePath = zipOutputFolderPath.stringByAppendingPathComponent("backup-export-\(dateTimeString).phpbk")
        
        print(zipSavePath)
        
        var needsToCreateStagingDirectory = false
        var needsToCreateBackupDirectory = false
        var needsToCreateDatabaseStagingDirectory = false
        
        var isDirectory:ObjCBool = false
        var residualFileExists:ObjCBool = false
        
        let fileManager = NSFileManager.defaultManager()
        
        // Determine if we need to create the staging directory in .CSV_OUT
        if (!fileManager.fileExistsAtPath(outputFolderPath, isDirectory: &isDirectory) || !isDirectory) {
            needsToCreateStagingDirectory = true
        }
        
        if (!fileManager.fileExistsAtPath(zipOutputFolderPath as String, isDirectory: &isDirectory) || !isDirectory) {
            needsToCreateBackupDirectory = true
        }
        
        if (!fileManager.fileExistsAtPath(databaseStagingPath as String, isDirectory: &isDirectory) || !isDirectory) {
            needsToCreateDatabaseStagingDirectory = true
        }
        
        if fileManager.fileExistsAtPath(realmFilePath){
            residualFileExists = true
        }
        
        // Create the output directory, also create a copy of the Realm database.
        do {
            // Cleanup old file, if residual staging file remains from previous ocassion.
            if residualFileExists {
                print("[*] Removing risidual file...")
                try fileManager.removeItemAtPath(realmFilePath)
            }
            
            if needsToCreateStagingDirectory {
                print("[*] Creating staging directory...")
                try fileManager.createDirectoryAtPath(outputFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            if needsToCreateDatabaseStagingDirectory {
                print("[*] Creating database staging directory...")
                try fileManager.createDirectoryAtPath(databaseStagingPath as String, withIntermediateDirectories: true, attributes: nil)
            }
            
            if needsToCreateBackupDirectory {
                print("[*] Creating backup directory...")
                try fileManager.createDirectoryAtPath(zipOutputFolderPath as String, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Copy the file
            print("[1] Cloning database for translation to CSV...")
            try! fileManager.copyItemAtPath(realmBaseFilePath as String, toPath: realmFilePath)
        }catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
        
        
        print("[2] Opening database for translation to CSV...")
        let csvDataExporter = CSVDataExporter(realmFilePath: realmFilePath)
        print("[3] Generating CSV files...")
        try! csvDataExporter.exportToFolderAtPath(outputFolderPath)
        print("[4] Backup to CSV complete!")
        
        print("[5] Creating metadata file...")
        
        
        let versionNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let metaDataDict:NSDictionary = ["data" : NSDate(),
                                         "version" : versionNumber]
        metaDataDict.writeToFile(metaDataPath, atomically: true)
        
        SSZipArchive.createZipFileAtPath(zipSavePath, withContentsOfDirectory: outputFolderPath, keepParentDirectory: false)
        
        // Cleanup
        do {
            try fileManager.removeItemAtPath(databaseStagingPath as String)
            try fileManager.removeItemAtPath(outputFolderPath)
        }catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
        
        return zipSavePath
    }
     */
    
    /*
    func importFromPath(path: String){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        let realmBaseFilePath = SalesDataSource.sharedManager.realm.configuration.fileURL!.path! as NSString
        let databaseStagingPath = documentsPath.stringByAppendingPathComponent(".CSV_IN") as NSString
        let databaseRestoreDirectory = documentsPath.stringByAppendingPathComponent("RESTORE") as NSString
        let databaseRestorePath = databaseRestoreDirectory.stringByAppendingPathComponent("default.realm")
        let fileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(databaseRestorePath as String) {
            try? fileManager.createDirectoryAtPath(databaseRestoreDirectory as String, withIntermediateDirectories: true, attributes: nil)
        }
        
//        SSZipArchive.unzipFileAtPath(path, toDestination: databaseStagingPath as String)
        
        var csvFiles = [String]()
        var metaDataFilePath:String? = nil
        
        do{
            let files = try fileManager.contentsOfDirectoryAtPath(databaseStagingPath as String)
            
            for file:String in files{
                let lowered = file.lowercaseString
                
                if lowered.hasSuffix(".csv") {
                    csvFiles.append(databaseStagingPath.stringByAppendingPathComponent(file) as String)
                }else if(lowered.hasSuffix(".plist")) {
                    metaDataFilePath = databaseStagingPath.stringByAppendingPathComponent(file)
                }
            }
        }catch let error as NSError{
            print(error.localizedDescription)
            return
        }
        
        if csvFiles.count < 1 {
            return
        }
        
        let metaDataDictionary = NSDictionary.init(contentsOfFile: metaDataFilePath!)
        print(metaDataDictionary)
        
//        let config = Realm.Configuration(
//            // Get the URL to the bundled file
//            fileURL: NSURL.fileURLWithPath(databaseRestorePath),
//            // Open the file in read-only mode as application bundles are not writeable
//            readOnly: true)
//        let realm = try! Realm(configuration: config)
        
        // Analyze the files and produce a Realm-compatible schema
        let generator =  ImportSchemaGenerator(files: csvFiles)
        let schema = try! generator.generate()
        
        // Use the schema and files to create the Realm file, and import the data
        let dataImporter = CSVDataImporter(files: csvFiles)
        try! dataImporter.importToPath(databaseRestorePath as String, schema: schema)
    }
     */
    
    /// Saves data into the Exports directory contained within the Documents directory.
    /// If this directory does not exist it is created.
    ///
    /// - parameter filename: The name of the file that is to be saved.
    /// - parameter data:     The data to be saved (NSData).
    ///
    /// - returns: <#return value description#>
    static func saveDataInExportDirectory(filename: String, data: NSData) -> String{
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let zipOutputFolderPath = documentsPath.stringByAppendingPathComponent("Exports") as NSString
        
        let savefilePath = zipOutputFolderPath.stringByAppendingPathComponent(filename)
        
        var needsToCreateBackupDirectory = false
        
        var isDirectory:ObjCBool = false
        
        let fileManager = NSFileManager.defaultManager()
        
        // Determine if we need to create the backup directory.
        if (!fileManager.fileExistsAtPath(zipOutputFolderPath as String, isDirectory: &isDirectory) || !isDirectory) {
            needsToCreateBackupDirectory = true
        }
        
        // Create the output directory, also create a copy of the Realm database.
        do {
            if needsToCreateBackupDirectory {
                print("[*] Creating export directory...")
                try fileManager.createDirectoryAtPath(zipOutputFolderPath as String, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Write the file
            try data.writeToFile(savefilePath, options: NSDataWritingOptions.AtomicWrite)
        }catch let error as NSError{
            print(error.localizedDescription)
            return ""
        }
        
        
        return savefilePath
    }
    
    /// Creates a CSV from the passed transactions.
    ///
    /// - parameter transactions: An NSArray of Transactions.
    ///
    /// - returns: A string representing the location that the CSV file has been saved to.
    func createCSVUsingTransactions(transactions : NSArray) -> String{
        let sortDescriptor = NSSortDescriptor.init(key: "date", ascending: true)
        let sortedArray = transactions.sortedArrayUsingDescriptors([sortDescriptor]) as! [Transaction]
        var csvString = "date,item_count,total_cost\n"
        
        for transaction in sortedArray{
            let dateString = DataAdapters.dateTimeFormatterStandard().stringFromDate(transaction.date!)
            let itemCount = transaction.numberOfItems()
            let totalCost = (transaction.totalCost!).stringByReplacingOccurrencesOfString(",", withString: "")
            csvString = csvString.stringByAppendingString("\(dateString),\(itemCount),\(totalCost)")
            if (sortedArray.last != transaction) {
                csvString = csvString.stringByAppendingString("\n")
            }
        }
        
        let dateTimeString = DataAdapters.dateTimeFormatter().stringFromDate(NSDate())
        let saveFilename = "backup-export-\(dateTimeString).csv"
        let saveData = csvString.dataUsingEncoding(NSUTF8StringEncoding)
        
        return SalesDataSource.saveDataInExportDirectory(saveFilename, data: saveData!)
    }
    
    /// Fills the database with randomised sample data.
    func prefillDatabase(numberOfTransactions : Int){
//        let NUM_TRANSACTIONS = 2
        
        SalesDataSource.sharedManager.resetDatabase()
        
        var products = [Product?](count: 10, repeatedValue: nil)
        
        products[0] = Product.init(aName: "Lipitor", aPrice: "9.45");
        products[1] = Product.init(aName: "Nexium", aPrice: "18.42");
        products[2] = Product.init(aName: "Plavix", aPrice: "29.08");
        products[3] = Product.init(aName: "Abilify", aPrice: "25.3");
        products[4] = Product.init(aName: "Advair Diskus", aPrice: "16.95");
        products[5] = Product.init(aName: "Seroquel", aPrice: "29.26");
        products[6] = Product.init(aName: "Singulair", aPrice: "22.49");
        products[7] = Product.init(aName: "Crestor", aPrice: "20.06");
        products[8] = Product.init(aName: "Actos", aPrice: "29.29");
        products[9] = Product.init(aName: "Epogen", aPrice: "7.39");
        
        for product in products {
            SalesDataSource.sharedManager.addSalesProduct(product!)
        }
        
        SalesDataSource.openWrite()
        for i in 0..<numberOfTransactions {
            let salesEntryCount = arc4random_uniform(5) + 1
            var availableProducts = Array(0...9)
            var selectedProductIndexes = [Int]()
//            print("\(i) pass...")
            let transaction = Transaction.init(date: NSDate())
            for _ in 0..<salesEntryCount{
                let index = Int(arc4random_uniform(UInt32(availableProducts.count)))
                selectedProductIndexes.append(availableProducts[index])
                let product = products[availableProducts[index]]
                let quantity = Int(arc4random_uniform(8)) + 1
                let salesEntry = SalesEntry.init(product: product!, quanity: quantity)
                transaction.addSalesEntry(salesEntry, write: false)
                
//                print(products[availableProducts[index]]!.name)
                availableProducts.removeAtIndex(index)
            }
            SalesDataSource.sharedManager.addTransaction(transaction, write: false)
            
            if (i % 100 == 0) {
                print(i)
            }
        }
        SalesDataSource.closeWrite()
    }
}
