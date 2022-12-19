//
//  CollectionView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI
import SDWebImageSwiftUI

var recentlyWatchMovies = [MovieModel]()

class DataPassOb:ObservableObject {
    @Published var selectItem : MovieModel?
    @Published var selectSeriesItem : SeriesModel?
}
struct CollectionGridView:View{

    @Binding var data : [MovieModel]?
    @Binding var series : [SeriesModel]?
    let columns : [GridItem] = Array(repeating: .init(.flexible(),spacing: 20), count: 4)
    @State private var selectItem : MovieModel?
    @State private var selectSeriesItem : SeriesModel?
    @State private var isShowWatch = false
    @StateObject var vm = DataPassOb()
    var width : CGFloat = 120
    var height : CGFloat = 180
    @EnvironmentObject var favMovies: MoviesFavourite
    @EnvironmentObject var favSeries: SeriesFavourite
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
                        MovieCell(width: width, height: height, data: item)
                            .onTapGesture {
                                recentlyWatchMovies.append(item)
                                vm.selectItem = item
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    isShowWatch.toggle()
                                }
                            }
                            .contextMenu {
                                Button {
                                    favMovies.saveMovies(model: item)
                                } label: {
                                    Label("Add to Favourite", systemImage: "suit.heart")
                                }

                            }
                        
//                        Button {
//                           recentlyWatchMovies.append(item)
//                            vm.selectItem = item
//                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                                isShowWatch.toggle()
//                            }
//
////                            if selectItem != nil {
////                                selectItem = nil
////                                DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
////                                    selectItem = item
////                                }
////
////                            }else{
////                                selectItem = item
////                            }
//
//
//                        } label: {
//
//
//                        }
                    }
                }else{
                    ForEach(series ?? [], id: \.num) { item in
                        MovieCell(width: width, height: height, data: item)
                            .onTapGesture {
                                vm.selectSeriesItem = item
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    isShowWatch.toggle()
                                }
                            }
                        .contextMenu {
                            Button {
                                favSeries.saveMovies(model: item)
                            } label: {
                                Label("Add to Favourite", systemImage: "suit.heart")
                            }

                        }
                    }
                }
                
            }
        }
        .onChange(of: selectItem, perform: { newValue in
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+2) {
                isShowWatch.toggle()
                selectItem = nil
            }
        })
        .onChange(of: selectSeriesItem, perform: { newValue in
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+2) {
                isShowWatch.toggle()
            }
        })
        .fullScreenCover(isPresented: $isShowWatch) {
            if vm.selectItem != nil {
                WatchView(data: vm.selectItem)
            }
            else{
                WatchView(data: vm.selectSeriesItem)
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
