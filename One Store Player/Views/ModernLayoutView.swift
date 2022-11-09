//
//  ModernLayoutView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import Foundation
import SwiftUI

struct ModernLayoutView:View{
    @Environment(\.presentationMode) var presentationMode
    var title : String
    var body: some View {
        ZStack{
            HStack{
                VStack{
                    List(0..<8){_ in
                        Text("Movie Name")
                            .font(.carioRegular)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .listRowBackground(Color.secondaryColor)
                    }
                    .listStyle(PlainListStyle())
                    
                    //.padd
                        
                }
                .frame(width:UIScreen.main.bounds.width/3.5,height: UIScreen.main.bounds.height)
                .background(Color.gray)
                
                Spacer()
                
                VStack{
                    NavigationHeaderView(title: title)
                    
                    CollectionGridView()
                }
                
               
                
                // Moviews List
                
                
            }
            .frame(maxWidth:.infinity,maxHeight: .infinity)
        }
    }
}


