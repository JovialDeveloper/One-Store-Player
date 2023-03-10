//
//  Constants.swift
//  One Store Player
//
//  Created by MacBook Pro on 07/11/2022.
//

import Foundation

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
let arbic = "ar"
let englishLang = "en"


let defualtDateFormatte = "MM/dd/yyyy"

enum VideoFormats:String{
    case ts
    case mp4
    case m3u8
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
}
