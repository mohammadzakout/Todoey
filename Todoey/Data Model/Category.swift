//
//  Category.swift
//  Todoey
//
//  Created by hamada on 6/7/20.
//  Copyright © 2020 hamada. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
 @objc dynamic var name : String = ""
 @objc dynamic var cellCollor : String = ""
    let items = List<Item>()
    
    
}
