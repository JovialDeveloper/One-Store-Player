//
//  LoginViewModelExt.swift
//  One Store Player
//
//  Created by MacBook Pro on 27/11/2022.
//

import Foundation
import Combine
extension LoginView {
    class LoginViewModel:ObservableObject {
        @Published var isLoading = false
        @Published var isLogin = false
        @Published var isError = (false,"")
        @Published var name = "Ali"
        @Published var password = "ULaH9AmLRXDmBy7"
        @Published var port = "http://1player.cc:80/"
        @Published var userName = "ec1RxLkPaWiHVy"
        @Published var successfullyLogin = false
        var subscriptions = [AnyCancellable]()
        func login() -> AnyPublisher<UserInfo, APIError> {
            guard !userName.isEmpty,
                  !name.isEmpty,
                  !password.isEmpty,
                  !port.isEmpty else {
                return Fail(error: APIError.apiError(reason: "Kindly fill all fields")).eraseToAnyPublisher()
            }
            
            let uri = "\(port)player_api.php?username=\(userName)&password=\(password)"
            let url = URL(string: uri)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            isLoading.toggle()
            return URLSession.DataTaskPublisher(request: request, session: .shared)
                .receive(on: DispatchQueue.main)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                        
                        throw APIError.credientialsWrong
                    }
                    self.isLoading.toggle()
                    self.isLogin.toggle()
                    do {
                        
                        let dic = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                        let userinfo = dic["user_info"] as! [String:Any]
                        let model = UserInfo(name: self.name, data: userinfo)
                        
                        let encoder = JSONEncoder()
                            // Encode Note
                        let modelData = try encoder.encode(model)

                        UserDefaults.standard.set(modelData, forKey: AppStorageKeys.userInfo.rawValue)
                        return model
                    }catch{
                        throw APIError.apiError(reason: error.localizedDescription)
                    }
                    
                }
                .mapError { error in
                    self.isLoading.toggle()
                    if let error = error as? APIError {
                        return error
                    } else {
                        return APIError.apiError(reason: error.localizedDescription)
                    }
                }
                .eraseToAnyPublisher()
        }
        
    }
}


