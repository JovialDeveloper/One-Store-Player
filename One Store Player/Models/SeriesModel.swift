//
//  SeriesModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 29/11/2022.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct SeriesModel: Codable {
    let num: Int
    let name: String
    let seriesID: Int
    let cover: String
    let plot, cast: String
//    let director: Director
//    let genre: Genre
    let releaseDate, lastModified, rating: String
    let rating5Based: Double
    let backdropPath: [String]
    let youtubeTrailer, episodeRunTime, categoryID: String

    enum CodingKeys: String, CodingKey {
        case num, name
        case seriesID = "series_id"
        case cover, plot, cast, releaseDate
        case lastModified = "last_modified"
        case rating
        case rating5Based = "rating_5based"
        case backdropPath = "backdrop_path"
        case youtubeTrailer = "youtube_trailer"
        case episodeRunTime = "episode_run_time"
        case categoryID = "category_id"
    }
}

enum Director: String, Codable {
    case ahmedSaleh = "Ahmed Saleh"
    case empty = ""
    case khaledElHalafawy = "Khaled El Halafawy"
    case mohamedYassin = "Mohamed Yassin"
    case عمروعرفة = "عمرو عرفة"
}

enum Genre: String, Codable {
    case empty = ""
    case جريمةدراما = "جريمة, دراما"
    case دراما = "دراما"
    case دراماعائليأوبراصابونية = "دراما, عائلي, أوبرا صابونية"
    case دراماغموض = "دراما, غموض"
    case عائليواقع = "عائلي, واقع"
    case كوميديا = "كوميديا"
    case كوميديادراما = "كوميديا, دراما"
}

