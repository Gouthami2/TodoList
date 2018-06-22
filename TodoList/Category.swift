//
//  Category.swift
//  TodoList
//
//  Created by Gouthami Reddy on 6/20/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
