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
    @State var isLayoutGuideOn = false
    
    
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title:title)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(data, id: \.self) { item in
                            ButtonView(action: {
                                
                                isLayoutGuideOn.toggle()
                            },image: item)
                            .frame(width:200,height: 180)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding([.leading,.trailing],40)
                
            }
            
            if isLayoutGuideOn {
                LayoutDialoguView(isClose: $isLayoutGuideOn)
            }
            
            
        }
    }
    
}

struct LayoutDialoguView: View{
    var buttons = ["Modern","Classic"]
    
    @State var buttonSelected: Int = 0
    
    @Binding var isClose : Bool
    
    
    var body: some View{
        VStack{
            Text("View Format")
                .font(.carioBold)
                .foregroundColor(.black)
                .padding()
            Spacer()
            HStack{
                ForEach(0..<buttons.count,id:\.self) {
                    index in
                    
                    VStack{
                        Image(index == 0 ? "view_type_modern":"view_type_classic")
                            .resizable()
                            .frame(width: 200,height: 100)
                            .scaledToFill()
                        Button {
                            buttonSelected = index
                        } label: {
                            HStack{
                                Image(systemName: buttonSelected == index ? "dot.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 30,height: 30)
                                    .scaledToFill()
                                Text(self.buttons[index])
                                    .padding()
                                
                            }
                            
                        }
                    }
                    
                }
                
                
                
                
                
            }
            
            Spacer()
            
            Button {
                //Save
                isClose.toggle()
            } label: {
                Text("Save")
                    .font(.carioRegular)
            }.frame(width:200,height:50)
                .background(RoundedRectangle(cornerRadius: 5))
        }
        
        .frame(width: UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height - 30)
        .background(Color.white)
        
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
