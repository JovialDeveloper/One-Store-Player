//
//  UserAccountInfoView.swift
//  One Store Player
//
//  Created by MacBook Pro on 14/11/2022.
//

import SwiftUI

struct UserAccountInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            // Top Header View
            Color.primaryColor.ignoresSafeArea()
            VStack{
                HStack{
                    // Logo
                    if #available(iOS 13.0,tvOS 16.0, *) {
                        Image("Icon")
                            .resizable()
                            .frame(width:60,height: 60)
                            .scaledToFill()
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                    Spacer()
                    // Today Date
                    Text("Subscription Info")
                        .font(.carioBold)
                    
                    Spacer()
                    // Users Catalog
                    if #available(iOS 15.0,tvOS 15.0, *) {
                        Text(Date().formatted())
                    } else {
                        // Fallback on earlier versions
                    }
                    
                }
                .padding(.top,30)
                .padding(.horizontal)
                
                ScrollView{
                    Text("Subscription Info")
                        .font(.carioBold)
                        .padding()
                    VStack(spacing: 30){
                        SubscriptionCell(title: "Username:", description: "N/A")
                        SubscriptionCell(title: "Account status:", description: "N/A")
                        SubscriptionCell(title: "Expiry Date:", description: "N/A")
                        SubscriptionCell(title: "Is trial:", description: "N/A")
                        SubscriptionCell(title: "Active Connections:", description: "N/A")
                        SubscriptionCell(title: "Created At:", description: "N/A")
                        SubscriptionCell(title: "Max Connections:", description: "N/A")
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.secondary)
            }
            
        }
        .foregroundColor(.white)
    }
}

struct SubscriptionCell:View{
    var title:String
    var description:String
    var body: some View{
        ZStack{
            HStack(spacing: 20){
                Text(title)
                    .font(.carioBold)
                    .foregroundColor(.white)
                    //.frame(maxWidth: .infinity,alignment: .leading)
                
                Text(description)
                    .font(.carioRegular)
                    .foregroundColor(.white)
                    //.frame(maxWidth: .infinity,alignment: .leading)
                
                Spacer()
            }
        }
        //.frame(width: .infinity)
            
    }
}

struct UserAccountInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserAccountInfoView()
    }
}
