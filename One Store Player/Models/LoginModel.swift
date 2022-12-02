//
//  LoginModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 27/11/2022.
//

import Foundation


// MARK: - UserInfo
struct UserInfo: Codable,Identifiable{
    var id = UUID().uuidString
    let name,username, password, message: String
    let auth: Int
    let status: String
    let port : String
    //let expDate: String
    let isTrial, activeCons, createdAt, maxConnections: String
    //let allowedOutputFormats: [String]
    
    init(name:String,port:String,data:[String:Any]) {
        self.name = name
        self.username = data[CodingKeys.username.rawValue] as! String
        self.password = data[CodingKeys.password.rawValue] as! String
        self.message = data[CodingKeys.message.rawValue] as! String
        self.auth = data[CodingKeys.auth.rawValue] as! Int
        self.status = data[CodingKeys.status.rawValue] as! String
        //self.expDate = data[CodingKeys.expDate.rawValue] as! String
        self.isTrial = data[CodingKeys.isTrial.rawValue] as! String
        self.activeCons = data[CodingKeys.activeCons.rawValue] as! String
        self.createdAt = data[CodingKeys.createdAt.rawValue] as! String
        self.maxConnections = data[CodingKeys.maxConnections.rawValue] as! String
        self.port = port
//        self.allowedOutputFormats = data[CodingKeys.allowedOutputFormats.rawValue] as! String
    }
    
    enum CodingKeys: String, CodingKey {
        case name,username,port,password, message, auth, status
        //case expDate = "exp_date"
        case isTrial = "is_trial"
        case activeCons = "active_cons"
        case createdAt = "created_at"
        case maxConnections = "max_connections"
        //case allowedOutputFormats = "allowed_output_formats"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
