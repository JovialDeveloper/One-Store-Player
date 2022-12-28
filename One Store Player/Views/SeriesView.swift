//
//  SeriesView.swift
//  One Store Player
//
//  Created by MacBook Pro on 30/11/2022.
//

import SwiftUI
import Combine
import ToastUI
import SDWebImageSwiftUI


class SeriesFavourite:ObservableObject
{
    func saveMovies(model:SeriesModel){
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favSeries.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favSeries = try decoder.decode([SeriesModel].self, from: data)
                
                if favSeries.contains(where: {$0.seriesID == model.seriesID}) {
                    return
                }else{
                    favSeries.append(model)
                    
                    let encoder = JSONEncoder()
                        // Encode Note
                    let modelData = try encoder.encode(favSeries)

                    UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favSeries.rawValue)
                    
                }
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }

        }
        else{
            do{
                let encoder = JSONEncoder()
                    // Encode Note
                
                let modelData = try encoder.encode([model])
                UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favSeries.rawValue)
            }
            catch {
                debugPrint(error)
            }
            
            //return model
        }
    }
    
    func getSeries()->[SeriesModel]{
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favSeries.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favSeries = try decoder.decode([SeriesModel].self, from: data)
                
                return favSeries
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }

        }
        return []
    }
}

struct SeriesView: View {
    @AppStorage(AppStorageKeys.layout.rawValue) var layout: AppKeys.RawValue = AppKeys.modern.rawValue
    @Environment(\.presentationMode) var presentationMode
    var title : String
    var type:ViewType
    @StateObject private var favSeries = SeriesFavourite()
    @State var selectMoview = 0
    //    init(){
    //        UITableView.appearance().backgroundColor = .red
    //        UITableView.appearance().ce
    //    }
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            
            if layout == AppKeys.modern.rawValue {
                // Modern View
                ModernLayoutView(subject: (title,type))
                    .environmentObject(favSeries)
            }
            else {
                ClassicLayoutView(subject: (title,type))
                    .environmentObject(favSeries)
            }
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        
        
    }
}


extension SeriesView{
    struct ModernLayoutView:View{
        @Environment(\.presentationMode) var presentationMode
        var subject : (String,ViewType)
        @StateObject private var vm = SeriesModernLayoutViewModel()
        @State private var categories = [MovieCategoriesModel]()
        @State private var series = [SeriesModel]()
        @EnvironmentObject private var favSeries : SeriesFavourite
        var body: some View {
            GeometryReader{ proxy in
                ScrollView{
                    HStack{
                        ScrollView{
                            Button("ALL") {
                                vm.fetchAllSeries()
                                    .sink { subError in
                                    //
                                } receiveValue: { series in
                                    self.series = series

                                }.store(in: &vm.subscriptions)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity,alignment: .leading)
                            Divider().frame(height:1)
                                .overlay(Color.white)
                            
                            Button("Favourites") {
                                self.series = favSeries.getSeries()
                            }
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity,alignment: .leading)
                            
                            Divider().frame(height:1)
                                .overlay(Color.white)
                            
                            LazyVStack{
                                ForEach(categories,id: \.categoryID) { category in
                                    Button {
                                        
                                            vm.fetchAllSeriesById(id: category.categoryID, type: subject.1)
                                                .sink { subError in
                                                    
                                                    switch subError {
                                                    case .failure(let error):
                                                        vm.isLoading = false
                                                        debugPrint(error)
                                                    case .finished:
                                                        vm.isLoading = false
                                                        break
                                                    }
                                                } receiveValue: { series in
                                                    vm.isLoading = false
                                                    self.series = series
                                                }.store(in: &vm.subscriptions)
                                            
                                        
                                    } label: {
                                        VStack{
                                            Text(category.categoryName)
                                                .font(.carioRegular)
                                                .foregroundColor(.white)
                                                .padding()
                                                .frame(maxWidth:.infinity,alignment: .leading)
                                            
                                            Divider().frame(height:1)
                                                .overlay(Color.white)
                                            
                                        }
                                    }
                                }
                                
                            }
                        }
                        .padding(.top,30)
                        .frame(width:proxy.size.width * 0.3,height: proxy.size.height,alignment: .leading)
                        Spacer()
                        
                        VStack{
                            NavigationHeaderView(title: subject.0)
                            SeriesGridView(data: $series)
                        }
                        .frame(width:proxy.size.width * 0.7,height: proxy.size.height)
                        
                    }
                    .frame(maxWidth:.infinity,maxHeight: .infinity)
                    .toast(isPresented: $vm.isLoading) {
                        ToastView("Loading...")
                            .toastViewStyle(.indeterminate)
                    }
                }
                
            }.onAppear {
                vm.fetchAllSeriesCategories(type: .series)
                    .sink { subError in
                        //
                    } receiveValue: { categories in
                        self.categories = categories
                    }.store(in: &vm.subscriptions)

            }
            .onChange(of: self.categories) { newValue in
                vm.fetchAllSeries()
                    .sink { subError in
                    //
                } receiveValue: { series in
                    self.series = series

                }.store(in: &vm.subscriptions)
            }
        }
    }
    class SeriesModernLayoutViewModel:ObservableObject{
        @Published var isLoading = false
        @Published var isfetched = false
        @Published var isError = (false,"")
        @Published var recentlyWatchSeries = [SeriesModel]()
        var subscriptions = [AnyCancellable]()
        
        func fetchAllSeries() -> AnyPublisher<[SeriesModel], APIError>
        {
            guard let userInfo =  Networking.shared.getUserDetails()
            else {
                return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
            }
            
            let uri = "\(userInfo.port)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series"
            
            return Networking.shared.fetch(uri: uri)
        }
        
        func fetchAllSeriesCategories(baseURL:String = "http://1player.cc:80",type:ViewType) -> AnyPublisher<[MovieCategoriesModel], APIError>
        {
            guard let userInfo =  Networking.shared.getUserDetails()
            else {
                return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
            }
            
            let uri = "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series_categories"
            
            return Networking.shared.fetch(uri: uri)
        }
        
        func fetchAllSeriesById(baseURL:String = "http://1player.cc:80",id:String,type:ViewType) -> AnyPublisher<[SeriesModel], APIError>
        {
            guard let userInfo =  Networking.shared.getUserDetails()
            else {
                return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
            }
            isLoading.toggle()
            let uri = "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series&category_id=\(id)"
            return Networking.shared.fetch(uri: uri)
        }
    }
    
    class DataPassOb:ObservableObject {
        @Published var selectItem : SeriesModel?
        
    }
    struct SeriesGridView:View{
        @Binding var data : [SeriesModel]
        @StateObject var vm = DataPassOb()
        let columns : [GridItem] = Array(repeating: .init(.flexible(),spacing: 10), count: 4)
        //        @ObservedObject fileprivate var viewModel = MediaViewModel()
        @State private var isShowWatch = false
        @State private var selectItem : SeriesModel?
        @EnvironmentObject private var favSeries : SeriesFavourite
        var body: some View{
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(data, id: \.num) { item in
                        if #available(tvOS 16.0, *) {
                            SeriesCell(serie: item).onTapGesture {
                                vm.selectItem = item
                                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                                    self.isShowWatch.toggle()
                                }
                            }
                            .contextMenu {
                                Button {
                                    favSeries.saveMovies(model: item)
                                } label: {
                                    Label("Add to Favourite", systemImage: "suit.heart")
                                }
                                
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                        
//                        Button {
//                            vm.selectItem = item
//                            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//                                self.isShowWatch.toggle()
//                            }
//                        } label: {
//
//
//                        }.padding(.all,5)
                    }
                }
            }
//            .onChange(of: selectItem, perform: { newValue in
//                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//                    self.isShowWatch.toggle()
//                }
//            })
            .fullScreenCover(isPresented: $isShowWatch) {
                WatchView(data: vm.selectItem)
            }
        }
        
    }
    
    struct SeriesCell:View{
        var width : CGFloat = 120
        var height : CGFloat = 180
        var serie : SeriesModel
        var body: some View{
#if os(tvOS)
            return  ZStack{
                WebImage(url: .init(string:serie.cover))
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
                WebImage(url: .init(string:serie.cover))
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
                Text("\(String(format: "%.2f",serie.rating5Based))")
                    .font(.carioLight)
                    .foregroundColor(.white)
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
            }
            .frame(width: 40,height: 20)
            .background(Color.purple.cornerRadius(5))
            //.opacity(0.4)
        }
        
        var imageOverLayView:some View{
            VStack{
                Text(serie.name)
                    .font(.carioBold)
                    .foregroundColor(.white)
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
            }
            .padding()
            .frame(maxWidth:.infinity,maxHeight: 65)
            .background(Color.black.opacity(0.4))
        }
    }
    
}
