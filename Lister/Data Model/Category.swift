//
//  Category.swift
//  Lister
//
//  Created by Joseph Pizzo on 4/17/18.
//  Copyright © 2018 PEEZEE. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //defines the forward relationship
    let items = List<Item>()
    
}
