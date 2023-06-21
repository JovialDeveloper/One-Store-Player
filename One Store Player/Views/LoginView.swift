//
//  LoginView.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import SwiftUI
import ToastUI
struct LoginView: View {
    @State private var isSecure = false
    @StateObject fileprivate var loginViewModel = LoginViewModel()
    var isGoBackToMain = false
    var isUserUpdate = false
    var updateUser : UserInfo? = nil
    @EnvironmentObject var state : AppState
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            HStack{
                Spacer()
                VStack(spacing:20) {
                    Spacer()
                    Image("Icon")
                        .resizable()
                        .frame(width:140,height: 140)
                        .scaledToFill()
                    Spacer()
                }
                
                Spacer()
                
                VStack{
                    Text("Login Details")
                        .foregroundColor(.white)
                        .font(.carioBold)
                        .padding()
                    
                    
                    TextFieldView(text: $loginViewModel.name,placeHolder: "Any Name")
                    TextFieldView(text: $loginViewModel.userName,placeHolder: "User Name")
#if os(tvOS)
                    TextFieldView(text: $loginViewModel.password,placeHolder: "Password",isSecure: $isSecure)
#else
                    HStack{
                        Button {
                            isSecure.toggle()
                        } label: {
                            Image(isSecure ? "eye-off" : "eye")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.black)
                        }
                        .frame(width:46,height: 46)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))


                        
                        TextFieldView(text: $loginViewModel.password,placeHolder: "Password",isSecure: $isSecure)
                    }
#endif
                    
                    TextFieldView(text: $loginViewModel.port,placeHolder: "url")
                    
                    HStack{
                        Spacer().frame(width:30)
                        Button {
                            if isUserUpdate {
                                loginViewModel.isUserUpdate = true
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
                                        if isGoBackToMain {
                                            presentationMode.wrappedValue.dismiss()
                                            NotificationCenter.default.post(name: .addNewUser, object: self)
                                        }
                                        debugPrint(data)
                                    }.store(in: &loginViewModel.subscriptions)
                            }
                            else{
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
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                            NotificationCenter.default.post(name: .selectLayout, object: nil)
                                        }
                                        
                                        
                                        if isGoBackToMain {
                                            presentationMode.wrappedValue.dismiss()
                                            NotificationCenter.default.post(name: .addNewUser, object: self)
                                            
                                            
                                        }
                                        debugPrint(data)
                                    }.store(in: &loginViewModel.subscriptions)
                            }
                           
                            
                        } label: {
                            if loginViewModel.isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle())
                                    .frame(maxWidth:.infinity)
                            }else{
                                Text(isUserUpdate ? "Update User":"ADD NEW USER")
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
            .onAppear(perform: {
                
                if isUserUpdate, updateUser != nil {
                    loginViewModel.selectUser = updateUser
                    loginViewModel.name = updateUser!.name
                    loginViewModel.userName = updateUser!.username
                    loginViewModel.password = updateUser!.password
                    loginViewModel.port = updateUser!.port
                }
            })
            .foregroundColor(.black)
            .toast(isPresented: $loginViewModel.isError.0) {
                
                ToastView(loginViewModel.isError.1)
                    .toastViewStyle(.failure)
                    .onTapGesture {
                        loginViewModel.isError.0 = false
                    }
            }
            
            
        }
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
