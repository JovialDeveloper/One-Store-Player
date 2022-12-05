//
//  SettingsView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI
enum SettingsKeys:String,CaseIterable{
    case layout
    case EPGTime
    case lang
    case parentalcontrol
    case streamFormat
    case time
    case automation1
}
struct SettingsView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    //let data = ["layout","EPGTime","lang","parentalcontrol","stream format","time","automation1"]
    fileprivate let data = SettingsKeys.allCases
    
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let title:String
    @State private var isLayoutGuideOn = false
    @State private var isTimeFormatButtonOn = false
    @State private var isLanguageButtonOn = false
    @State private var isParentalControlButtonOn = false
    @State private var isEPGButtonOn = false
    @State private var isAutomationOn = false
    @State private var selectButtonType : SettingsKeys?
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title:title)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(data, id: \.self) { item in
                           #if os(tvOS)
                            
                            ButtonView(action: {
                                if item == .layout {
                                    isLayoutGuideOn.toggle()
                                }
                                if item == .time {
                                    isTimeFormatButtonOn.toggle()
                                }
                                if item == .EPGTime{
                                    isEPGButtonOn.toggle()
                                }
                                if item == .lang{
                                    isLanguageButtonOn.toggle()
                                }
                                if item == .automation1{
                                    isAutomationOn.toggle()
                                }
                                
                            },image: item.rawValue)
                            .frame(minWidth:200,minHeight: 180)
                            .cornerRadius(10)
                            
                            #else
                            ButtonView(action: {
                                if item == .layout {
                                    isLayoutGuideOn.toggle()
                                }
                                if item == .time {
                                    isTimeFormatButtonOn.toggle()
                                }
                                if item == .EPGTime{
                                    isEPGButtonOn.toggle()
                                }
                                if item == .lang{
                                    isLanguageButtonOn.toggle()
                                }
                                if item == .automation1{
                                    isAutomationOn.toggle()
                                }
                                
                            },image: item.rawValue)
                            .frame(width:200,height: 180)
                            .cornerRadius(10)
                            
                            #endif
                            
                        }
                    }
                }
                .padding([.leading,.trailing],40)
                
            }
            
            if isLayoutGuideOn {
                LayoutDialoguView(isClose: $isLayoutGuideOn)
            }
            if isTimeFormatButtonOn {
                TimeDialoguView(isClose: $isTimeFormatButtonOn)
            }
            if isEPGButtonOn {
                EPGView(isClose: $isEPGButtonOn)
            }
            if isLanguageButtonOn {
                LangaugeSelectView(isClose: $isLanguageButtonOn)
                
            }
            if isAutomationOn {
                AutomationView(isClose: $isAutomationOn)
            }
            
            
        }
    }
    
}

fileprivate struct LayoutDialoguView: View{
    var buttons = ["Modern","Classic"]
    
    @State var buttonSelected: Int = 0
    
    @Binding var isClose : Bool
    @AppStorage(AppStorageKeys.layout.rawValue) private var layout: AppKeys.RawValue =  AppKeys.modern.rawValue
    
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
                            
                        }.foregroundColor(.black)
                    }
                    
                }
                
                
                
                
                
            }
            
            Spacer()
            
            Button {
                //Save
                if buttonSelected == 0 {
                    layout = AppKeys.modern.rawValue
                    isClose.toggle()
                }else{
                    layout = AppKeys.classic.rawValue
                    isClose.toggle()
                }
                
            } label: {
                Text("Save")
                    .font(.carioRegular)
                    .foregroundColor(.white)
            }.frame(width:100,height:50)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                .padding()
        }
        
        .frame(width: UIScreen.main.bounds.width/1.5,height: UIScreen.main.bounds.height - 60)
        .background(Color.white)
        .onAppear {
            if layout == AppKeys.modern.rawValue {
                buttonSelected = 0
            }else{
                buttonSelected = 1
            }
        }
        
    }
}

fileprivate struct TimeDialoguView: View{
    var buttons = ["24 Hours Format","12 Hours Format"]
    
    @State var buttonSelected: Int = 0
    
    @Binding var isClose : Bool
    
    @AppStorage(AppStorageKeys.timeFormatt.rawValue) var formatte = ""
    var body: some View{
        VStack{
            Text("Time Format")
                .font(.carioBold)
                .foregroundColor(.black)
                .padding()
            Divider()
                .frame(height: 4)
                .overlay(Color.black)
            Spacer()
            VStack{
                ForEach(0..<buttons.count,id:\.self) {
                    index in
                    
                    VStack{
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
                            
                        }.foregroundColor(.black)
                    }
                    
                }
                
                
                
                
                
            }
            
            Spacer()
            HStack{
                Button {
                    //Save
                    isClose.toggle()
                    if buttonSelected == 0 {
                        formatte = hour_24
                    }else{
                        formatte = hour_12
                    }
                } label: {
                    Text("Save")
                        .font(.carioRegular)
                        .foregroundColor(.white)
                }.frame(width:100,height:50)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                    .padding()
                
                Button {
                    //Save
                    isClose.toggle()
                } label: {
                    Text("Cancel")
                        .font(.carioRegular)
                        .foregroundColor(.white)
                }.frame(width:100,height:50)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                    .padding()
            }
            
        }
        
        .frame(width: 300,height: UIScreen.main.bounds.height - 60)
        .background(Color.white)
        .onAppear {
            if formatte == hour_12 {
                buttonSelected = 1
            }else{
                buttonSelected = 0
            }
        }
        
    }
}

struct EPGView: View{
    fileprivate var data = [0,1,2,3,4,5,6,7,9,10,-1,-2,-3,-4,-5,-6,-7,-9,-10]
    
    @State fileprivate var selection = 0
    
    @Binding var isClose : Bool
    
    
    var body: some View{
        VStack{
            Text("EPG Settings")
                .font(.carioBold)
                .foregroundColor(.black)
                .padding()
            Divider()
                .frame(height: 4)
                .overlay(Color.black)
            Spacer()
            VStack{
                Picker(selection: $selection, label: Text("\(selection)")) {
                    ForEach(data,id:\.self) {
                        item in
                        Text("\(item)").tag(item)
                    }
                }
            }
            
            Spacer()
            HStack{
                Button {
                    //Save
                    isClose.toggle()
                } label: {
                    Text("Save")
                        .font(.carioRegular)
                        .foregroundColor(.white)
                }.frame(width:100,height:50)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                    .padding()
                
                Button {
                    //Save
                    isClose.toggle()
                } label: {
                    Text("Cancel")
                        .font(.carioRegular)
                        .foregroundColor(.white)
                }.frame(width:100,height:50)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                    .padding()
            }
            
        }
        
        .frame(width: 300,height: UIScreen.main.bounds.height - 60)
        .background(Color.white)
        
    }
}

fileprivate struct AutomationView: View{
    var buttons = ["No","Yes"]
    
    @State var buttonSelected: Int = 0
    
    @Binding var isClose : Bool
    
    
    var body: some View{
        VStack{
            Text("Auto-Update Channels and Movies Daily")
                .font(.carioBold)
                .foregroundColor(.black)
                .padding()
            Divider()
                .frame(height: 4)
                .overlay(Color.black)
            Spacer()
            VStack{
                ForEach(0..<buttons.count,id:\.self) {
                    index in
                    
                    VStack{
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
                            
                        }.foregroundColor(.black)
                    }
                    
                }
                
                
                
                
                
            }
            
            Spacer()
            HStack{
                Button {
                    //Save
                    isClose.toggle()
                } label: {
                    Text("Save")
                        .font(.carioRegular)
                        .foregroundColor(.white)
                }.frame(width:100,height:50)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                    .padding()
                
                Button {
                    //Save
                    isClose.toggle()
                } label: {
                    Text("Cancel")
                        .font(.carioRegular)
                        .foregroundColor(.white)
                }.frame(width:100,height:50)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                    .padding()
            }
            
        }
        
        .frame(width: 300,height: UIScreen.main.bounds.height - 60)
        .background(Color.white)
        
    }
}


fileprivate struct LangaugeSelectView: View{
    var buttons = ["العربية","English"]
    
    @State var buttonSelected: Int = 0
    
    @Binding var isClose : Bool
    @AppStorage(AppStorageKeys.language.rawValue) var lang = ""
    
    var body: some View{
        VStack{
            Text("Auto-Update Channels and Movies Daily")
                .font(.carioBold)
                .foregroundColor(.black)
                .padding()
            Divider()
                .frame(height: 4)
                .overlay(Color.black)
            Spacer()
            VStack{
                ForEach(0..<buttons.count,id:\.self) {
                    index in
                    
                    VStack{
                        Button {
                            buttonSelected = index
                        } label: {
                            HStack{
                                Text(self.buttons[index])
                                    .padding()
                                
                                Image(systemName: buttonSelected == index ? "dot.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 30,height: 30)
                                    .scaledToFill()
                                
                                
                            }
                            
                        }.foregroundColor(.black)
                    }
                    .frame(width:250)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor(named:"SystemBG")!)))
                    
                }
                
                
                
                
                
            }
            
            Spacer()
            Button {
                //Save
                isClose.toggle()
                if buttonSelected == 0 {
                    lang = arbic
                }else{
                    lang = englishLang
                }
            } label: {
                Text("Submit")
                    .font(.carioRegular)
                    .foregroundColor(.white)
            }.frame(width:200,height:50)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                .padding()
            
        }
        
        .frame(width: 300,height: UIScreen.main.bounds.height - 60)
        .background(Color.white)
        .onAppear {
            if lang == arbic {
                buttonSelected = 0
            }else{
                buttonSelected = 1
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
        if #available(iOS 15.0,tvOS 15.0, *) {
            SettingsView(title: "ALL")
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
