//
//  ListModel.swift
//  Counter
//
//  Created by Артем  Емельянов  on 04/11/2019.
//  Copyright © 2019 Artem Emelianov. All rights reserved.
//

import RealmSwift

class CounterStorage: Object {
    
    var counters = List<Counter>()
    @objc dynamic var name = "Name"
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
