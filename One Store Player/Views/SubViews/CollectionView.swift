//
//  CollectionView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI
fileprivate class MediaViewModel:ObservableObject{
    @Published var isShowWatch = false
}
struct CollectionGridView:View{
    
    var width : CGFloat = 130
    var height : CGFloat = 180
    
    let data = (1...100).map { "Item \($0)" }
    
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    @ObservedObject fileprivate var viewModel = MediaViewModel()
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(data, id: \.self) { item in
                    Button {
                        viewModel.isShowWatch.toggle()
                    } label: {
                        movieCell
                    }
                }
            }
        }.fullScreenCover(isPresented: $viewModel.isShowWatch) {
            WatchView()
        }
    }
    
    
    var movieCell:some View{
        #if os(tvOS)
         return  ZStack{
             Image("movie1")
                 .resizable()
                 .frame(minWidth: width,minHeight: height)
                 //.frame(width:width,height: height)
                 .scaledToFill()
                 //.clipped()
                 .overlay(imageOverLayView,alignment: .bottom)
                 .overlay(ratingView,alignment: .topLeading)
             
             //.frame(height: 130)
         }.cornerRadius(5)
        #else
        return ZStack{
            Image("movie1")
                .resizable()
                .frame(width:width,height: height)
                .scaledToFill()
                //.clipped()
                .overlay(imageOverLayView,alignment: .bottom)
                .overlay(ratingView,alignment: .topLeading)
            
            //.frame(height: 130)
        }.cornerRadius(5)
        #endif
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
                .font(.carioBold)
                .foregroundColor(.white)
                .lineLimit(0)
                //.minimumScaleFactor(0.7)
            
            Text("Description")
                .font(.carioRegular)
                .lineLimit(0)
                //.minimumScaleFactor(0.7)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: 65)
        .background(Color.black.opacity(0.4))
    }
}
