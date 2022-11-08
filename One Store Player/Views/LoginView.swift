//
//  LoginView.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import SwiftUI

struct LoginView: View {
    @State private var anyName = ""
    @State private var userName = ""
    @State private var password = ""
    @State private var port = ""
    @State private var isSecure = false
    var body: some View {
        ZStack{
            Color.gray.opacity(0.5).ignoresSafeArea()
            HStack{
                VStack(spacing:20) {
                    Image("Icon")
                        .resizable()
                        .frame(width:140,height: 140)
                    .scaledToFill()
                    
                    Text("To order contact use whatsapp +971551761973")
                }
                
                Spacer()
                
                VStack{
                    Text("Login Details")
                        .font(.carioBold)
                        
                    TextFieldView(text: $anyName,placeHolder: "Any Name")
                    TextFieldView(text: $userName,placeHolder: "User Name")
                    HStack{
                        ButtonView(action: {
                            isSecure.toggle()
                        },image: isSecure ? "eye-off" : "eye")
                        .frame(width:46,height: 46)
                        
                        TextFieldView(text: $password,placeHolder: "Password",isSecure: $isSecure)
                    }
                    
                    TextFieldView(text: $port,placeHolder: "url")
                    ButtonView(buttonTitle:"ADD NEW USER") {
                        //
                    }
                    
                    
                }
                .frame(width:UIScreen.main.bounds.width/2.2)
                .padding()
                
                //Spacer()
            }
        }
        
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .font(.carioBold)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            LoginView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
