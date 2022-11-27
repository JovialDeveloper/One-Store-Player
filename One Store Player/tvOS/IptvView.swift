//
//  IptvView.swift
//  One Store Player
//
//  Created by MacBook Pro on 26/11/2022.
//

import SwiftUI

struct IptvView: View {
    @State var data = ["TV1","TV2","TV3","TV4"]
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    var width : CGFloat = 300
    var height : CGFloat = 380
    var body: some View {
        NavigationView{
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(data, id: \.self) { item in
                        Button {
                            //
                        } label: {
                            iptvCell
                                .frame(width: width,height: height)
                                
                        }.frame(width: width,height: height)
                    }
                }
            }.background(Color.primaryColor.ignoresSafeArea())
        }
        
    }
    
    var iptvCell:some View{
        return  ZStack{
            Image("movie1")
                .resizable()
                //.frame(minWidth: width,minHeight: height)
                .frame(width:width,height: height)
                .scaledToFill()
                //.clipped()
                .overlay(imageOverLayView,alignment: .bottom)
            
            //.frame(height: 130)
        }.cornerRadius(5)
        
    }
    var imageOverLayView:some View{
        VStack{
            Text("Title")
                .font(.TVFonts.carioBold)
                .foregroundColor(.white)
                .lineLimit(0)
                //.minimumScaleFactor(0.7)
            
            Text("Description")
                .font(.TVFonts.carioRegular)
                .lineLimit(0)
                //.minimumScaleFactor(0.7)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: 65)
        .background(Color.black.opacity(0.4))
    }
}

struct IptvView_Previews: PreviewProvider {
    static var previews: some View {
        IptvView()
    }
}
