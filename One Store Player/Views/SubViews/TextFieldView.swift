//
//  TextFieldView.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import SwiftUI
struct TextFieldView:View{
    @Binding var text : String
    var placeHolder = ""
    @Binding var isSecureTextField : Bool
    init(text:Binding<String>,placeHolder:String,isSecure: Binding<Bool> = .constant(false)) {
        _text = text
        _isSecureTextField = isSecure
        self.placeHolder = placeHolder
    }
    var body: some View{
        if isSecureTextField{
            SecureField(placeHolder, text: $text)
                .frame(height: 46)
                .padding([.leading],10)
                .modifier(TextFieldModifier())
        }else{
            TextField(placeHolder, text: $text)
                .frame(height: 46)
                .padding([.leading],10)
                .modifier(TextFieldModifier())
        }
        
    }
}
