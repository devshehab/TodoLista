//
//  Category.swift
//  TodoLista
//
//  Created by Mac on 12/30/17.
//  Copyright © 2017 shehaboli. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}
