//
//  StartView.swift
//  One Store Player
//
//  Created by MacBook Pro on 19/12/2022.
//

import SwiftUI
@MainActor
class AppState: ObservableObject {
//    @Published var username = "Anonymous"
//    @Published var isAuthenticated = false
    
    @Published var isLogin = false
    @Published var isPaternalControlOn = false
    func checkSession(){
        if let _ = UserDefaults.standard.value(forKey: AppStorageKeys.currentUser.rawValue) as? Data {
            let econd = UserDefaults.standard.value(forKey: AppStorageKeys.paternalControl.rawValue) as? Data
            if econd != nil {
                isPaternalControlOn = true
            }else {
                isLogin = true
            }
        }else {
            isLogin = false
        }
    }
}

struct StartView: View {
    @ObservedObject var state = AppState()
    var alertTitle = "Please enter your username and password."
    init() {
        state.checkSession()
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            debugPrint("IPADDDDDDDD")
        }
    }
    @AppStorage(AppStorageKeys.language.rawValue) var lang = SupportedLanguages.englishLang
    
    var body: some View {
        if state.isLogin {
            MainHomeView()
                .environment(\.layoutDirection,lang == SupportedLanguages.arbic ? .rightToLeft : .leftToRight)
                .environmentObject(state)
            
        } else if state.isPaternalControlOn {
            
            AlertPCView(show: $state.isPaternalControlOn, title: "Paternal Control", message: alertTitle,isCheckPasswordScreen: true) { complete in
                if complete {
                    state.isLogin = true
                }else {
                    state.isLogin = false
                }
            }
        }
        else {
            LoginView()
                .environmentObject(state)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
