//
//  Constants.swift
//  One Store Player
//
//  Created by MacBook Pro on 07/11/2022.
//

import Foundation

enum LocalStorageKeys:String{
    case liveStreams
    case liveCategories
    case movies
    case moviesCategories
    case sereis
    case seriesCategories
    case allMoviesCategories
    case allSeriesCategories
}

extension Notification.Name{
    static let resumePlaying = Notification.Name("resumePlaying")
    static let addNewUser = Notification.Name("addNewUser")
    static let userSelect = Notification.Name("userSelect")
}

enum AppStorageKeys:String{
    typealias RawValue = String
    case layout
    case lang
    case userInfo
    case currentUser
    case timeFormatt
    case language
    case videoFormat
    case favMovies
    case favSeries
    case favLiveStreams
    case automate
    case egp
    case paternalControl
}
enum AppKeys:String{
    typealias RawValue = String
    case modern
    case classic
}
enum ViewType:String{
    typealias RawValue = String
    case movie
    case series
    case liveTV
    case favourite
}
enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String), credientialsWrong
    var errorDescription: String? {
        switch self {
        case .unknown:
            
            return "Unknown error"
        case .apiError(let reason):
            return reason
        case .credientialsWrong:
            return "UserName or Password wrong"
        }
    }
}

//Time formats

let hour_12 = "hh:mm a"

let hour_24 = "HH:mm a"
// Languages
enum SupportedLanguages:String{
    case arbic = "ar"
    case englishLang = "en"
}
//let arbic = "ar"
//let englishLang = "en"


let defualtDateFormatte = "MM/dd/yyyy"

enum VideoFormats:String{
    case ts
    case mp4
    case m3u8
    case mkv
}

extension String {
    func toFloat()->Float{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.allowsFloats = true
        let hour = self.split(separator: ":")
        if let number = numberFormatter.number(from: "02,03,43") {
            debugPrint("FFFFFF09")
            return number.floatValue
        }
        return Float()
    }
    func getDateWithTimeInterval()->Date{
        if let timeInterval = TimeInterval(self) {
            return Date(timeIntervalSince1970: timeInterval)
            
        }
        return Date()
    }
    
    func getDate()->String{
        if let timeInterval = TimeInterval(self) {
            let date = Date(timeIntervalSince1970: timeInterval)
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: date)
        }
        return "--"
    }
    
    func getFormattedDates(value:Int)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = Calendar.current.date(byAdding: .day, value: value, to: Date()) {
            return formatter.string(from: date)
        }
        return ""
    }
}

import SwiftUI
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
