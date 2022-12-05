//
//  NavigationHeaderView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI

struct NavigationHeaderView: View {
    var title:String
    @State private var isSeachFieldHide = true
    @State private var searchText = ""
    var searchAction : ((String)->Void)? = nil
    var moreAction : (()->Void)? = nil
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(AppStorageKeys.language.rawValue) var lang = ""
    var body: some View {
        HStack{
            // Logo
            if #available(iOS 13.0,tvOS 16.0, *) {
                Image("arrow_back")
                    .resizable()
                    .frame(width:40,height: 40)
                    .scaledToFill()
                    .foregroundColor(.white)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            } else {
                // Fallback on earlier versions
            }
            Spacer()
            if !isSeachFieldHide {
                TextField("Search", text: $searchText) {
                    isSeachFieldHide.toggle()
                    searchAction?(searchText)
                }

            }
            Text(title.localized(lang))
                .font(.carioBold)
                .foregroundColor(.white)
            
            Spacer()
            // Users Catalog
            HStack{
                Button {
                    isSeachFieldHide.toggle()
                } label: {
                    Image("search")
                        .resizable()
                        .frame(width:30,height: 30)
                        .scaledToFill()
                        .foregroundColor(.white)
                }
                .frame(width:40,height: 40)
                
                // Users Button
                Button {
                    moreAction?()
                } label: {
                    Image("more")
                        .resizable()
                        .frame(width:30,height: 30)
                        .scaledToFill()
                        .foregroundColor(.white)
                }
                .frame(width:40,height: 40)
            }
            
        }
        .padding(.top,30)
        .padding(.horizontal)
    }
}

struct NavigationHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationHeaderView(title: "")
    }
}
