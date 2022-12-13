//
//  ModernLayoutViewModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 29/11/2022.
//

import Foundation
import Combine
extension ModernLayoutView {
    
    class ModernLayoutViewModel:ObservableObject{
        @Published var isLoading = false
        @Published var isfetched = false
        @Published var isError = (false,"")
        var subscriptions = [AnyCancellable]()
        
        func fetchAllMovies() -> AnyPublisher<[MovieModel], APIError>{
            guard let userInfo =  Networking.shared.getUserDetails()
            else {
                return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
            }
            
            let uri = "\(userInfo.port)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_vod_streams"
            return Networking.shared.fetch(uri: uri)
        }
        
        func fetchAllMoviewCategories(baseURL:String = "http://1player.cc:80",type:ViewType) -> AnyPublisher<[MovieCategoriesModel], APIError>
        {
            guard let userInfo =  Networking.shared.getUserDetails()
            else {
                return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
            }
            
            let uri = type == .movie ? "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_vod_categories" : "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series_categories"
            return Networking.shared.fetch(uri: uri)
        }
        
        func fetchAllMoviesById(baseURL:String = "http://1player.cc:80",id:String,type:ViewType) -> AnyPublisher<[MovieModel], APIError>
        {
            guard let userInfo =  Networking.shared.getUserDetails()
            else {
                return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
            }
            isLoading.toggle()
            let uri = type == .movie ? "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_vod_streams&category_id=\(id)" : "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series&category_id=\(id)"
            return Networking.shared.fetch(uri: uri)
        }
    }
}

class ClassicViewModel:ObservableObject{
    @Published var isLoading = false
    @Published var isfetched = false
    @Published var isError = (false,"")
    var subscriptions = [AnyCancellable]()
    func fetchAllMoviewCategories(baseURL:String = "http://1player.cc:80",type:ViewType) -> AnyPublisher<[MovieCategoriesModel], APIError>
    {
        guard let userInfo =  Networking.shared.getUserDetails()
        else {
            return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
        }
        
        let uri = type == .movie ? "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_vod_categories" : "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series_categories"
        return Networking.shared.fetch(uri: uri)
    }
    
    func fetchAllMoviesById<T:Codable>(baseURL:String = "http://1player.cc:80",id:String,type:ViewType) -> AnyPublisher<[T], APIError>
    {
        guard let userInfo =  Networking.shared.getUserDetails()
        else {
            return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
        }
        isLoading.toggle()
        let uri = type == .movie ? "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_vod_streams&category_id=\(id)" : "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series&category_id=\(id)"
        return Networking.shared.fetch(uri: uri)
    }
}
