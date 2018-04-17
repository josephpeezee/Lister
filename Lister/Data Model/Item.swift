//
//  Item.swift
//  Lister
//
//  Created by Joseph Pizzo on 4/17/18.
//  Copyright © 2018 PEEZEE. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    //defines the inverse relationship of items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
