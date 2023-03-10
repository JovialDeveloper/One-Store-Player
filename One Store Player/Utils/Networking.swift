//
//  Networking.swift
//  One Store Player
//
//  Created by MacBook Pro on 27/11/2022.
//

import Foundation
import Combine
import SwiftUI
final class Networking{
    static let shared = Networking()
    
    func fetch<T:Codable> (uri:String,method:String="GET") -> AnyPublisher<T, APIError>{
        let url = URL(string: uri)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .receive(on: DispatchQueue.main)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                }catch{
                    throw APIError.apiError(reason: error.localizedDescription)
                }
                
            }
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.apiError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    func getStreamingLink(id:Int,type:String)->String{
        @AppStorage(AppStorageKeys.videoFormat.rawValue) var format = VideoFormats.mp4.rawValue
        
        if let info = getUserDetails() {
            if type == StreamType.live.rawValue{
                if info.port.hasSuffix("/") {
                    let uri = "\(info.port)\(info.username)/\(info.password)/\(id)"
                    return uri
                }else{
                    let uri = "\(info.port)/\(info.username)/\(info.password)/\(id)"
                    return uri
                }
            }else {
                if info.port.hasSuffix("/") {
                    let uri = "\(info.port)\(type)/\(info.username)/\(info.password)/\(id).\(format)"
    //                let uri = "\(info.port)\(type)/\(info.username)/\(info.password)/\(id)"
                    return uri
                }else{
                    let uri = "\(info.port)/\(type)/\(info.username)/\(info.password)/\(id).\(format)"
    //                let uri = "\(info.port)/\(type)/\(info.username)/\(info.password)/\(id)"
                    return uri
                }
            }
            
            
        }
        return ""
    }
    func getUserDetails()->UserInfo?{
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.currentUser.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let userinfo = try decoder.decode(UserInfo.self, from: data)
                return userinfo
            } catch {
                print("Unable to Decode Note (\(error))")
            }

        }
        return nil
    }
    
    func streamingURL(){
        let url = URL(string: "http://1player.cc:80/ec1RxLkPaWiHVy/ULaH9AmLRXDmBy7/27130")!
        
        URLSession.shared.dataTask(with: .init(url: url)) { data, response, error in
            if error != nil {
                debugPrint("E",error)
            }else{
                if let data = data {
                    debugPrint(String(data: data, encoding: .utf8))
                }
               
            }
                
        }.resume()
    }
}
