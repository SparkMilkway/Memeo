//
//  Item.swift
//  Todoey
//
//  Created by Spark Da Capo on 10/31/18.
//  Copyright © 2018 OneSpark. All rights reserved.
//

import Foundation
import RealmSwift

class Items: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date?
    // Create a linking relationship between Categories and Items
    var parentCategory = LinkingObjects(fromType: Categories.self, property: "items")
    
}
