//
//  SettingsView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI
import ToastUI
enum SettingsKeys:String,CaseIterable{
    case layout
    case EPGTime
    case lang
    case parentalcontrol
    case streamFormat
    case time
    case automation1
}

struct SettingsButtonData:Identifiable{
    var id = UUID().uuidString
    let title:String
    let imageName:String
    
    static func getAllData()-> [SettingsButtonData] {
        return [
            .init(title: "Views Format", imageName: "layout"),
            .init(title: "EPG Time Shift", imageName: "EPGTime"),
            .init(title: "Language", imageName: "lang"),
            .init(title: "Parental Control", imageName: "parentalcontrol"),
            .init(title: "Stream Format", imageName: "streamFormat"),
            .init(title: "Time Format", imageName: "time"),
            .init(title: "Automation", imageName: "automation1"),
        ]
    }
}
struct SettingsView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    //let data = ["layout","EPGTime","lang","parentalcontrol","stream format","time","automation1"]
    fileprivate let data = SettingsButtonData.getAllData()
    
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let title:String
    @AppStorage(AppStorageKeys.language.rawValue) var lang = SupportedLanguages.englishLang.rawValue
    @State private var isLayoutGuideOn = false
    @State private var isTimeFormatButtonOn = false
    @State private var isLanguageButtonOn = false
    @State private var isParentalControlButtonOn = false
    @State private var isEPGButtonOn = false
    @State private var isAutomationOn = false
    @State private var isStreamOn = false
    @State private var selectButtonType : SettingsKeys?
    
    @State private var alertTitle = "Please enter your username and password."
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title:title,isHideOptions: true,isHideReload: true)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(data, id: \.id) { item in
#if os(tvOS)
                            
                            ButtonView(buttonData: item, action: {
                                if item.imageName == SettingsKeys.layout.rawValue {
                                    isLayoutGuideOn.toggle()
                                }
                                if item.imageName == SettingsKeys.time.rawValue {
                                    isTimeFormatButtonOn.toggle()
                                }
                                if item.imageName == SettingsKeys.EPGTime.rawValue{
                                    isEPGButtonOn.toggle()
                                }
                                if item.imageName == SettingsKeys.lang.rawValue{
                                    isLanguageButtonOn.toggle()
                                }
                                if item.imageName == SettingsKeys.automation1.rawValue
                                {
                                    isAutomationOn.toggle()
                                }
                                if item.imageName == SettingsKeys.streamFormat.rawValue{
                                    isStreamOn.toggle()
                                }
                                if item.imageName == SettingsKeys.parentalcontrol.rawValue {
                                    isParentalControlButtonOn.toggle()
                                }
                                
                            })
                            .frame(minWidth:200,minHeight: 180)
                            .cornerRadius(10)
                            
#else
                            ButtonView(buttonData: item, action: {
                                if item.imageName == SettingsKeys.layout.rawValue {
                                    isLayoutGuideOn.toggle()
                                }
                                if item.imageName == SettingsKeys.time.rawValue {
                                    isTimeFormatButtonOn.toggle()
                                }
                                if item.imageName == SettingsKeys.EPGTime.rawValue{
                                    isEPGButtonOn.toggle()
                                }
                                if item.imageName == SettingsKeys.lang.rawValue{
                                    isLanguageButtonOn.toggle()
                                }
                                if item.imageName == SettingsKeys.automation1.rawValue
                                {
                                    isAutomationOn.toggle()
                                }
                                if item.imageName == SettingsKeys.streamFormat.rawValue{
                                    isStreamOn.toggle()
                                }
                                if item.imageName == SettingsKeys.parentalcontrol.rawValue {
                                    isParentalControlButtonOn.toggle()
                                }
                                
                            })
                            //.frame(minWidth:200,minHeight: 180)
                            .frame(maxWidth:180,maxHeight: 140)
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
            if isStreamOn {
                StreamFormat(isClose: $isStreamOn)
            }
            if isParentalControlButtonOn {
                AlertPCView(show: $isParentalControlButtonOn, title: "Paternal Control", message: alertTitle)
            }
            
            
        }
    }
    
    
    
}

struct AlertPCView:View{
    @Binding var show:Bool
    
    var title : String
    var message:String
    var isCheckPasswordScreen = false
    var checkDidAuthicate : ((Bool)->Void)? = nil
    
    
    @State private var paternalControlUserName = ""
    @State private var paternalControlPassword = ""
    var body: some View{
        VStack(spacing:10){
            Text(title)
            
                .font(.carioBold)
            Text(message)
                .font(.carioRegular)
            
            TextField("Username:", text: $paternalControlUserName)
            Divider()
            TextField("Password", text: $paternalControlPassword)
            Divider()
            
            HStack(spacing:40){
                
                Button(action: {
                    show.toggle()
                }) {
                    Text("Cancel")
                        .font(.carioRegular)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    if isCheckPasswordScreen {
                        // Check Password
                        getPasswordFromDefaults()
                    }else {
                        savePasswordInUserDefaults()
                    }
                }) {
                    Text("Ok")
                        .font(.carioRegular)
                }
            }
            
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height - 60)
        .background(Color.white)
    }
    
    func getPasswordFromDefaults(){
        
        if let decodeData = UserDefaults.standard.value(forKey: AppStorageKeys.paternalControl.rawValue) as? Data {
            do {
                let decodeModel = try JSONDecoder().decode(UserPaternalControl.self, from: decodeData)
                if decodeModel.userName == paternalControlUserName && decodeModel.password == paternalControlPassword {
                    // Correct Details
                    checkDidAuthicate?(true)
                }else {
                    // Wrong Details
                    checkDidAuthicate?(false)
                }
            }
            catch {
                debugPrint(error)
            }
            
        }
    }
    
    func savePasswordInUserDefaults(){
        if !paternalControlUserName.isEmpty && !paternalControlPassword.isEmpty
        {
            let paternalModel = UserPaternalControl(userName: paternalControlUserName, password: paternalControlPassword)
            let encoder = JSONEncoder()
            do {
                let encodeData = try encoder.encode(paternalModel)
                UserDefaults.standard.set(encodeData, forKey: AppStorageKeys.paternalControl.rawValue)
                show.toggle()
            }
            catch {
                debugPrint("Encoder Error",error)
            }
        }
        
        
    }
}

fileprivate struct LayoutDialoguView: View{
    var buttons = ["Modern","Classic"]
    
    @State var buttonSelected: Int = 0
    
    @Binding var isClose : Bool
    @AppStorage(AppStorageKeys.layout.rawValue) private var layout: AppKeys.RawValue =  AppKeys.classic.rawValue
    @AppStorage(AppStorageKeys.language.rawValue) var lang = SupportedLanguages.englishLang.rawValue
    var body: some View{
        VStack{
            Text("Views Format".localized(lang))
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
                Text("save".localized(lang))
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
    @AppStorage(AppStorageKeys.language.rawValue) var lang = SupportedLanguages.englishLang.rawValue
    var body: some View{
        VStack{
            Text("Time Format".localized(lang))
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
                    Text("save".localized(lang))
                        .font(.carioRegular)
                        .foregroundColor(.white)
                }.frame(width:100,height:50)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                    .padding()
                
                Button {
                    //Save
                    isClose.toggle()
                } label: {
                    Text("cancel".localized(lang))
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
    @AppStorage(AppStorageKeys.egp.rawValue) var epg = 0
    fileprivate var data = [0,1,2,3,4,5,6,7,9,10,-1,-2,-3,-4,-5,-6,-7,-9,-10]
    
    @State fileprivate var selection = 0
    
    @Binding var isClose : Bool
    @AppStorage(AppStorageKeys.language.rawValue) var lang = SupportedLanguages.englishLang.rawValue
    
    var body: some View{
        VStack{
            Text("EPG Settings".localized(lang))
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
                    Text("save".localized(lang))
                        .font(.carioRegular)
                        .foregroundColor(.white)
                }.frame(width:100,height:50)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                    .padding()
                
                Button {
                    //Save
                    epg = selection
                    isClose.toggle()
                } label: {
                    Text("cl".localized(lang))
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
            selection = epg
        }
        
    }
}

fileprivate struct AutomationView: View{
    var buttons = ["No","Yes"]
    @AppStorage(AppStorageKeys.automate.rawValue) var udpate = ""
    @State var buttonSelected: Int = 0
    @AppStorage(AppStorageKeys.language.rawValue) var lang = SupportedLanguages.englishLang.rawValue
    @Binding var isClose : Bool
    
    
    var body: some View{
        VStack{
            Text("ad".localized(lang))
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
                    Text("save".localized(lang))
                        .font(.carioRegular)
                        .foregroundColor(.white)
                }.frame(width:100,height:50)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                    .padding()
                
                Button {
                    //Save
                    udpate = buttons[buttonSelected]
                    isClose.toggle()
                } label: {
                    Text("cl".localized(lang))
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
            if udpate == "No" {
                buttonSelected = 0
            }else {
                buttonSelected = 1
            }
        }
        
    }
}


fileprivate struct LangaugeSelectView: View{
    var buttons = ["العربية","English"]
    
    @State var buttonSelected: Int = 0
    
    @Binding var isClose : Bool
    @AppStorage(AppStorageKeys.language.rawValue) var lang = SupportedLanguages.englishLang.rawValue
    
    var body: some View{
        VStack{
            Text("Select Language".localized(lang))
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
                    lang = SupportedLanguages.arbic.rawValue
                }else{
                    lang = SupportedLanguages.englishLang.rawValue
                }
                
            } label: {
                Text("Submit".localized(lang))
                    .font(.carioRegular)
                    .foregroundColor(.white)
            }.frame(width:200,height:50)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
                .padding()
            
        }
        
        .frame(width: 300,height: UIScreen.main.bounds.height - 60)
        .background(Color.white)
        .onAppear {
            if lang == SupportedLanguages.arbic.rawValue {
                buttonSelected = 0
            }else{
                buttonSelected = 1
            }
        }
        
    }
}

fileprivate struct StreamFormat: View{
    var buttons = ["Defualt","ts","m3u8"]
    
    @State var buttonSelected: Int = 0
    
    @Binding var isClose : Bool
    @AppStorage(AppStorageKeys.videoFormat.rawValue) var streamFormatte = ""
    @AppStorage(AppStorageKeys.language.rawValue) var lang = SupportedLanguages.englishLang.rawValue
    var body: some View{
        VStack{
            Text("Stream Format".localized(lang))
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
                    .frame(width:250)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor(named:"SystemBG")!)))
                    
                }
                
                
                
                
                
            }
            Button {
                //Save
                isClose.toggle()
                
                if buttonSelected == 0  {
                    streamFormatte = "ts"
                }else if buttonSelected == 1{
                    streamFormatte = "ts"
                }else{
                    streamFormatte = "m3u8"
                }
                
            } label: {
                Text("save".localized(lang))
                    .font(.carioRegular)
                    .foregroundColor(.white)
            }
            .frame(width:200,height:36)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemBlue)))
            
        }
        
        .frame(width: 300,height: UIScreen.main.bounds.height - 60)
        .background(Color.white)
        .onAppear {
            if streamFormatte == "ts" {
                buttonSelected = 1
            }else if streamFormatte == "m3u8"{
                buttonSelected = 2
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


struct AlertControl: UIViewControllerRepresentable {
    @AppStorage(AppStorageKeys.language.rawValue) var lang = SupportedLanguages.englishLang.rawValue
    typealias UIViewControllerType = UIAlertController
    
    //    @Binding var textString: String
    @Binding var show: Bool
    var ok: (()->Void)?
    
    var title: String
    var message: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControl>) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Username:"
        }
        alert.addTextField { textField in
            textField.placeholder = "Password"
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive) { (action) in
            self.show = false
        }
        
        let submitAction = UIAlertAction(title: "ok", style: .default) { (action) in
            ok?()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        return alert
    }
    
    func updateUIViewController(_ uiViewController: UIAlertController, context: UIViewControllerRepresentableContext<AlertControl>) {
        
    }
}
