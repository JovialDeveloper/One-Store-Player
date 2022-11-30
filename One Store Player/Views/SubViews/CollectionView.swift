//
//  CollectionView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI
import SDWebImageSwiftUI
fileprivate class MediaViewModel:ObservableObject{
    @Published var isShowWatch = false
}
struct CollectionGridView:View{
    
    
    
    //let data = (1...100).map { "Item \($0)" }
    @Binding var data : [MovieModel]
    
    let columns : [GridItem] = Array(repeating: .init(.flexible(),spacing: 20), count: 4)
    @ObservedObject fileprivate var viewModel = MediaViewModel()
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(data, id: \.num) { item in
                    Button {
                        viewModel.isShowWatch.toggle()
                    } label: {
                        MovieCell(movie: item)
                    }
                }
            }
        }.fullScreenCover(isPresented: $viewModel.isShowWatch) {
            WatchView()
        }
    }
    
}

struct MovieCell:View{
    var width : CGFloat = 120
    var height : CGFloat = 180
    var movie : MovieModel
    var body: some View{
#if os(tvOS)
        return  ZStack{
            WebImage(url: .init(string:movie.streamIcon ?? ""))
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
            WebImage(url: .init(string:movie.streamIcon ?? ""))
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
            Text("\(String(format: "%.2f",movie.rating5Based ?? 0.0))")
                .font(.carioLight)
                .foregroundColor(.white)
                .lineLimit(0)
                .minimumScaleFactor(0.5)
        }
        .frame(width: 25,height: 30)
        .background(Color.purple.cornerRadius(5))
        //.opacity(0.4)
    }
    
    var imageOverLayView:some View{
        VStack{
            Text(movie.name ?? "N/A")
                .font(.carioBold)
                .foregroundColor(.white)
                .lineLimit(0)
                .minimumScaleFactor(0.7)
            
//            Text(movie. ?? "N/A")
//                .font(.carioRegular)
//                .lineLimit(0)
//            //.minimumScaleFactor(0.7)
//                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: 65)
        .background(Color.black.opacity(0.4))
    }
}
