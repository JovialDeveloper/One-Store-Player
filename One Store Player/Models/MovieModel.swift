//
//  MovieModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 29/11/2022.
//

import Foundation
struct MovieModel: Codable,Identifiable{
    var id = UUID().uuidString
    let num: Int
    let name, streamType: String?
    let streamID: Int
    let streamIcon: String?
    //let rating: String?
    let rating5Based: Double?
    let added, categoryID, customSid: String?
    let containerExtension:ContainerExtension?
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
extension MovieModel:Equatable{}

// MARK: - MovieModelWatchResponse
struct MovieModelWatchResponse: Codable {
    let info: Info
    let movieData: MovieData

    enum CodingKeys: String, CodingKey {
        case info
        case movieData = "movie_data"
    }
}

// MARK: - Info
struct Info: Codable {
    let kinopoiskURL, name, oName: String?
    let coverBig, movieImage: String?
    let releasedate, youtubeTrailer, director: String?
    let actors, cast, infoDescription, plot: String?
    let age, mpaaRating: String?
    let ratingCountKinopoisk: Int?
    let country, genre: String?
    let backdropPath: [String]?
    let durationSecs: Int?
    let duration: String?
    //let video: Video?
    //let audio: Audio?
    let bitrate: Int?
    let rating: RatingsEnum?

    enum CodingKeys: String, CodingKey {
        case kinopoiskURL = "kinopoisk_url"
        //case tmdbID = "tmdb_id"
        case name
        case oName = "o_name"
        case coverBig = "cover_big"
        case movieImage = "movie_image"
        case releasedate
        //case episodeRunTime = "episode_run_time"
        case youtubeTrailer = "youtube_trailer"
        case director, actors, cast
        case infoDescription = "description"
        case plot, age
        case mpaaRating = "mpaa_rating"
        case ratingCountKinopoisk = "rating_count_kinopoisk"
        case country, genre
        case backdropPath = "backdrop_path"
        case durationSecs = "duration_secs"
        case duration, bitrate, rating
        
        //video, audio
    }
}

// MARK: - Audio
struct Audio: Codable {
    let index: Int
    let codecName, codecLongName, profile, codecType: String
    let codecTimeBase, codecTagString, codecTag, sampleFmt: String
    let sampleRate: String
    let channels: Int
    let channelLayout: String
    let bitsPerSample: Int
    let rFrameRate, avgFrameRate, timeBase: String
    let startPts: Int
    let startTime: String
    let durationTs: Int
    let duration, bitRate, maxBitRate, nbFrames: String
    let disposition: [String: Int]
    let tags: Tags

    enum CodingKeys: String, CodingKey {
        case index
        case codecName = "codec_name"
        case codecLongName = "codec_long_name"
        case profile
        case codecType = "codec_type"
        case codecTimeBase = "codec_time_base"
        case codecTagString = "codec_tag_string"
        case codecTag = "codec_tag"
        case sampleFmt = "sample_fmt"
        case sampleRate = "sample_rate"
        case channels
        case channelLayout = "channel_layout"
        case bitsPerSample = "bits_per_sample"
        case rFrameRate = "r_frame_rate"
        case avgFrameRate = "avg_frame_rate"
        case timeBase = "time_base"
        case startPts = "start_pts"
        case startTime = "start_time"
        case durationTs = "duration_ts"
        case duration
        case bitRate = "bit_rate"
        case maxBitRate = "max_bit_rate"
        case nbFrames = "nb_frames"
        case disposition, tags
    }
}

//MARK:- Rating Enum

enum RatingsEnum: Codable {
    case integer(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(RatingsEnum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Value"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Tags
struct Tags: Codable {
    let language, handlerName: String

    enum CodingKeys: String, CodingKey {
        case language
        case handlerName = "handler_name"
    }
}

// MARK: - Video
struct Video: Codable {
    let index: Int
    let codecName, codecLongName, profile, codecType: String
    let codecTimeBase, codecTagString, codecTag: String
    let width, height, codedWidth, codedHeight: Int
    let hasBFrames: Int
    let pixFmt: String
    let level: Int
    let chromaLocation: String
    let refs: Int
    let isAVC, nalLengthSize, rFrameRate, avgFrameRate: String
    let timeBase: String
    let startPts: Int
    let startTime: String
    let durationTs: Int
    let duration, bitRate, bitsPerRawSample, nbFrames: String
    let disposition: [String: Int]
    let tags: Tags

    enum CodingKeys: String, CodingKey {
        case index
        case codecName = "codec_name"
        case codecLongName = "codec_long_name"
        case profile
        case codecType = "codec_type"
        case codecTimeBase = "codec_time_base"
        case codecTagString = "codec_tag_string"
        case codecTag = "codec_tag"
        case width, height
        case codedWidth = "coded_width"
        case codedHeight = "coded_height"
        case hasBFrames = "has_b_frames"
        case pixFmt = "pix_fmt"
        case level
        case chromaLocation = "chroma_location"
        case refs
        case isAVC = "is_avc"
        case nalLengthSize = "nal_length_size"
        case rFrameRate = "r_frame_rate"
        case avgFrameRate = "avg_frame_rate"
        case timeBase = "time_base"
        case startPts = "start_pts"
        case startTime = "start_time"
        case durationTs = "duration_ts"
        case duration
        case bitRate = "bit_rate"
        case bitsPerRawSample = "bits_per_raw_sample"
        case nbFrames = "nb_frames"
        case disposition, tags
    }
}

// MARK: - MovieData
struct MovieData: Codable {
    let streamID: Int
    let name, added, categoryID, containerExtension: String
    let customSid, directSource: String

    enum CodingKeys: String, CodingKey {
        case streamID = "stream_id"
        case name, added
        case categoryID = "category_id"
        case containerExtension = "container_extension"
        case customSid = "custom_sid"
        case directSource = "direct_source"
    }
}



