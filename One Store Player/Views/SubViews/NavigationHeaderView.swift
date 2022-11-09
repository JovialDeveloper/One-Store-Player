//
//  NavigationHeaderView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI

struct NavigationHeaderView: View {
    var title:String
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        HStack{
            // Logo
            Image("arrow_back")
                .resizable()
                .frame(width:40,height: 40)
                .scaledToFill()
                .foregroundColor(.white)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            
            Text(title)
                .font(.carioBold)
                .foregroundColor(.white)
            
            Spacer()
            // Users Catalog
            HStack{
                Button {
                    //
                } label: {
                    Image("search")
                        .resizable()
                        .frame(width:30,height: 30)
                        .scaledToFill()
                        .foregroundColor(.white)
                }
                .frame(width:40,height: 40)
                
                // Users Button
                Button {
                    //
                } label: {
                    Image("more")
                        .resizable()
                        .frame(width:30,height: 30)
                        .scaledToFill()
                        .foregroundColor(.white)
                }
                .frame(width:40,height: 40)
            }
            
        }
        .padding(.top,30)
        .padding(.horizontal)
    }
}

struct NavigationHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationHeaderView(title: "")
    }
}
