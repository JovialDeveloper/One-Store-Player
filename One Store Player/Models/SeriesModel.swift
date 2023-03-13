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
    var id = UUID().uuidString
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

extension SeriesModel:Equatable{}



// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct SeriesResponse: Codable {
    let seasons: [Season]?
    let info: WelcomeInfo?
    let episodes: Episodes?
}

// MARK: - Episodes
struct Episodes: Codable {
    let the1: [The1]?

    enum CodingKeys: String, CodingKey {
        case the1 = "1"
    }
}

// MARK: - The1
struct The1: Codable {
    let id: String?
    let episodeNum: Int?
    let title: String?
    let containerExtension: ContainerExtension?
    let info: The1_Info?
    let customSid, added: String?
    let season: Int?
    let directSource: String?

    enum CodingKeys: String, CodingKey {
        case id
        case episodeNum = "episode_num"
        case title
        case containerExtension = "container_extension"
        case info
        case customSid = "custom_sid"
        case added, season
        case directSource = "direct_source"
    }
}

enum ContainerExtension: String, Codable {
    case mp4 = "mp4"
}

// MARK: - The1_Info
struct The1_Info: Codable {
    //let tmdbID: Int?
    let releasedate, plot: String?
    let durationSecs: Int?
    let duration: String?
    let movieImage: String?
    //let video: SVideo?
    //let audio: SAudio?
    let bitrate: Int?
    //let rating: String?
    let season: String?

    enum CodingKeys: String, CodingKey {
        //case tmdbID = "tmdb_id"
        case releasedate, plot
        case durationSecs = "duration_secs"
        case duration
        case movieImage = "movie_image"
        case bitrate, season
        
        //video, audio
        //rating
    }
}

// MARK: - Audio
struct SAudio: Codable {
    let index: Int?
    let codecName: AudioCodecName?
    let codecLongName: AudioCodecLongName?
    let profile: AudioProfile?
    let codecType: AudioCodecType?
    //let codecTimeBase: CodecTimeBaseEnum?
    let codecTagString: AudioCodecTagString?
    let codecTag: AudioCodecTag?
    let sampleFmt: SampleFmt?
    let sampleRate: String?
    let channels: Int?
    let channelLayout: ChannelLayout?
    let bitsPerSample: Int?
    let rFrameRate, avgFrameRate: AudioAvgFrameRate?
    let timeBase: CodecTimeBaseEnum?
    let startPts: Int?
    let startTime: String?
    let durationTs: Int?
    let duration, bitRate, maxBitRate, nbFrames: String?
    let disposition: [String: Int]?
    let tags: AudioTags?

    enum CodingKeys: String, CodingKey {
        case index
        case codecName = "codec_name"
        case codecLongName = "codec_long_name"
        case profile
        case codecType = "codec_type"
        //case codecTimeBase = "codec_time_base"
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

enum AudioAvgFrameRate: String, Codable {
    case the00 = "0/0"
}

enum ChannelLayout: String, Codable {
    case stereo = "stereo"
}

enum AudioCodecLongName: String, Codable {
    case aacAdvancedAudioCoding = "AAC (Advanced Audio Coding)"
}

enum AudioCodecName: String, Codable {
    case aac = "aac"
}

enum AudioCodecTag: String, Codable {
    case the0X6134706D = "0x6134706d"
}

enum AudioCodecTagString: String, Codable {
    case mp4A = "mp4a"
}

enum CodecTimeBaseEnum: String, Codable {
    case the148000 = "1/48000"
}

enum AudioCodecType: String, Codable {
    case audio = "audio"
}

enum AudioProfile: String, Codable {
    case lc = "LC"
}

enum SampleFmt: String, Codable {
    case fltp = "fltp"
}

// MARK: - AudioTags
struct AudioTags: Codable {
    let creationTime: String?
    let language: PurpleLanguage?

    enum CodingKeys: String, CodingKey {
        case creationTime = "creation_time"
        case language
    }
}

enum PurpleLanguage: String, Codable {
    case eng = "eng"
}

// MARK: - Video
struct SVideo: Codable {
    let index: Int?
    let codecName: VideoCodecName?
    let codecLongName: VideoCodecLongName?
    let profile: VideoProfile?
    let codecType: VideoCodecType?
    //let codecTimeBase: CodecTimeBase?
    let codecTagString: VideoCodecTagString?
    let codecTag: VideoCodecTag?
    let width, height, codedWidth, codedHeight: Int?
    let hasBFrames: Int?
    let pixFmt: PixFmt?
    let level: Int?
    let chromaLocation: ChromaLocation?
    let refs: Int?
    let isAVC, nalLengthSize: String?
    let rFrameRate, avgFrameRate: VideoAvgFrameRate?
    let timeBase: VideoTimeBase?
    let startPts: Int?
    let startTime: String?
    let durationTs: Int?
    let duration, bitRate, bitsPerRawSample, nbFrames: String?
    let disposition: [String: Int]?
    let tags: VideoTags?

    enum CodingKeys: String, CodingKey {
        case index
        case codecName = "codec_name"
        case codecLongName = "codec_long_name"
        case profile
        case codecType = "codec_type"
        //case codecTimeBase = "codec_time_base"
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

enum VideoAvgFrameRate: String, Codable {
    case the240001001 = "24000/1001"
}

enum ChromaLocation: String, Codable {
    case chromaLocationLeft = "left"
}

enum VideoCodecLongName: String, Codable {
    case h264AVCMPEG4AVCMPEG4Part10 = "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10"
}

enum VideoCodecName: String, Codable {
    case h264 = "h264"
}

enum VideoCodecTag: String, Codable {
    case the0X31637661 = "0x31637661"
}

enum VideoCodecTagString: String, Codable {
    case avc1 = "avc1"
}

enum CodecTimeBase: String, Codable {
    case the100148000 = "1001/48000"
}

enum VideoCodecType: String, Codable {
    case video = "video"
}

enum PixFmt: String, Codable {
    case yuv420P = "yuv420p"
}

enum VideoProfile: String, Codable {
    case high = "High"
}

// MARK: - VideoTags
struct VideoTags: Codable {
    let creationTime: String?
    let language: FluffyLanguage?
    let handlerName: String?

    enum CodingKeys: String, CodingKey {
        case creationTime = "creation_time"
        case language
        case handlerName = "handler_name"
    }
}

enum FluffyLanguage: String, Codable {
    case und = "und"
}

enum VideoTimeBase: String, Codable {
    case the196000 = "1/96000"
}

// MARK: - WelcomeInfo
struct WelcomeInfo: Codable {
    let name: String?
    let cover: String?
    let plot, cast, director, genre: String?
    let releaseDate, lastModified:String?
    let rating5Based: Double?
    let backdropPath: [String]?
    let youtubeTrailer, episodeRunTime, categoryID: String?
    let rating: RatingsEnum?

    enum CodingKeys: String, CodingKey {
        case name, cover, plot, cast, director, genre, releaseDate
        case lastModified = "last_modified"
        case rating
        case rating5Based = "rating_5based"
        case backdropPath = "backdrop_path"
        case youtubeTrailer = "youtube_trailer"
        case episodeRunTime = "episode_run_time"
        case categoryID = "category_id"
    }
}

// MARK: - Season
struct Season: Codable {
    let airDate: String?
    let episodeCount, id: Int?
    let name, overview: String?
    let seasonNumber: Int?
    let cover, coverBig: String?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case seasonNumber = "season_number"
        case cover
        case coverBig = "cover_big"
    }
}
