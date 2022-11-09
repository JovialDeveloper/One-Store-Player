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
                ModernLayoutView(title: title)
            }
            else {
                ClassicLayoutView(title: title)
            }
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .ignoresSafeArea()
        
        
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            MoviesView(title: "ALL")
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}


