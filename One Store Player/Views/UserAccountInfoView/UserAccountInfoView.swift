//
//  UserAccountInfoView.swift
//  One Store Player
//
//  Created by MacBook Pro on 14/11/2022.
//

import SwiftUI

struct UserAccountInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(AppStorageKeys.timeFormatt.rawValue) var formatte = ""
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
                    Text(Date().getTime(format: "MM/dd/yyyy \(formatte)"))
                    
                }
                .padding(.top,30)
                .padding(.horizontal)
                
                ScrollView{
                    Text("Subscription Info")
                        .font(.carioBold)
                        .padding()
                    VStack(spacing: 30){
                        SubscriptionCell(title: "Username:", description: Networking.shared.getUserDetails()?.username ?? "")
                        SubscriptionCell(title: "Account status:", description: Networking.shared.getUserDetails()?.status ?? "")
                        SubscriptionCell(title: "Expiry Date:", description: Networking.shared.getUserDetails()?.createdAt ?? "")
                        SubscriptionCell(title: "Is trial:", description: Networking.shared.getUserDetails()?.isTrial ?? "")
                        SubscriptionCell(title: "Active Connections:", description: Networking.shared.getUserDetails()?.activeCons ?? "")
                        SubscriptionCell(title: "Created At:", description: Networking.shared.getUserDetails()?.createdAt ?? "")
                        SubscriptionCell(title: "Max Connections:", description: Networking.shared.getUserDetails()?.maxConnections ?? "")
                    }
                    .padding()
                    
                }
                .padding(.horizontal,100)
                .frame(maxWidth: .infinity)
                .background(Color.secondColor)
            }
            
        }
        .foregroundColor(.white)
    }
}

struct SubscriptionCell:View{
    var title:String
    var description:String
    @AppStorage(AppStorageKeys.language.rawValue) var lang = ""
    var body: some View{
        ZStack{
            HStack(spacing: 20){
                Text(title.localized(lang))
                    .font(.carioBold)
                    .foregroundColor(.white)
                    //.frame(maxWidth: .infinity,alignment: .leading)
                
                Text(description.localized(lang))
                    .font(.carioRegular)
                    .foregroundColor(.white)
                    .lineLimit(2)
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
