//
//  ButtonView.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import SwiftUI

struct ButtonView: View {
    
    var buttonData:SettingsButtonData
    var action : (()->Void)
    var body: some View {
        Button {
            action()
        } label: {
            VStack{
                Image(buttonData.imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    
                Text(buttonData.title)
                    .font(.carioRegular)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,maxHeight: 46)
            }
            
//            if image.isEmpty{
//                Text(buttonTitle)
//                    .font(.carioRegular)
//                    .foregroundColor(.black)
//                    .frame(maxWidth: .infinity,maxHeight: 46)
//            }else{
//                Image(image)
//                    .resizable()
//                    .frame(maxWidth: .infinity)
//            }
            
        }
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))

    }
}

//struct ButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonView()
//    }
//}
