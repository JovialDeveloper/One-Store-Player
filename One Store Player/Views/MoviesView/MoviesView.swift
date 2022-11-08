//
//  MoviesView.swift
//  One Store Player
//
//  Created by MacBook Pro on 07/11/2022.
//

import SwiftUI

struct MoviesView: View {
    @AppStorage(AppStorageKeys.layout.rawValue) var layout: AppKeys.RawValue = AppKeys.modern.rawValue
    @State var selectMoview = 0
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            if layout == AppKeys.modern.rawValue {
                // Modern View
                HStack{
                    VStack{
                        List(0..<8){_ in
                            Text("Movie Name")
                                .padding()
                                .frame(maxWidth:.infinity,alignment: .leading)
                        }
                        .frame(width:UIScreen.main.bounds.width/3,height: UIScreen.main.bounds.height)
                        .listStyle(PlainListStyle())
                        
                        //.padd
                            
                    }
                    .frame(width:UIScreen.main.bounds.width/3,height: UIScreen.main.bounds.height)
                    .background(Color.gray)
                    
                    
                    Spacer()
                    VStack{
                        HStack{
                            // Logo
                            Image("arrow_back")
                                .resizable()
                                .frame(width:40,height: 40)
                                .scaledToFill()
                                .foregroundColor(.white)
                            Spacer()
                            
                            Text("ALL")
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
                                        .frame(width:20,height: 20)
                                        .scaledToFill()
                                        .foregroundColor(.white)
                                }
                                .frame(width:20,height: 20)
                                
                                // Users Button
                                Button {
                                    //
                                } label: {
                                    Image("more")
                                        .resizable()
                                        .frame(width:20,height: 20)
                                        .scaledToFill()
                                        .foregroundColor(.white)
                                }
                                .frame(width:20,height: 20)
                            }
                            
                        }
                        .padding(.top,30)
                        .padding(.horizontal)
                        CollectionGridView()
                    }
                    
                    // Moviews List
                    
                    
                }
                
            }
        }.frame(maxWidth:.infinity,maxHeight: .infinity)
        
        
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            MoviesView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}

struct CollectionGridView:View{
    let data = (1...100).map { "Item \($0)" }
    
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(data, id: \.self) { item in
                    movieCell
                }
            }
        }
    }
    
    
    var movieCell:some View{
        ZStack{
            Image("movie1")
                .resizable()
                .frame(width:110,height: 150)
                .scaledToFill()
                //.clipped()
                .overlay(imageOverLayView,alignment: .bottom)
                .overlay(ratingView,alignment: .topLeading)
            
            //.frame(height: 130)
        }.cornerRadius(5)
    }
    
    
    var ratingView:some View{
        ZStack{
            Text("4.7")
                .font(.carioLight)
                .foregroundColor(.white)
        }
        .frame(width: 25,height: 30)
        .background(Color.purple.cornerRadius(5))
        //.opacity(0.4)
    }
    
    var imageOverLayView:some View{
        VStack{
            Text("Title")
                .font(.carioRegular)
                .foregroundColor(.white)
                .lineLimit(0)
                .minimumScaleFactor(0.7)
            
            Text("Description")
                .font(.carioRegular)
                .lineLimit(0)
                .minimumScaleFactor(0.7)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: 50)
        .background(Color.black)
        .opacity(0.4)
    }
}
