//
//  One_Store_PlayerApp.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import SwiftUI
import IQKeyboardManagerSwift
@main
struct One_Store_PlayerApp: App {
    @AppStorage(AppStorageKeys.language.rawValue) var lang = ""
    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(\.locale, Locale(identifier: lang))
            
            //MoviesView()
            //MainHomeView()
              //.environment(\.locale, Locale(identifier: lang))
//              .onAppear {
//                  IQKeyboardManager.shared.enable = true
//              }
            
              
            
            //LoginView()
            //WatchView()
            //FixturesScoresView()
        }
    }
}
