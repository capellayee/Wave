//
//  Category.swift
//  Wave
//
//  Created by Capella Yee on 1/6/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var backgroundColor : String = ""
    let todoItems = List<TodoItem>()
}
