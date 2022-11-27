//
//  LiveStreamingsModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 27/11/2022.
//

import Foundation

struct LiveStreams: Codable,Identifiable{
    var id = UUID().uuidString
    let num: Int
    let name: String
    let streamType: StreamType
    let streamID: Int
    let streamIcon: String
    let epgChannelID: String?
    let added, categoryID, customSid: String
    let tvArchive: Int
    let directSource: String
    let tvArchiveDuration: Int

    enum CodingKeys: String, CodingKey {
        case num, name
        case streamType = "stream_type"
        case streamID = "stream_id"
        case streamIcon = "stream_icon"
        case epgChannelID = "epg_channel_id"
        case added
        case categoryID = "category_id"
        case customSid = "custom_sid"
        case tvArchive = "tv_archive"
        case directSource = "direct_source"
        case tvArchiveDuration = "tv_archive_duration"
    }
}

enum StreamType: String, Codable {
    case live = "live"
}

