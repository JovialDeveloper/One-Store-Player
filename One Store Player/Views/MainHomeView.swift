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
    @State private var isLayout = false
    @AppStorage(AppStorageKeys.timeFormatt.rawValue) var formatte = hour_12
    @AppStorage(AppStorageKeys.language.rawValue) var lang = SupportedLanguages.englishLang
    @EnvironmentObject private var state:AppState
    fileprivate func fetchCurrentUser() {
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
    
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            
            if userInfo != nil {
                
                VStack{
                    // Top Header View
                    HStack{
                        Image("Icon")
                            .resizable()
                            .frame(width:60,height: 60)
                            .scaledToFill()
                        
                        if #available(iOS 15.0, *) {
                            
                            Text("\(Date().description.getDateFormatted(format:englishDateFormatte)) \(Date().getTime(format: formatte))")
                                .font(.carioRegular)
                        } else {
                            // Fallback on earlier versions
                            Text("\(Date().description) \(Date().getTime(format: formatte))")
                                .font(.carioRegular)
                        }
                        
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
                    Spacer()
                    VStack(spacing:20){
                        HStack{
                            
                            //Live TV
                            Button {
                                // Live TV
                                stateType = .liveTV
                            } label: {
                                Image("livetv")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(20)
                                    .overlay(MainClassButtonTextOvarly(title: "Live TV", lang: lang),alignment: .center)
                            }
                            .background(RoundedRectangle(cornerRadius: 20))
                            
                            // Movies
                            Button {
                                // movies
                                stateType = .movies
                            } label: {
                                Image("movies")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(20)
                                    .overlay(MainClassButtonTextOvarly(title: "Movies", lang: lang),alignment: .center)
                            }
                            .background(RoundedRectangle(cornerRadius: 20))
                            
                            // Series
                            Button {
                                // Series
                                stateType = .sereris
                            } label: {
                                Image("series")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(20)
                                    //.rotationEffect(Angle(degrees: 90))
                                    .overlay(MainClassButtonTextOvarly(title: "Series", lang: lang),alignment: .center)
                            }
                            .background(RoundedRectangle(cornerRadius: 20))
                            
                            // Fixtures
                            Button {
                                // Fixtures
                                stateType = .fixtures
                            } label: {
                                Image("fixtures")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(20)
                                    .overlay(MainClassButtonTextOvarly(title: "Scores & Fixtures", lang: lang),alignment: .center)
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
//                    .padding()
                    Spacer()
                    HStack{
                        Text("\("Expiration ".localized(lang.rawValue)) \(userInfo?.expDate?.getDate() ?? "")")
                        .font(.carioBold)
                        .font(.carioRegular)
                        Spacer()
                        Text("\("Login In: ".localized(lang.rawValue)) \(Text(userInfo?.name ?? "").font(.carioBold))")
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
//                        #if os(tvOS)
//                        TVOS_Settings()
//                        #else
//                        SettingsView(title:"Settings")
//
//                        #endif
                        
                        SettingsView(title:"Settings")
                        
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
               
                if isLayout {
                    LayoutDialoguView(isClose:$isLayout)
                }
            }
            else{
                LoginView()
            }
        }
        .onAppear {
            
            fetchCurrentUser()
//            let isFirstTime = UserDefaults.standard.value(forKey: AppStorageKeys.isFirstTime.rawValue) as? Bool
//            isLayout = isFirstTime ?? false
            
        }
        .onReceive(NotificationCenter.Publisher.init(center: .default, name: .selectLayout)) { _ in
            isLayout = true
        }
        .onReceive(NotificationCenter.Publisher.init(center: .default, name: .userSelect)) { _ in
            fetchCurrentUser()
        }
        
    }
    
    
    
}

fileprivate struct MainClassButtonTextOvarly:View{
    var title:String
    var lang:SupportedLanguages
    var body: some View {
        Text(title.localized(lang.rawValue))
            .padding()
            .font(.carioBold)
            .lineLimit(2)
            .minimumScaleFactor(0.5)
            .foregroundColor(.black)
            .offset(y:35)
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
