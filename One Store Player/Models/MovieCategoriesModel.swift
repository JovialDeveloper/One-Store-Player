//
//  MovieCategoriesModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 29/11/2022.
//

import Foundation
struct MovieCategoriesModel: Codable{
    let categoryID, categoryName: String
    let parentID: Int

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case categoryName = "category_name"
        case parentID = "parent_id"
    }
}
extension MovieCategoriesModel:Equatable{
    
}
