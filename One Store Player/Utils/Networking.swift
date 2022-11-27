//
//  Networking.swift
//  One Store Player
//
//  Created by MacBook Pro on 27/11/2022.
//

import Foundation
import Combine
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
    
    func getUserDetails()->UserInfo?{
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.userInfo.rawValue) as? Data {
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
}
