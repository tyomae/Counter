//
//  CounterModel.swift
//  Counter
//
//  Created by Артем  Емельянов  on 02/11/2019.
//  Copyright © 2019 Artem Emelianov. All rights reserved.
//

import RealmSwift

class Counter: Object {
    
    @objc dynamic var value = 0
    
    convenience init(value: Int) {
        self.init()
        self.value = value
    }
}
