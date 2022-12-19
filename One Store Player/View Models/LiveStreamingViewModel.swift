//
//  LiveStreamingViewModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 27/11/2022.
//

import Foundation
import Combine
extension LIveTVView{
    class LiveStreamingViewModel:ObservableObject{
        @Published var isLoading = false
        @Published var isfetched = false
        @Published var isError = (false,"")
        var subscriptions = [AnyCancellable]()
        func fetchAllLiveStreaming(baseURL:String = "http://1player.cc:80") -> AnyPublisher<[LiveStreams], APIError>
        {
            guard let userInfo =  Networking.shared.getUserDetails()
            else {
                return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
            }
            let uri = "\(userInfo.port)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_live_streams"
            return Networking.shared.fetch(uri: uri)
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
    }
}
