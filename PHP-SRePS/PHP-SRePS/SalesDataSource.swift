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
        var result = realm.objects(Transaction).toNSArray();
        print(result)
        return result;
    }
    
    func removeTransaction(item: Transaction) -> Bool{
        return abstractDelete(item);
    }
    
    private func abstractAdd(item: Object) -> Bool{
//        var ret: Bool!
//        SalesDataSource.safeWriteBlock { (result) in
//            self.realm.add(item);
//            ret = result
//            print("ADDED")
//        }
        SalesDataSource.openWrite();
        self.realm.add(item);
        return SalesDataSource.closeWrite();
    }
    
    private func abstractDelete(item: Object) -> Bool{
//        var ret: Bool!
//        SalesDataSource.safeWriteBlock { (result) in
        
        SalesDataSource.openWrite();
        self.realm.delete(item);
//            ret = result
//        }
//    return ret
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
    
//    class func safeWriteBlock(completion: (result: Bool) -> Void){
//        SalesDataSource.openWrite()
//        completion(result: SalesDataSource.closeWrite());
//    }
}
