//
//  MainHomeView.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import SwiftUI

struct MainHomeView: View {
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack{
                // Top Header View
                HStack{
                    // Logo
                    Image("Icon")
                        .resizable()
                        .frame(width:40,height: 40)
                        .scaledToFill()
                    Spacer()
                    // Today Date
                    if #available(iOS 15.0, *) {
                        Text("\(Date().formatted())")
                            .font(.carioRegular)
                    } else {
                        Text(Date().description)
                            .font(.carioRegular)
                    }
                    
                    Spacer()
                    // Users Catalog
                    HStack{
                        Button {
                            //
                        } label: {
                            Image("user_account_info")
                                .resizable()
                                .frame(width:20,height: 20)
                                .scaledToFill()
                        }
                        .frame(width:20,height: 20)
                        
                        // Users Button
                        Button {
                            //
                        } label: {
                            Image("ic_users")
                                .resizable()
                                .frame(width:20,height: 20)
                                .scaledToFill()
                        }
                        .frame(width:20,height: 20)
                        //Settings Button
                        Button {
                            //
                        } label: {
                            Image("ic_settings")
                                .resizable()
                                .frame(width:20,height: 20)
                                .scaledToFill()
                        }
                        .frame(width:20,height: 20)
                        
                            
                    }
                    
                }
                .padding(.top,30)
                .padding(.horizontal)
                //.frame(height: 50)
                // Mid View for Watchings
                VStack(spacing:20){
                    HStack{
                        
                        //Live TV
                        Button {
                            // Live TV
                        } label: {
                            Image("livetv")
                                .resizable()
//                                .frame(maxWidth:.infinity,maxHeight: .infinity)
                                .scaledToFit()
                                .cornerRadius(20)
                        }
                        .background(RoundedRectangle(cornerRadius: 20))
                        
                        // Movies
                        Button {
                            // movies
                        } label: {
                            Image("movies")
                                .resizable()
//                                .frame(maxWidth:.infinity,maxHeight: .infinity)
                                .scaledToFit()
                                .cornerRadius(20)
                        }
                        .background(RoundedRectangle(cornerRadius: 20))
                        
                        // Series
                        Button {
                            // Series
                        } label: {
                            Image("series")
                                .resizable()
//                                .frame(maxWidth:.infinity,maxHeight: .infinity)
                                .scaledToFit()
                                .cornerRadius(20)
                        }
                        .background(RoundedRectangle(cornerRadius: 20))
                        
                        // Fixtures
                        Button {
                            // Fixtures
                        } label: {
                            Image("fixtures")
                                .resizable()
//                                .frame(maxWidth:.infinity,maxHeight: .infinity)
                                .scaledToFit()
                                .cornerRadius(20)
                        }
                        .background(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            // Live TV
                        } label: {
                            Image("Livewith")
                                .resizable()
                                .frame(width:200,height: 40)
                                .scaledToFill()
                        }
                        
                        Button {
                            // Live TV
                        } label: {
                            Image("catchup")
                                .resizable()
                                .frame(width:200,height: 40)
                                .scaledToFill()
                        }
                        
                        Spacer()
                    }
                    
                }
                .padding()
                
                HStack{
                    Text("Expiration \(Text("\(Date().description)").font(.carioBold))")
                        .font(.carioRegular)
                    Spacer()
                    Text("Login In: \(Text("Ali").font(.carioBold))")
                        .font(.carioRegular)
                }.padding()
                
                
                
            }
            .foregroundColor(.white)
            
            .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
        }
    }
}

struct MainHomeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            MainHomeView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
