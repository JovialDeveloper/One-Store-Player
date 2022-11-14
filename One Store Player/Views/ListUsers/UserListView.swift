//
//  UserListView.swift
//  One Store Player
//
//  Created by MacBook Pro on 14/11/2022.
//

import SwiftUI

struct UserListView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            // Top Header View
            Color.primaryColor.ignoresSafeArea()
            VStack{
                HStack{
                    // Logo
                    Image("Icon")
                        .resizable()
                        .frame(width:60,height: 60)
                        .scaledToFill()
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
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
                           //
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
                    
                    
                    ForEach(0..<1) {
                        item in
                        HStack{
                            Image("user_avatar")
                                .resizable()
                                .frame(width:60,height: 60)
                                .scaledToFill()
                                .foregroundColor(.blue)
                            Spacer()
                            VStack{
                                Text("Ali")
                                    .font(.carioBold)
                                    .foregroundColor(.black)
                                Text("url:exmaple.com")
                                    .font(.carioRegular)
                                    .foregroundColor(.black)
                                
                                Text("username: test09")
                                    .font(.carioRegular)
                                    .foregroundColor(.black)
                            }.frame(maxWidth: .infinity,alignment: .leading)
                            Spacer()
                            HStack{
                                Image("icon_delete")
                                    .resizable()
                                    .frame(width:40,height: 40)
                                    .scaledToFill()
                                    .foregroundColor(.red)
                                
                                Image("ic_edit_user")
                                    .resizable()
                                    .frame(width:40,height: 40)
                                    .scaledToFill()
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Rectangle().fill(Color.white))
                    }
                }
            }
            
        }
        .foregroundColor(.white)
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
