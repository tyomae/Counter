//
//  CounterState.swift
//  Counter
//
//  Created by Артем  Емельянов  on 22.10.2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

enum CounterState {
	case increase(value: Int)
	case decrease(value: Int)
}
