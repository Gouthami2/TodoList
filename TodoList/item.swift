//
//  File.swift
//  TodoList
//
//  Created by Gouthami Reddy on 6/18/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import Foundation
class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
