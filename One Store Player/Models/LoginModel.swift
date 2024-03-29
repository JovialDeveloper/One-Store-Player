//
//  LoginModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 27/11/2022.
//

import Foundation


// MARK: - UserInfo
struct UserInfo: Codable,Identifiable{
    var id : String
    let name,username, password, message: String
    let auth: Int
    let status: String
    let port : String
    let expDate: String?
    let isTrial, activeCons, createdAt, maxConnections: String
    
    init(id: String = UUID().uuidString,name:String,port:String,data:[String:Any]) {
        self.id = id
        self.name = name
        self.username = data[CodingKeys.username.rawValue] as! String
        self.password = data[CodingKeys.password.rawValue] as! String
        self.message = data[CodingKeys.message.rawValue] as! String
        self.auth = data[CodingKeys.auth.rawValue] as! Int
        self.status = data[CodingKeys.status.rawValue] as! String
        self.expDate = data[CodingKeys.expDate.rawValue] as! String
        self.isTrial = data[CodingKeys.isTrial.rawValue] as! String
        self.activeCons = data[CodingKeys.activeCons.rawValue] as! String
        self.createdAt = data[CodingKeys.createdAt.rawValue] as! String
        self.maxConnections = data[CodingKeys.maxConnections.rawValue] as! String
        self.port = port
    }
    
    enum CodingKeys: String, CodingKey {
        case id,name,username,port,password, message, auth, status
        case expDate = "exp_date"
        case isTrial = "is_trial"
        case activeCons = "active_cons"
        case createdAt = "created_at"
        case maxConnections = "max_connections"
        //case allowedOutputFormats = "allowed_output_formats"
    }
}

struct UserPaternalControl:Codable{
    var userName:String
    var password:String
}

extension UserInfo:Equatable{}
