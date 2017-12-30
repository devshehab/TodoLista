//
//  Item.swift
//  TodoLista
//
//  Created by Mac on 12/30/17.
//  Copyright © 2017 shehaboli. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc var dateCreated: Date?

    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
