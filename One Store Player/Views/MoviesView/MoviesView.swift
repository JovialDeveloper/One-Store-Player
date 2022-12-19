//
//  MoviesView.swift
//  One Store Player
//
//  Created by MacBook Pro on 07/11/2022.
//

import SwiftUI

struct MoviesView: View {
    @AppStorage(AppStorageKeys.layout.rawValue) var layout: AppKeys.RawValue = AppKeys.modern.rawValue
    @Environment(\.presentationMode) var presentationMode
    var title : String
    var type:ViewType
    @StateObject private var favMovies = MoviesFavourite()
    @State var selectMoview = 0
//    init(){
//        UITableView.appearance().backgroundColor = .red
//        UITableView.appearance().ce
//    }
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            
            if layout == AppKeys.modern.rawValue {
                // Modern View
                ModernLayoutView(subject: (title,type))
                    .environmentObject(favMovies)
            }
            else {
                ClassicLayoutView(subject: (title,type))
                    .environmentObject(favMovies)
            }
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        //.ignoresSafeArea(.keyboard,edges: .all)
        
        
    }
}


