//
//  SeriesView.swift
//  One Store Player
//
//  Created by MacBook Pro on 30/11/2022.
//

import SwiftUI
import Combine
import ToastUI
import Kingfisher


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
    func findItem(model:SeriesModel)->Bool{
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favSeries.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let favSeries = try decoder.decode([SeriesModel].self, from: data)
                
                if favSeries.contains(where: {$0.seriesID == model.seriesID}) {
                    if let _ = favSeries.firstIndex(where: {$0.seriesID == model.seriesID}) {
                        return true
                    }
                    
                    return false
                }
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }

        }
        return false
    }
    func deleteSeries(model:SeriesModel){
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favSeries.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favSeries = try decoder.decode([SeriesModel].self, from: data)
                
                if favSeries.contains(where: {$0.seriesID == model.seriesID}) {
                    if let index = favSeries.firstIndex(where: {$0.seriesID == model.seriesID}) {
                        favSeries.remove(at: index)
                        let encoder = JSONEncoder()
                            // Encode Note
                        let modelData = try encoder.encode(favSeries)

                        UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favSeries.rawValue)
                    }
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
    @AppStorage(AppStorageKeys.layout.rawValue) var layout: AppKeys.RawValue = AppKeys.classic.rawValue
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
        @State var subject : (String,ViewType)
        @StateObject private var vm = SeriesModernLayoutViewModel()
        @State private var categories = [MovieCategoriesModel]()
        @State private var series = [SeriesModel]()
        @EnvironmentObject private var favSeries : SeriesFavourite
        @State private var selectTitle = ""
        @State private var isSortPress = false
        var body: some View {
            GeometryReader{ proxy in
                ZStack{
                    ScrollView{
                        HStack{
                            ScrollView{
                                Button("ALL") {
                                    selectTitle = "ALL"
                                    vm.fetchAllSeries()
                                        .sink { subError in
                                        //
                                    } receiveValue: { series in
                                        self.series = series
                                        LocalStorgage.store.storeObject(array: series, key: LocalStorageKeys.sereis.rawValue)

                                    }.store(in: &vm.subscriptions)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth:.infinity,alignment: .leading)
                                .background(selectTitle == "ALL" ? Color.selectedColor : nil)
//                                Divider().frame(height:1)
//                                    .overlay(Color.white)
                                
                                Button("Favourites") {
                                    self.selectTitle = "Favourites"
                                    self.series = favSeries.getSeries()
                                    self.subject = ("Favourites",.favourite)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth:.infinity,alignment: .leading)
                                .background(selectTitle == "Favourites" ? Color.selectedColor : nil)
                                
//                                Divider().frame(height:1)
//                                    .overlay(Color.white)
                                
                                LazyVStack{
                                    ForEach(categories,id: \.categoryID) { category in
                                        Button {
                                            self.selectTitle = category.categoryName
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
                                                        self.subject = ("Series",.series)
                                                    }.store(in: &vm.subscriptions)
                                                
                                            
                                        } label: {
                                            VStack{
                                                Text(category.categoryName)
                                                    .font(.carioRegular)
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .frame(maxWidth:.infinity,alignment: .leading)
                                                
//                                                Divider().frame(height:1)
//                                                    .overlay(Color.white)
                                                
                                            }
                                        }
                                        .background(selectTitle == category.categoryName ? Color.selectedColor : nil)
                                    }
                                    
                                }
                            }
                            .padding(.top,30)
                            .frame(width:proxy.size.width * 0.3,height: proxy.size.height,alignment: .leading)
                            Spacer()
                            
                            VStack{
                                NavigationHeaderView(title: selectTitle) { text in
                                    let filters = series.filter { $0.name.localizedCaseInsensitiveContains(text)}
                                    
                                    self.series = filters.count > 0 ? filters : series
                                    
                                } moreAction: { isSort in
                                    if isSort {
                                        isSortPress.toggle()
                                    }else{
                                        vm.fetchAllSeries()
                                            .sink { subError in
                                                vm.isLoading = false
                                        } receiveValue: { series in
                                            vm.isLoading = false
                                            
                                            self.series = series
           
                                            
                                        }.store(in: &vm.subscriptions)
                                    }
                                }

                                SeriesGridView(data: $series, viewType: subject.1)
                            }
                            .frame(width:proxy.size.width * 0.7,height: proxy.size.height)
                            
                        }
                        .frame(maxWidth:.infinity,maxHeight: .infinity)
    //                    .toast(isPresented: $vm.isLoading) {
    //                        ToastView("Loading...")
    //                            .toastViewStyle(.indeterminate)
    //                    }
                    }
                    if isSortPress{
                        VStack(spacing:10){
                            
                            Button("Default", action: {
                                //selectSortText = "Default"
                                isSortPress.toggle()
                                vm.fetchAllSeries()
                                    .sink { subError in
                                        vm.isLoading = false
                                } receiveValue: { series in
                                    vm.isLoading = false
                                    
                                    self.series = series
   
                                    
                                }.store(in: &vm.subscriptions)
                                
                            })
                            .foregroundColor(.black)
                            
                            Button("Recently Added", action: {
       
                                isSortPress.toggle()
                                vm.fetchAllSeries()
                                    .sink { subError in
                                        vm.isLoading = false
                                } receiveValue: { series in
                                    vm.isLoading = false
                                    
                                    self.series = series
                                    
    //                                        .sorted(by: {$0.added?.getDateWithTimeInterval().compare($1.added?.getDateWithTimeInterval() ?? Date()) == .orderedDescending })
                                    
                                }.store(in: &vm.subscriptions)
                            })
                            .foregroundColor(.black)
                            
                            Button("A-Z", action: {
                                isSortPress.toggle()
                                series  =  series.sorted { $0.name.lowercased()  < $1.name.lowercased()  }
    //                            subStreams = subStreams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                            })
                            .foregroundColor(.black)
                            
                            Button("Z-A", action: {
                                isSortPress.toggle()
                                series  =  series.sorted { $0.name.lowercased()  > $1.name.lowercased()  }
                            })
                            .foregroundColor(.black)
                            
                            Button {
                                isSortPress.toggle()
                            } label: {
                                Text("Submit")
                                    .padding()
                                    .foregroundColor(.white)
                            }
                            .frame(width:150,height: 46)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                            

                        }
                        .frame(width: 200,height: 200)
                        
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    }
                }
                
                
            }.onAppear {
                vm.fetchAllSeriesCategories(type: .series)
                    .sink { subError in
                        //
                    } receiveValue: { categories in
                        self.categories = categories
                        LocalStorgage.store.storeObject(array: categories, key: LocalStorageKeys.seriesCategories.rawValue)
                        self.selectTitle = "ALL"
                    }.store(in: &vm.subscriptions)

            }
            .onChange(of: self.categories) { newValue in
                vm.fetchAllSeries()
                    .sink { subError in
                    //
                } receiveValue: { series in
                    self.series = series
                    LocalStorgage.store.storeObject(array: series, key: LocalStorageKeys.sereis.rawValue)
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
            let localData : [SeriesModel] = LocalStorgage.store.getObject(key: LocalStorageKeys.sereis.rawValue)
            if localData.count > 0 {
                return Just(localData)
                    .setFailureType(to: APIError.self)
                    .eraseToAnyPublisher()
            }
            else {
                guard let userInfo =  Networking.shared.getUserDetails()
                else {
                    return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
                }
                
                let uri = "\(userInfo.port)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series"
                
                return Networking.shared.fetch(uri: uri)
            }
            
        }
        
        func fetchAllSeriesCategories(baseURL:String = "http://1player.cc:80",type:ViewType) -> AnyPublisher<[MovieCategoriesModel], APIError>
        {
            let cat : [MovieCategoriesModel] = LocalStorgage.store.getObject(key: LocalStorageKeys.seriesCategories.rawValue)
            if cat.count > 0 {
                return Just(cat)
                    .setFailureType(to: APIError.self)
                    .eraseToAnyPublisher()
            }
            else {
                guard let userInfo =  Networking.shared.getUserDetails()
                else {
                    return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
                }
                
                let uri = "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series_categories"
                
                return Networking.shared.fetch(uri: uri)
            }
            
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
        var viewType:ViewType
        @StateObject var vm = DataPassOb()
        let columns : [GridItem] = Array(repeating: .init(.flexible(),spacing: 10), count: 4)
        //        @ObservedObject fileprivate var viewModel = MediaViewModel()
        @State private var isShowWatch = false
        @State private var selectItem : SeriesModel?
        @EnvironmentObject private var favSeries : SeriesFavourite
        var body: some View{
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(data, id: \.num) { item in
                        if #available(tvOS 16.0, *) {
                            SeriesCell(serie: item).onTapGesture {
                                vm.selectItem = nil
                                vm.selectItem = item
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                    if vm.selectItem != nil {
                                        self.isShowWatch.toggle()
                                    }
                                    
                                }
                            }
                            .contextMenu {
                                Button {
                                    if viewType == .favourite {
                                        favSeries.deleteSeries(model: item)
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                            data = favSeries.getSeries()
                                        }
                                    }
                                    else{
                                        favSeries.saveMovies(model: item)
                                    }
                                    
                                } label: {
                                    if viewType == .favourite {
                                        Label("Remove from Favourite", systemImage: "")
                                    }else{
                                        Label("Add to Favourite", systemImage: "")
                                    }
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
                KFImage(.init(string:serie.cover))
                    .resizable()
                    .placeholder({
                        Image("NoImage")
                            .frame(minWidth: width,minHeight: height)
                            .scaledToFill()
                        
                    })
                    .frame(minWidth: width,minHeight: height)
                //.frame(width:width,height: height)
                    .scaledToFill()
                //.clipped()
                    .overlay(imageOverLayView,alignment: .bottom)
                    .overlay(ratingView.offset(x:5,y:5),alignment: .topLeading)
                
                //.frame(height: 130)
            }.cornerRadius(5)
#else
            return ZStack{
                KFImage(.init(string:serie.cover))
                    .resizable()
                    .placeholder({
                        Image("NoImage")
                            .resizable()
                            .frame(minWidth: width,minHeight: height)
                            //.scaledToFill()
                        
                    })
                    .frame(width:width,height: height)
                    .scaledToFill()
                    .overlay(imageOverLayView,alignment: .bottom)
                    .overlay(ratingView.offset(x:5,y:5),alignment: .topLeading)
                
                
            }.cornerRadius(5)
#endif
        }
        
        var ratingView:some View{
            ZStack{
                Text("\(String(format: "%.2f",serie.rating5Based))")
//                    .font(.carioLight)
                    .padding(5)
                    .foregroundColor(.white)
                    
            }
            .background(Color.purple.cornerRadius(4))

        }
        
        var imageOverLayView:some View{
            VStack{
                Text(serie.name)
                    .font(.carioBold)
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
            }
            .padding()
            .frame(maxWidth:.infinity,maxHeight: 65)
            .background(Color.black.opacity(0.4))
        }
    }
    
}
