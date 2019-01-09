//
//  TodoItem.swift
//  Wave
//
//  Created by Capella Yee on 1/6/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var isComplete : Bool = false
    @objc dynamic var dateCreated : Date = Date.init()
    let parentCategory = LinkingObjects(fromType: Category.self, property: "todoItems")
}
