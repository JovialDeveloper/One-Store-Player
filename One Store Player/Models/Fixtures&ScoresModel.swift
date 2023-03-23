//
//  Fixtures&ScoresModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 03/12/2022.
//

import Foundation


// MARK: - Welcome
struct Fixtures_ScoresModel: Codable {
    let currentPage: Int?
    let data: [Datum]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - Datum
struct Datum: Codable,Identifiable{
    var id = UUID().uuidString
    let uniqueID, apiID: String?
    let referee: String?
    let timezone:String?
    //Timezone?
    let dateTime: String?
    let timestamp, numGoalsHome, numGoalsAway: String?
    //let createdAt: DatumCreatedAt?
    let updatedAt: String?
    let league: League?
    let status: Status?
    let teams: [Team]?
    let events: [Event]?
    let venue: Venue?
    let penaltyScore, extraTimeScore, fullTimeScore, halfTimeScore: Score?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "unique_id"
        case apiID = "api_id"
        case referee, timezone
        case dateTime = "date_time"
        case timestamp
        case numGoalsHome = "num_goals_home"
        case numGoalsAway = "num_goals_away"
        //case createdAt = "created_at"
        case updatedAt = "updated_at"
        case league, status, teams, events, venue
        case penaltyScore = "penalty_score"
        case extraTimeScore = "extra_time_score"
        case fullTimeScore = "full_time_score"
        case halfTimeScore = "half_time_score"
    }
}

extension Datum:Equatable{
    static func == (lhs: Datum, rhs: Datum) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}


enum DatumCreatedAt: String, Codable {
    case the20220912T230723000000Z = "2022-09-12T23:07:23.000000Z"
    case the20220912T230724000000Z = "2022-09-12T23:07:24.000000Z"
}

// MARK: - Event
struct Event: Codable,Identifiable{
    var id = UUID().uuidString
    let uniqueID, elapsedTime: String?
    let extraTime: String?
    let playerAPIID, playerName: String?
    let type: EventType?
    let fixtureID, teamID: String?
    let team: Team?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "unique_id"
        case elapsedTime = "elapsed_time"
        case extraTime = "extra_time"
        case playerAPIID = "player_api_id"
        case playerName = "player_name"
        case type
        case fixtureID = "fixture_id"
        case teamID = "team_id"
        case team
    }
}

// MARK: - Team
struct Team: Codable,Identifiable{
    var id = UUID().uuidString
    let uniqueID, apiID, name, nameAr: String?
    let logo: String?
    let isWinner: Bool?
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "unique_id"
        case apiID = "api_id"
        case name
        case nameAr = "name_ar"
        case logo
        case isWinner = "is_winner"
        case location
    }
}

enum Location: String, Codable {
    case away = "away"
    case home = "home"
}

enum EventType: String, Codable {
    case missedPenaltyGoal = "Missed_Penalty_Goal"
    case normalGoal = "Normal_Goal"
    case ownGoal = "Own_Goal"
    case penaltyGoal = "Penalty_Goal"
    case redCard = "Red_Card"
    case yellowCard = "Yellow_Card"
}

// MARK: - Score
struct Score: Codable {
    let uniqueID: String?
    let numGoalsHome, numGoalsAway: String?
    let fixtureID: String?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "unique_id"
        case numGoalsHome = "num_goals_home"
        case numGoalsAway = "num_goals_away"
        case fixtureID = "fixture_id"
    }
}

// MARK: - League
struct League: Codable {
    let uniqueID, apiID: String?
    let name:String?
    //LeagueName?
    //let nameAr: LeagueNameAr?
    let type: LeagueType?
    let logo: String?
    let season: String?
    //let round: Round?
    let dateStartAt, dateEndAt, rank, countryID: String?
    //let createdAt: LeagueCreatedAt?
    //let updatedAt: UpdatedAt?
    let country: Country?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "unique_id"
        case apiID = "api_id"
        case name
        //case nameAr = "name_ar"
        case type, logo, season //, //round
        case dateStartAt = "date_start_at"
        case dateEndAt = "date_end_at"
        case rank
        case countryID = "country_id"
        //case createdAt = "created_at"
        //case updatedAt = "updated_at"
        case country
    }
}

// MARK: - Country
struct Country: Codable {
    let uniqueID: String?
    let name:String?
    //CountryName?
    //let nameAr: CountryNameAr?
    let flag: String?
    let code:String?
    
    //Code?
    let rank: String?
    //let createdAt, updatedAt: AtedAt?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "unique_id"
        case name
        //case nameAr = "name_ar"
        case flag, code, rank
        //case createdAt = "created_at"
        //case updatedAt = "updated_at"
    }
}

enum Code: String, Codable {
    case gb = "GB"
    case qa = "QA"
    case sa = "SA"
}

enum AtedAt: String, Codable {
    case the20220615T173816000000Z = "2022-06-15T17:38:16.000000Z"
    case the20220625T144418000000Z = "2022-06-25T14:44:18.000000Z"
    case the20220809T113825000000Z = "2022-08-09T11:38:25.000000Z"
}

enum CountryName: String, Codable {
    case england = "England"
    case qatar = "Qatar"
    case saudiArabia = "Saudi-Arabia"
    case world = "World"
    case arabic = "Arabic"
}

enum CountryNameAr: String, Codable {
    case إنجلترا = "إنجلترا"
    case السعودية = "السعودية"
    case العالم = "العالم"
    case قطر = "قطر"
}

enum LeagueCreatedAt: String, Codable {
    case the20220615T173826000000Z = "2022-06-15T17:38:26.000000Z"
    case the20220625T144433000000Z = "2022-06-25T14:44:33.000000Z"
    case the20220808T231712000000Z = "2022-08-08T23:17:12.000000Z"
    case the20220809T113825000000Z = "2022-08-09T11:38:25.000000Z"
}

enum LeagueName: String, Codable {
    case premierLeague = "Premier League"
    case championship = "Championship"
    case proLeague = "Pro League"
    case qatarStarsLeague = "Qatar Stars League"
    case uefaChampionsLeague = "UEFA Champions League"
    case arabianGulfLeague = "Arabian Gulf League"
    case europe = "UEFA Europa League"
}

enum LeagueNameAr: String, Codable {
    case الدوريالممتاز = "الدوري الممتاز"
    case دوريأبطالأوروبا = "دوري أبطال أوروبا"
    case دوريالبطولةالإنجليزية = "دوري البطولة الإنجليزية"
    case دورينجومقطر = "دوري نجوم قطر"
}

enum Round: String, Codable {
    case groupH6 = "Group H - 6"
    case regularSeason21 = "Regular Season - 21"
    case regularSeason7 = "Regular Season - 7"
    case regularSeason8 = "Regular Season - 8"
    case regularSeason9 = "Regular Season - 9"
}

enum LeagueType: String, Codable {
    case cup = "Cup"
    case league = "League"
}

enum UpdatedAt: String, Codable {
    case the20220911T231724000000Z = "2022-09-11T23:17:24.000000Z"
    case the20221014T200848000000Z = "2022-10-14T20:08:48.000000Z"
    case the20221102T235129000000Z = "2022-11-02T23:51:29.000000Z"
    case the20221110T215859000000Z = "2022-11-10T21:58:59.000000Z"
}

// MARK: - Status
struct Status: Codable {
    let uniqueID: String?
    let longName:String?
    
    //LongName?
    let shortName:String?
    //ShortName?
    let elapsedTime: String?
    //let createdAt: DatumCreatedAt?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "unique_id"
        case longName = "long_name"
        case shortName = "short_name"
        case elapsedTime = "elapsed_time"
        //case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum LongName: String, Codable {
    case matchFinished = "Match Finished"
}

enum ShortName: String, Codable {
    case ft = "FT"
}

enum Timezone: String, Codable {
    case europeLondon = "Europe/London"
}

// MARK: - Venue
struct Venue: Codable {
    let uniqueID: String?
    let apiID: String?
    let name, city, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "unique_id"
        case apiID = "api_id"
        case name, city
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
extension Fixtures_ScoresModel:Equatable{
    static func == (lhs: Fixtures_ScoresModel, rhs: Fixtures_ScoresModel) -> Bool {
        return true
    }
}
