//
//  LoginView.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import SwiftUI
import AlertToast
struct LoginView: View {
    @State private var isSecure = false
    @StateObject fileprivate var loginViewModel = LoginViewModel()
    var isGoBackToMain = true
    @EnvironmentObject var state : AppState
    var body: some View {
        ZStack{
            LinearGradient.bgGradient.ignoresSafeArea()
            HStack{
                VStack(spacing:20) {
                    Spacer()
                    Image("Icon")
                        .resizable()
                        .frame(width:140,height: 140)
                        .scaledToFill()
                    
                    Spacer()
//                        Text("To order contact use whatsapp +971551761973")
                }
                
                Spacer()
                
                VStack{
                    Text("Login Details")
                        .font(.carioBold)
                    
                    
                    TextFieldView(text: $loginViewModel.name,placeHolder: "Any Name")
                    TextFieldView(text: $loginViewModel.userName,placeHolder: "User Name")
                    HStack{
                        ButtonView(action: {
                            isSecure.toggle()
                        },image: isSecure ? "eye-off" : "eye")
                        .frame(width:46,height: 46)
                        
                        
                        TextFieldView(text: $loginViewModel.password,placeHolder: "Password",isSecure: $isSecure)
                    }
                    
                    TextFieldView(text: $loginViewModel.port,placeHolder: "url")
                    
                    HStack{
                        Spacer().frame(width:30)
                        Button {
                            loginViewModel.login()
                            
                                .sink { error in
                                    
                                    switch error {
                                    case .failure(let error):
                                        loginViewModel.isLoading = false
                                        
                                        loginViewModel.isError = (true,error.localizedDescription)
                                    case .finished:
                                        break
                                    }
                                    
                                } receiveValue: { data in
                                    state.isLogin = true
                                    debugPrint(data)
                                }.store(in: &loginViewModel.subscriptions)
                            
                        } label: {
                            if loginViewModel.isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle())
                                    .frame(maxWidth:.infinity)
                            }else{
                                Text("ADD NEW USER")
                                    .font(.carioRegular)
                                    .frame(maxWidth:.infinity)
                            }
                            
                        }
                        .frame(height: 46)
                        .background(Rectangle().fill(Color.white))
                        Spacer().frame(width:30)
                    }
                    
                    
                }
                .frame(width:UIScreen.main.bounds.width/2.2)
                .padding()
                
                //Spacer()
            }
            .foregroundColor(.black)
            .toast(isPresenting: $loginViewModel.isError.0, alert: {
                AlertToast(type: .regular, title:loginViewModel.isError.1)
            })
            
            
//            if loginViewModel.isLogin {
//                MainHomeView()
//            }
//            else {
//                HStack{
//                    VStack(spacing:20) {
//                        Spacer()
//                        Image("Icon")
//                            .resizable()
//                            .frame(width:140,height: 140)
//                            .scaledToFill()
//
//                        Spacer()
////                        Text("To order contact use whatsapp +971551761973")
//                    }
//
//                    Spacer()
//
//                    VStack{
//                        Text("Login Details")
//                            .font(.carioBold)
//
//
//                        TextFieldView(text: $loginViewModel.name,placeHolder: "Any Name")
//                        TextFieldView(text: $loginViewModel.userName,placeHolder: "User Name")
//                        HStack{
//                            ButtonView(action: {
//                                isSecure.toggle()
//                            },image: isSecure ? "eye-off" : "eye")
//                            .frame(width:46,height: 46)
//
//
//                            TextFieldView(text: $loginViewModel.password,placeHolder: "Password",isSecure: $isSecure)
//                        }
//
//                        TextFieldView(text: $loginViewModel.port,placeHolder: "url")
//
//                        HStack{
//                            Spacer().frame(width:30)
//                            Button {
//                                loginViewModel.login()
//
//                                    .sink { error in
//
//                                        switch error {
//                                        case .failure(let error):
//                                            loginViewModel.isLoading = false
//
//                                            loginViewModel.isError = (true,error.localizedDescription)
//                                        case .finished:
//                                            break
//                                        }
//
//                                    } receiveValue: { data in
//                                        debugPrint(data)
//                                    }.store(in: &loginViewModel.subscriptions)
//
//                            } label: {
//                                if loginViewModel.isLoading {
//                                    ProgressView().progressViewStyle(CircularProgressViewStyle())
//                                        .frame(maxWidth:.infinity)
//                                }else{
//                                    Text("ADD NEW USER")
//                                        .font(.carioRegular)
//                                        .frame(maxWidth:.infinity)
//                                }
//
//                            }
//                            .frame(height: 46)
//                            .background(Rectangle().fill(Color.white))
//                            Spacer().frame(width:30)
//                        }
//
//
//                    }
//                    .frame(width:UIScreen.main.bounds.width/2.2)
//                    .padding()
//
//                    //Spacer()
//                }
//                .foregroundColor(.black)
//                .toast(isPresenting: $loginViewModel.isError.0, alert: {
//                    AlertToast(type: .regular, title:loginViewModel.isError.1)
//                })
//            }
            
        }
        
        //        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        //            .font(.carioBold)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            if #available(tvOS 15.0, *) {
                LoginView()
                    .previewInterfaceOrientation(.landscapeLeft)
            } else {
                // Fallback on earlier versions
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
