//
//  ClassicLayoutView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI

struct ClassicLayoutView: View {
    var title : String
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title: title)
                
                ClassicListGridView()
                
            }
        }
    }
}

struct ClassicListGridView:View{
    @State private var isSelectItem = false
    let data = (1...100).map { "Item \($0)" }
    
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(data, id: \.self) { item in
                    if #available(iOS 13.0,tvOS 16.0, *) {
                        rowListView
                            .onTapGesture {
                                self.isSelectItem.toggle()
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }.fullScreenCover(isPresented: $isSelectItem) {
            //
            ZStack{
                Color.primaryColor.ignoresSafeArea()
                VStack{
                    NavigationHeaderView(title: "Movie")
                    
                    CollectionGridView(width:160,height: 200)
                }
            }
        }
    }
    
    var rowListView:some View{
        HStack{
            // Logo
            Image("tv")
                .resizable()
                .frame(width:40,height: 40)
                .scaledToFill()
                .foregroundColor(.white)
            Spacer()
            
            Text("Title")
                .font(.carioBold)
                .padding()
                .frame(maxWidth:.infinity,alignment: .leading)
                .foregroundColor(.white)
            Spacer()
            
            
            
            Spacer()
            // Users Catalog
            Text("0")
                .font(.carioBold)
                .foregroundColor(.white)
            
            HStack{
                Button {
                    //
                } label: {
                    Image("arrow_right")
                        .resizable()
                        .frame(width:30,height: 30)
                        .scaledToFill()
                        .foregroundColor(.white)
                }
                .frame(width:40,height: 40)
            }
            
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: 60)
        .background(RoundedRectangle(cornerRadius: 2).fill(Color.secondaryColor))
    }
}

struct ClassicLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0,tvOS 15.0, *) {
            ClassicLayoutView(title: "")
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
