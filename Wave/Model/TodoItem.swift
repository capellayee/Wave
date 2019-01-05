//
//  TodoItem.swift
//  Wave
//
//  Created by Capella Yee on 1/5/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import Foundation

class TodoItem {
    var title : String = ""
    var isComplete : Bool = false
    
    init(titleText: String) {
        title = titleText
    }
}
