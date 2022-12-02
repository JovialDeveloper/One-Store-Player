//
//  CollectionView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI
import SDWebImageSwiftUI
struct CollectionGridView:View{

    @Binding var data : [MovieModel]?
    @Binding var series : [SeriesModel]?
    let columns : [GridItem] = Array(repeating: .init(.flexible(),spacing: 20), count: 4)
    @State private var selectItem : MovieModel?
    @State private var selectSeriesItem : SeriesModel?
    @State private var isShowWatch = false
    var width : CGFloat = 120
    var height : CGFloat = 180
    
    init(movies: Binding<[MovieModel]?>?,series: Binding<[SeriesModel]?>?,width:CGFloat = 120 , height:CGFloat = 180) {
        self._data = movies ?? Binding.constant(nil)
        self._series = series ?? Binding.constant(nil)
        self.width = width
        self.height = height
    }
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                if data != nil {
                    ForEach(data!, id: \.num) { item in
                        Button {
                            selectItem = item
                           
                        } label: {
                            MovieCell(width: width, height: height, data: item)
                        }
                    }
                }else{
                    ForEach(series ?? [], id: \.num) { item in
                        Button {
                            selectSeriesItem = item
                           
                        } label: {
                            MovieCell(width: width, height: height, data: item)
                        }
                    }
                }
                
            }
        }
        .onChange(of: selectItem, perform: { newValue in
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+2) {
                isShowWatch.toggle()
            }
        })
        .onChange(of: selectSeriesItem, perform: { newValue in
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+2) {
                isShowWatch.toggle()
            }
        })
        .fullScreenCover(isPresented: $isShowWatch) {
            if selectItem != nil {
                WatchView(data: selectItem)
            }
            else{
                WatchView(data: selectSeriesItem)
            }
        }
    }
    
}

struct MovieCell<T:Codable>:View{
    var width : CGFloat = 120
    var height : CGFloat = 180
    var data : T
    var body: some View{
#if os(tvOS)
        return  ZStack{
            WebImage(url: .init(string:data is MovieModel ?  (data as! MovieModel).streamIcon ?? "" : (data as! SeriesModel).cover ?? ""))
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
            WebImage(url: .init(string:data is MovieModel ?  (data as! MovieModel).streamIcon ?? "" : (data as! SeriesModel).cover))
                .resizable()
//                .frame(width:width,height: height)
                .scaledToFill()
                .clipped()
                .overlay(imageOverLayView,alignment: .bottom)
                .overlay(ratingView,alignment: .topLeading)
            
            //.frame(height: 130)
        }.cornerRadius(5)
#endif
    }
    
    var ratingView:some View{
        ZStack{
            Text("\(String(format: "%.2f",data is MovieModel ?  (data as! MovieModel).rating5Based ?? 0.0 : (data as! SeriesModel).rating5Based))")
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
            Text(data is MovieModel ?  (data as! MovieModel).name ?? "" : (data as! SeriesModel).name)
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
