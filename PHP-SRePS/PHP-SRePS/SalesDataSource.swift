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
        return realm.objects(Transaction).toNSArray();
    }
    
    func removeTransaction(item: Transaction) -> Bool{
        return abstractDelete(item);
    }
    
    private func abstractAdd(item: Object) -> Bool{
        realm.beginWrite();
        realm.add(item);
        do{
            try realm.commitWrite();
        }
        catch{
            return false;
        }
        return true;
    }
    
    private func abstractDelete(item: Object) -> Bool{
        realm.beginWrite();
        realm.delete(item);
        do{
            try realm.commitWrite();
        }
        catch{
            return false;
        }
        
        return true;
    }
}
