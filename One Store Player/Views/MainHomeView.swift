//
//  MainHomeView.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import SwiftUI

enum StateType:String{
    case settings
    case movies
    case users
    case userAccount
    case sereris
    case liveTV
    case fixtures
    case epgLive
    case catchup
}
extension StateType: Identifiable {
    var id: RawValue { rawValue }
}

struct MainHomeView: View {
    @State private var stateType : StateType?
    @State private var userInfo:UserInfo?
    @AppStorage(AppStorageKeys.timeFormatt.rawValue) var formatte = hour_12
    @AppStorage(AppStorageKeys.language.rawValue) var lang = ""
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            if userInfo != nil {
                VStack{
                    // Top Header View
                    HStack{
                        // Logo
                        Image("Icon")
                            .resizable()
                            .frame(width:40,height: 40)
                            .scaledToFill()
                        Spacer()
                        // Today Date
//                        if #available(iOS 15.0,tvOS 15.0, *) {
//                            Text("\(Date().formatted())")
//                                .font(.carioRegular)
//                        } else {
//                            Text(Date().description)
//                                .font(.carioRegular)
//                        }
                        
                        if #available(iOS 15.0, *) {
                            Text("\(Date().description.getDateFormatted(format:defualtDateFormatte)) \(Date().getTime(format: formatte))")
                                .font(.carioRegular)
                        } else {
                            // Fallback on earlier versions
                            Text("\(Date().description) \(Date().getTime(format: formatte))")
                                .font(.carioRegular)
                        }
                        
                        Spacer()
                        Spacer()
                        // Users Catalog
                        HStack{
                            Button {
                                stateType = .userAccount
                            } label: {
                                Image("user_account_info")
                                    .resizable()
                                    .frame(width:20,height: 20)
                                    .scaledToFit()
                            }
                            .frame(width:20,height: 20)
                            
                            // Users Button
                            Button {
                                stateType = .users
                            } label: {
                                Image("ic_users")
                                    .resizable()
                                    .frame(width:30,height: 30)
                                    .scaledToFill()
                            }
                            .frame(width:30,height: 30)
                            //Settings Button
                            Button {
                                stateType = .settings
                            } label: {
                                Image("ic_settings")
                                    .resizable()
                                    .frame(width:30,height: 30)
                                    .scaledToFill()
                            }
                            .frame(width:30,height: 30)
                            
                                
                        }
                        
                    }
                    .padding(.top,30)
                    .padding(.horizontal)
                    //.frame(height: 50)
                    // Mid View for Watchings
                    VStack(spacing:20){
                        HStack{
                            
                            //Live TV
                            Button {
                                // Live TV
                                stateType = .liveTV
                            } label: {
                                Image("livetv")
                                    .resizable()
    //                                .frame(maxWidth:.infinity,maxHeight: .infinity)
                                    .scaledToFit()
                                    .cornerRadius(20)
                            }
                            .background(RoundedRectangle(cornerRadius: 20))
                            
                            // Movies
                            Button {
                                // movies
                                stateType = .movies
                            } label: {
                                Image("movies")
                                    .resizable()
    //                                .frame(maxWidth:.infinity,maxHeight: .infinity)
                                    .scaledToFit()
                                    .cornerRadius(20)
                            }
                            .background(RoundedRectangle(cornerRadius: 20))
                            
                            // Series
                            Button {
                                // Series
                                stateType = .sereris
                            } label: {
                                Image("series")
                                    .resizable()
    //                                .frame(maxWidth:.infinity,maxHeight: .infinity)
                                    .scaledToFit()
                                    .cornerRadius(20)
                            }
                            .background(RoundedRectangle(cornerRadius: 20))
                            
                            // Fixtures
                            Button {
                                // Fixtures
                                stateType = .fixtures
                            } label: {
                                Image("fixtures")
                                    .resizable()
    //                                .frame(maxWidth:.infinity,maxHeight: .infinity)
                                    .scaledToFit()
                                    .cornerRadius(20)
                            }
                            .background(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        
                        HStack{
                            Spacer()
                            Button {
                                // Live TV
                                stateType = .epgLive
                            } label: {
                                Image("Livewith")
                                    .resizable()
                                    .frame(width:200,height: 40)
                                    .scaledToFill()
                            }
                            
                            Button {
                                stateType = .catchup
                            } label: {
                                Image("catchup")
                                    .resizable()
                                    .frame(width:200,height: 40)
                                    .scaledToFill()
                            }
                            
                            Spacer()
                        }
                        
                    }
                    .padding()
                    
                    HStack{
                        Text("\("Expiration ".localized(lang)) \(Date().description.getDateFormatted(format: defualtDateFormatte))")
                        .font(.carioBold)
                        .font(.carioRegular)
                        Spacer()
                        Text("\("Login In: ".localized(lang)) \(Text(userInfo?.name ?? "").font(.carioBold))")
                            .font(.carioRegular)
                    }.padding()
                    
                    
                    
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
                .fullScreenCover(item: $stateType) { state in
                    if state == .liveTV {
                        LIveTVView()
                    }
                    else if state == .movies {
                        MoviesView(title:"Movies", type: .movie)
                    }
                    else if state == .sereris {
                        SeriesView(title: "Series", type: .series)
                    }
                    else if state == .settings {
                        #if os(tvOS)
                        TVOS_Settings()
                        #else
                        SettingsView(title:"Settings")
                        
                        #endif
                    }
                    else if state == .fixtures {
                        
                        FixturesScoresView()
                        
//                        #if os(tvOS)
//                        TVOS_Settings()
//                        #else
//                        FixturesScoresView()
//
//                        #endif
                    }
                    else if state == .users {
                        UserListView()
                    }
                    else if state == .userAccount {
                        UserAccountInfoView()
                    }
                    else if state == .epgLive {
                        EPGLiveView()
                    }else {
                        CatchUpView()
                    }
                }
            }
            else{
                LoginView()
            }
        }
        .onAppear {
            
            if let data = UserDefaults.standard.value(forKey: AppStorageKeys.currentUser.rawValue) as? Data {
                do {
                    // Create JSON Decoder
                    let decoder = JSONDecoder()
                    
                    // Decode Note
                    let userinfo = try decoder.decode(UserInfo.self, from: data)
                    userInfo = userinfo
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
        }
    }
}

struct MainHomeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0,tvOS 15.0, *) {
            MainHomeView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
