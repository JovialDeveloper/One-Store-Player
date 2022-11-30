//
//  MovieModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 29/11/2022.
//

import Foundation
struct MovieModel: Codable {
    let num: Int
    let name, streamType: String?
    let streamID: Int
    let streamIcon: String?
    //let rating: String?
    let rating5Based: Double?
    let added, categoryID, containerExtension, customSid: String?
    let directSource: String?

    enum CodingKeys: String, CodingKey {
        case num, name
        case streamType = "stream_type"
        case streamID = "stream_id"
        case streamIcon = "stream_icon"
        //case rating
        case rating5Based = "rating_5based"
        case added
        case categoryID = "category_id"
        case containerExtension = "container_extension"
        case customSid = "custom_sid"
        case directSource = "direct_source"
    }
}
