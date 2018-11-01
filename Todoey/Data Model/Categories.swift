//
//  Category.swift
//  Todoey
//
//  Created by Spark Da Capo on 10/31/18.
//  Copyright © 2018 OneSpark. All rights reserved.
//

import Foundation
import RealmSwift

class Categories: Object {
    // Realm related data model
    @objc dynamic var name: String = ""
    let items = List<Items>()
    
}
