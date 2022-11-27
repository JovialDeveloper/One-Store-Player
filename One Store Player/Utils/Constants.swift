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
}
enum AppKeys:String{
    typealias RawValue = String
    case modern
    case classic
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
