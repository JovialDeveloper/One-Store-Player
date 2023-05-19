//
//  MovieRealmModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 18/05/2023.
//

import Foundation
import RealmSwift
class CategoriesRealmModel: Object{
    @Persisted var categoryID:String
    @Persisted(primaryKey: true) var categoryName: String
    @Persisted var parentID: Int
    @Persisted var totalCount:Int
    

    override class func primaryKey() -> String? {
        "categoryName"
    }
//    enum CodingKeys: String, CodingKey {
//        case categoryID = "category_id"
//        case categoryName = "category_name"
//        case parentID = "parent_id"
//    }
}
