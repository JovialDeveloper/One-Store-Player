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
        @Published var password =  "332255566"
        @Published var port = "http://1player.cc:80/"
        @Published var userName = "Test2345"
        @Published var successfullyLogin = false
        @Published var isUserUpdate = false
        var selectUser:UserInfo?
        var subscriptions = [AnyCancellable]()
        func login() -> AnyPublisher<UserInfo, APIError> {
            guard !userName.isEmpty,
                  !name.isEmpty,
                  !password.isEmpty,
                  !port.isEmpty else {
                return Fail(error: APIError.apiError(reason: "Kindly fill all fields")).eraseToAnyPublisher()
            }
            
            guard port.hasSuffix("/") else {
                isError = (true,"Kindly insert / at the end of url")
                return Fail(error: APIError.apiError(reason: "Kindly insert / at the end of url")).eraseToAnyPublisher()
            }
            
            guard !port.hasSuffix("//") else {
                isError = (true,"Kindly insert correct url")
                return Fail(error: APIError.apiError(reason: "Kindly insert correct url")).eraseToAnyPublisher()
            }
            
            guard !port.contains(" ") else {
                isError = (true,"Kindly insert correct url")
                return Fail(error: APIError.apiError(reason: "Kindly insert correct url")).eraseToAnyPublisher()
            }
            
            
            let uri = "\(port)player_api.php?username=\(userName)&password=\(password)"
            let url = URL(string: uri)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            isLoading.toggle()
            return URLSession.DataTaskPublisher(request: request, session: .shared)
                .receive(on: DispatchQueue.main)
                .tryMap { [weak self] data, response in
                    guard let self = self else {
                        throw APIError.apiError(reason: "Deallocate")
                    }
                    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                        
                        throw APIError.credientialsWrong
                    }
                    self.isLoading.toggle()
                    self.isLogin.toggle()
                    do {
                        
                        let dic = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                        let userinfo = dic["user_info"] as! [String:Any]
                        let model = UserInfo(name: self.name, port: self.port, data: userinfo)
                        
                        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.userInfo.rawValue) as? Data {
                            do {
                                // Create JSON Decoder
                                if self.isUserUpdate, self.selectUser != nil {
                                    let Mooo = UserInfo(id:self.selectUser!.id,name: self.name, port: self.port, data: userinfo)
                                    let updatedUser = self.userUpdate(user: Mooo)
                                    let modelData = try JSONEncoder().encode(updatedUser)
                                    UserDefaults.standard.set(modelData, forKey: AppStorageKeys.userInfo.rawValue)
                                    self.isUserUpdate = false
                                    
                                } else{
                                    let decoder = JSONDecoder()
                                    
                                    // Decode Note
                                    var usersinfo = try decoder.decode([UserInfo].self, from: data)
                                    usersinfo.append(model)
                                    
                                    let encoder = JSONEncoder()
                                        // Encode Note
                                    let modelData = try encoder.encode(usersinfo)

                                    UserDefaults.standard.set(modelData, forKey: AppStorageKeys.userInfo.rawValue)
                                    let currentModel = try encoder.encode(model)
                                    
                                    UserDefaults.standard.set(currentModel, forKey: AppStorageKeys.currentUser.rawValue)
                                    
                                    //return model
                                }
                                
                                
                                
                            } catch {
                                print("Unable to Decode Note (\(error))")
                            }

                        }
                        else{
                            let encoder = JSONEncoder()
                            let modelData = try encoder.encode([model])
                            UserDefaults.standard.set(modelData, forKey: AppStorageKeys.userInfo.rawValue)
                            let currentModel = try encoder.encode(model)
                            UserDefaults.standard.set(currentModel, forKey: AppStorageKeys.currentUser.rawValue)
                            
                            //return model
                        }
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
        
        func userUpdate(user:UserInfo)->[UserInfo]{
            if !getLocalUsers().isEmpty {
                var users = getLocalUsers()
                if let index = users.firstIndex(where: {$0.id == user.id}) {
                    users.remove(at: index)
                    users.insert(user, at: index)
                    return users
                }
            }
            return getLocalUsers()
        }
        
        private func getLocalUsers() -> [UserInfo] {
            if let data = UserDefaults.standard.value(forKey: AppStorageKeys.userInfo.rawValue) as? Data {
                do {
                    // Create JSON Decoder
                    let decoder = JSONDecoder()
                    // Decode Note
                    let userinfo = try decoder.decode([UserInfo].self, from: data)
                    return userinfo
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }else {
                print("Error")
            }
            return []
        }
        
    }
}


