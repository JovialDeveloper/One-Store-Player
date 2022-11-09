//
//  SettingsView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(AppStorageKeys.layout.rawValue) var layout: AppKeys.RawValue =  AppKeys.modern.rawValue
    @Environment(\.presentationMode) var presentationMode
    let data = ["layout","EPGTime","lang","parentalcontrol","stream format","time","automation1"]

    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let title:String
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title:title)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(data, id: \.self) { item in
                            ButtonView(action: {
                                
                                layout = AppKeys.classic.rawValue
                            },image: item)
                                .frame(width:200,height: 180)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding([.leading,.trailing],40)
                
            }
            

        }
    }
    
}

//fileprivate struct CustomButtonSetting:View{
//    let
//    var body: some View{


//let data = (1...100).map { "Item \($0)" }
//
//let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 4)
//var body: some View{
//    ScrollView {
//        LazyVGrid(columns: columns, spacing: 10) {
//            ForEach(data, id: \.self) { item in
//                movieCell
//            }
//        }
//    }
//}

//        ZStack{
//            Button {
//                //
//            } label: {
//                Image()
//                Text("")
//            }
//
//        }
//    }
//}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            SettingsView(title: "ALL")
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
