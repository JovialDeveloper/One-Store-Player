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
    
    func checkSession(){
        if let _ = UserDefaults.standard.value(forKey: AppStorageKeys.currentUser.rawValue) as? Data {
            isLogin = true
        }else {
            isLogin = false
        }
    }
}

struct StartView: View {
    @ObservedObject var state = AppState()
    init() {
        state.checkSession()
    }
    var body: some View {
        if state.isLogin {
            MainHomeView()
                .environmentObject(state)
        }else {
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
