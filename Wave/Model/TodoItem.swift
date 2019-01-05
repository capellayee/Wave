//
//  TodoItem.swift
//  Wave
//
//  Created by Capella Yee on 1/5/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import Foundation

// for something to be Encodable, must have standard data types. That's because it basically encodes each Class object into a Dictionary with each property with name as key and value as value.
class TodoItem : Encodable, Decodable {
    var title : String = ""
    var isComplete : Bool = false
    
    init(titleText: String) {
        title = titleText
    }
}
