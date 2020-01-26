//
//  StorageManager.swift
//  Counter
//
//  Created by Артем  Емельянов  on 02/11/2019.
//  Copyright © 2019 Artem Emelianov. All rights reserved.
//

import RealmSwift


let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ object: Object) {
        
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func deleteObject (_ object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
}
