//
//  One_Store_PlayerApp.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import SwiftUI

@main
struct One_Store_PlayerApp: App {
    @AppStorage(AppStorageKeys.language.rawValue) var lang = ""
    var body: some Scene {
        WindowGroup {
            //MoviesView()
            MainHomeView()
              .environment(\.locale, Locale(identifier: lang))
              
            
            //LoginView()
            //WatchView()
            //FixturesScoresView()
        }
    }
}
