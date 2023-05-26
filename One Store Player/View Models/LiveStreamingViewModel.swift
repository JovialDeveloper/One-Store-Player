//
//  LiveStreamingViewModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 27/11/2022.
//

import Foundation
import Combine
class LiveStreamingViewModel:ObservableObject{
    @Published var isLoading = false
    @Published var isfetched = false
    @Published var isError = (false,"")
    @Published var selectStream:LiveStreams?
    @Published var selectCategory:MovieCategoriesModel?
    var subscriptions = [AnyCancellable]()
    private var defaults = UserDefaults.standard
    
    func fetchAllCategories() -> AnyPublisher<[MovieCategoriesModel], APIError>
    {
        guard let userInfo =  Networking.shared.getUserDetails()
        else {
            return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
        }
        let uri = "\(userInfo.port)player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_live_categories"
        return Networking.shared.fetch(uri: uri)
    }
    
    func fetchAllLiveStreaming(baseURL:String = "http://1player.cc:80") -> AnyPublisher<[LiveStreams], APIError>
    {
        if getLocalLiveStreams().count > 0 {
            return Just(getLocalLiveStreams())
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }else {
            guard let userInfo =  Networking.shared.getUserDetails()
            else {
                return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
            }
            let uri = "\(userInfo.port)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_live_streams"
            return Networking.shared.fetch(uri: uri)
        }
        
    }
    
    func fetchAllSubStreamsInCategory(baseURL:String = "http://1player.cc:80",category:String) -> AnyPublisher<[LiveStreams], APIError>
    {
        guard let userInfo =  Networking.shared.getUserDetails()
        else {
            return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
        }
        let uri = "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_live_streams&category_id=\(category)"
        return Networking.shared.fetch(uri: uri)
    }
    
    
   func storeLiveStreams(object:[LiveStreams]){
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object){
           UserDefaults.standard.set(encoded, forKey: LocalStorageKeys.liveStreams.rawValue)
           debugPrint("Save in Local")
       }
       
//       let archiveData = NSKeyedArchiver.archivedData(withRootObject: object)
//       defaults.setValue(archiveData, forKey: LocalStorageKeys.liveStreams.rawValue)
//       debugPrint("Save in Local")
    }
    
    private func getLocalLiveStreams()-> [LiveStreams] {
        let decoder = JSONDecoder()
        if let streamsData = defaults.value(forKey: LocalStorageKeys.liveStreams.rawValue) as? Data
        {
            if let strs = try? decoder.decode([LiveStreams].self, from: streamsData) {
                return strs
            }
             return []
        }else {
            return []
        }
        
    }
    
}
