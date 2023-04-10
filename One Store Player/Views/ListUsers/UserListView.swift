//
//  UserListView.swift
//  One Store Player
//
//  Created by MacBook Pro on 14/11/2022.
//

import SwiftUI

struct UserListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var users = [UserInfo]()
    @State private var selectUser : UserInfo?
    @State private var showAddNewUser = false
    @State private var showUpdateUser = false
    @EnvironmentObject private var state : AppState
    fileprivate func fetchUsersList() {
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.userInfo.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                let userinfo = try decoder.decode([UserInfo].self, from: data)
                self.users = userinfo
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }else {
            print("Error")
        }
    }
    
    var body: some View {
        ZStack{
            // Top Header View
            Color.primaryColor.ignoresSafeArea()
            VStack{
                HStack{
                    // Logo
                    if #available(iOS 13.0,tvOS 16.0, *) {
                        Image("arrow_back")
                            .resizable()
                            .frame(width:24,height: 24)
                            .scaledToFit()
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                    Spacer()
                    // Today Date
                    Text("List of Users")
                        .font(.carioBold)
                    
                    Spacer()
                    // Users Catalog
                    HStack{
                        
                        //Add New User
                        Button {
                            showAddNewUser.toggle()
                        } label: {
                            Image("icon_plus")
                                .resizable()
                                .frame(width:30,height: 30)
                                .scaledToFill()
                        }
                        .frame(width:30,height: 30)
                        
                            
                    }
                    
                }
                .padding(.top,30)
                .padding(.horizontal)
                
                ScrollView{
                    
                    
                    ForEach(users) {
                        item in
                        
                        HStack{
                            Image("user_avatar")
                                .resizable()
                                .frame(width:60,height: 60)
                                .scaledToFill()
                                .foregroundColor(.blue)
                            Spacer()
                            VStack(alignment: .leading, spacing:10){
                                Text(item.name)
                                    .font(.carioBold)
                                    .foregroundColor(.black)
                                Text("url:\(item.port)")
                                    .font(.carioRegular)
                                    .foregroundColor(.black)
                                
                                Text("username: \(item.username)")
                                    .font(.carioRegular)
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .onTapGesture {
                                UserDefaults.standard.removeObject(forKey: AppStorageKeys.currentUser.rawValue)
                                let currentModel = try? JSONEncoder().encode(item)
                                UserDefaults.standard.set(currentModel, forKey: AppStorageKeys.currentUser.rawValue)
                                NotificationCenter.default.post(name: .userSelect, object: self)
                                presentationMode.wrappedValue.dismiss()
                            }
                            Spacer()
                            HStack{
                                Button {
                                    selectUser = nil
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                        selectUser = item
                                    }
                                    
                                    
                                    
                                } label: {
                                    Image("ic_edit_user")
                                        .resizable()
                                        .frame(width:40,height: 40)
                                        .scaledToFill()
                                        .foregroundColor(.black)
                                }
                                
                                Button {

                                    users.removeAll(where: {$0.id == item.id})
                                
                                    if users.isEmpty {
                                        UserDefaults.standard.removeObject(forKey: AppStorageKeys.currentUser.rawValue)
                                        UserDefaults.standard.removeObject(forKey: AppStorageKeys.userInfo.rawValue)
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {

                                            self.state.isLogin = false
                                        }
                                    }
                                    else {
                                        do {
                                            let modelData = try JSONEncoder().encode(users)

                                            UserDefaults.standard.set(modelData, forKey: AppStorageKeys.userInfo.rawValue)
                                        }catch {
                                            debugPrint(error.localizedDescription)
                                        }
                                        
                                    }
                                    
                                    
                                } label: {
                                    Image("icon_delete")
                                        .resizable()
                                        .frame(width:40,height: 40)
                                        .scaledToFill()
                                        .foregroundColor(.red)
                                }
                                
                               

                                
                                
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Rectangle().fill(Color.white))
                        .onChange(of: selectUser) { newValue in
                            if newValue != nil {
                                showUpdateUser = true
                            }
                            
                        }
//                        if #available(tvOS 16.0, *) {
//                            HStack{
//                                Image("user_avatar")
//                                    .resizable()
//                                    .frame(width:60,height: 60)
//                                    .scaledToFill()
//                                    .foregroundColor(.blue)
//                                Spacer()
//                                VStack{
//                                    Text(item.name)
//                                        .font(.carioBold)
//                                        .foregroundColor(.black)
//                                    Text("url:\(item.port)")
//                                        .font(.carioRegular)
//                                        .foregroundColor(.black)
//
//                                    Text("username: \(item.username)")
//                                        .font(.carioRegular)
//                                        .foregroundColor(.black)
//                                }.frame(maxWidth: .infinity,alignment: .leading)
//                                Spacer()
//                                HStack{
//                                    Image("icon_delete")
//                                        .resizable()
//                                        .frame(width:40,height: 40)
//                                        .scaledToFill()
//                                        .foregroundColor(.red)
//                                        .onTapGesture {
//
//                                            UserDefaults.standard.removeObject(forKey: AppStorageKeys.userInfo.rawValue)
//
//                                            fetchUsersList()
//
//                                            if users.count == 1 {
//                                                UserDefaults.standard.removeObject(forKey: AppStorageKeys.currentUser.rawValue)
//
//                                                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//                                                    state.isLogin = false
//                                                }
//                                            }
//
//
//                                        }
//
//                                    Image("ic_edit_user")
//                                        .resizable()
//                                        .frame(width:40,height: 40)
//                                        .scaledToFill()
//                                        .foregroundColor(.black)
//                                }
//                            }
//                            .frame(maxWidth: .infinity)
//                            .background(Rectangle().fill(Color.white))
//                            .onTapGesture {
//                                UserDefaults.standard.removeObject(forKey: AppStorageKeys.currentUser.rawValue)
//                                let currentModel = try? JSONEncoder().encode(item)
//                                UserDefaults.standard.set(currentModel, forKey: AppStorageKeys.currentUser.rawValue)
//                            }
//                        } else {
//                            // Fallback on earlier versions
//                        }
                    }
                }
            }
            
        }
        .foregroundColor(.white)
        .onAppear {
            fetchUsersList()
        }
        .onReceive(NotificationCenter.Publisher(center: .default, name: .addNewUser), perform: { _ in
            fetchUsersList()
        })
        .fullScreenCover(isPresented: $showAddNewUser) {
            LoginView(isGoBackToMain: true)
        }
        .fullScreenCover(isPresented: $showUpdateUser) {
            if selectUser != nil {
                LoginView(isGoBackToMain: true,isUserUpdate: true,updateUser: selectUser)
            }
            
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
