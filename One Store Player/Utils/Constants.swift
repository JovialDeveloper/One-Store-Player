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
