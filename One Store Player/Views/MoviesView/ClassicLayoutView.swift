//
//  ClassicLayoutView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI
import ToastUI
import Combine
struct ClassicLayoutView: View {
    var subject : (String,ViewType)
    @StateObject private var vm = ClassicViewModel()
    @State private var categories = [MovieCategoriesModel]()
    @State private var isSortPress = false
    fileprivate func fetchCategories() {
        vm.fetchAllMoviewCategories(type: subject.1).sink { subError in
            //
        } receiveValue: { categories in
            if categories.isEmpty {
                self.categories.removeAll()
                self.categories = categories
            }else{
                //self.categories.removeAll()
                self.categories = categories
            }
            
            LocalStorgage.store.storeObject(array: categories, key: subject.1 == .movie ? LocalStorageKeys.moviesCategories.rawValue : LocalStorageKeys.seriesCategories.rawValue)
        }.store(in: &vm.subscriptions)
    }
    
    fileprivate func removingItemsFromLocalStorage() {
        LocalStorgage.store.deleteObject(key: subject.1 == .movie ? LocalStorageKeys.moviesCategories.rawValue : LocalStorageKeys.seriesCategories.rawValue)
        LocalStorgage.store.deleteObject(key: subject.1 == .movie ? LocalStorageKeys.allMoviesCategories.rawValue : LocalStorageKeys.allSeriesCategories.rawValue)
        LocalStorgage.store.deleteObject(key: subject.1 == .movie ? LocalStorageKeys.movies.rawValue : LocalStorageKeys.sereis.rawValue)
    }
    
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title: subject.0,isHideOptions: true) { text in
                    let filters = categories.filter { $0.categoryName.localizedCaseInsensitiveContains(text)}
                    
                    self.categories = filters.count > 0 ? filters : categories
                } moreAction: { isSort in
                    if isSort{
                        isSortPress.toggle()
                    }
                    else{
                        removingItemsFromLocalStorage()
                        NotificationCenter.default.post(name: .init("reloa_d"), object: self)
                        
                        self.categories = []
                        self.fetchCategories()
                    }
                    
                }
                ClassicListGridView(data: $categories, subject: subject)
                    .environmentObject(vm)
                
            }
            if isSortPress {
                VStack(spacing:10){
                    
                    Button("Default", action: {
                        //selectSortText = "Default"
                        isSortPress.toggle()
                        self.categories = []
                        fetchCategories()
                        
                    })
                    .foregroundColor(.black)
                    
                    Button("Recently Added", action: {

                        isSortPress.toggle()
                        self.categories = []
                        removingItemsFromLocalStorage()
                        fetchCategories()
                    })
                    .foregroundColor(.black)
                    
                    Button("A-Z", action: {
                        isSortPress.toggle()
                        categories  =  categories.sorted { $0.categoryName.lowercased()  < $1.categoryName.lowercased()  }
                    })
                    .foregroundColor(.black)
                    
                    Button("Z-A", action: {
                        isSortPress.toggle()
                        categories  =  categories.sorted { $0.categoryName.lowercased()  > $1.categoryName.lowercased()  }
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
        }.onAppear {
            fetchCategories()
            
            
            
            
        }
    }
}

struct ClassicListGridView:View{
    @State private var isSelectItem = false
    @State private var isLoadedTapped = false
    @Binding var data : [MovieCategoriesModel]
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var selectItem : MovieCategoriesModel?
    @State private var isRefresh = false
    @EnvironmentObject private var vm:ClassicViewModel
    @State private var series : [SeriesModel]?
    @State private var movies : [MovieModel]?
    @State private var filterSeries : [SeriesModel]?
    @State private var filterMovies : [MovieModel]?
    @State var subject : (String,ViewType)
    @EnvironmentObject var favMovies : MoviesFavourite
    @EnvironmentObject var favSeries : SeriesFavourite
    fileprivate func fetchSeries(_ newValue: MovieCategoriesModel?) {
        if newValue != nil {
            
            if newValue!.categoryName == "ALL" {
                let responseType : AnyPublisher<[SeriesModel], APIError>  = vm.fetchAllData(type: .series)
                responseType.sink { subErrr in
                    vm.isLoading = false
                    switch subErrr {
                    case .failure(let err):
                        debugPrint(err)
                    case .finished:
                        vm.isLoading = false
                        break
                    }
                    debugPrint(subErrr)
                } receiveValue: { movies in
                    debugPrint("M",movies)
                    vm.isLoading = false
                    self.series?.removeAll()
                    self.filterSeries?.removeAll()
                    self.filterSeries = nil
                    self.series = movies
                    LocalStorgage.store.storeObject(array: movies, key: LocalStorageKeys.sereis.rawValue)
                    if !isRefresh {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            self.isSelectItem.toggle()
                        }
                    }
                    
                    
                }.store(in: &vm.subscriptions)
                
            }else if newValue!.categoryName == "Favourites" {
                // Favourites
                self.filterSeries?.removeAll()
                self.filterSeries = nil
                self.series = favSeries.getSeries()
                
                if !isRefresh {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        self.isSelectItem.toggle()
                    }
                }
                
            }
            else {
                let responseType : AnyPublisher<[SeriesModel], APIError>  = vm.fetchAllMoviesById(id: newValue!.categoryID, type:subject.1)
                
                responseType.sink { subErrr in
                    vm.isLoading = false
                    switch subErrr {
                    case .failure(let err):
                        debugPrint(err)
                    case .finished:
                        vm.isLoading = false
                        break
                    }
                    debugPrint(subErrr)
                } receiveValue: { movies in
                    debugPrint("M",movies)
                    vm.isLoading = false
                    self.series?.removeAll()
                    self.filterSeries?.removeAll()
                    self.filterSeries = nil
                    self.series = movies
                    LocalStorgage.store.storeObject(array: movies, key: LocalStorageKeys.sereis.rawValue)
                    if !isRefresh {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            self.isSelectItem.toggle()
                        }
                    }
                    
                }.store(in: &vm.subscriptions)
            }
            
            
            
        }
    }
    
    fileprivate func fetchMovies(_ newValue: MovieCategoriesModel?) {
        if newValue != nil {
            if newValue!.categoryName == "ALL" {
                let responseType : AnyPublisher<[MovieModel], APIError>  = vm.fetchAllData(type: .movie)
                responseType.sink { subErrr in
                    vm.isLoading = false
                    switch subErrr {
                    case .failure(let err):
                        debugPrint(err)
                    case .finished:
                        vm.isLoading = false
                        break
                    }
                    debugPrint(subErrr)
                } receiveValue: { movies in
                    debugPrint("M",movies)
                    vm.isLoading = false
                    self.movies?.removeAll()
                    self.filterMovies?.removeAll()
                    self.filterMovies = nil
                    self.movies = movies
                    LocalStorgage.store.storeObject(array: movies, key: LocalStorageKeys.movies.rawValue)
                    if !isRefresh {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            self.isSelectItem.toggle()
                        }
                    }
                    
                    
                }.store(in: &vm.subscriptions)
                
            }
            else if newValue!.categoryName == "Favourites" {
                // Favourites
                self.filterMovies?.removeAll()
                self.filterMovies = nil
                self.movies = favMovies.getMovies()
                
                if !isRefresh {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        self.isSelectItem.toggle()
                    }
                }
            }
            else {
                let responseType : AnyPublisher<[MovieModel], APIError>  = vm.fetchAllMoviesById(id: newValue!.categoryID, type:subject.1)
                
                responseType.sink { subErrr in
                    vm.isLoading = false
                    switch subErrr {
                    case .failure(let err):
                        debugPrint(err)
                    case .finished:
                        vm.isLoading = false
                        break
                    }
                    debugPrint(subErrr)
                } receiveValue: { movies in
                    debugPrint("M",movies)
                    vm.isLoading = false
                    self.movies?.removeAll()
                    self.filterMovies?.removeAll()
                    self.filterMovies = nil
                    self.movies = movies
                    LocalStorgage.store.storeObject(array: movies, key: LocalStorageKeys.movies.rawValue)
                    if !isRefresh {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            self.isSelectItem.toggle()
                        }
                    }
                    
                }.store(in: &vm.subscriptions)
            }
            
            
        }
    }
    
    var body: some View{
        ScrollView {
            HStack{
                if #available(tvOS 16.0, *) {
                    RowCell(data: .init(categoryID: "", categoryName: "ALL", parentID: 0), viewType: subject.1)
                        .onTapGesture {
                            selectItem = .init(categoryID: "", categoryName: "ALL", parentID: 0)

                        }
                } else {
                    // Fallback on earlier versions
                }
                
                if #available(tvOS 16.0, *) {
                    RowCell(data: .init(categoryID: "", categoryName: "Favourites", parentID: 0), viewType: subject.1)
                        .onTapGesture {
                            selectItem = .init(categoryID: "", categoryName: "Favourites", parentID: 0)
                            //self.subject = ("Favourites",subject.1)
                        }
                } else {
                    // Fallback on earlier versions
                }
            }
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(data, id: \.categoryID) { item in
                    if #available(iOS 13.0,tvOS 16.0, *) {
                        RowCell(data: item, viewType: subject.1)
                            .onTapGesture {
                                selectItem = item
                                
                                //self.isSelectItem.toggle()
                            }
                        
                        
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
        .onChange(of: selectItem, perform: { newValue in
            //selectItem = nil
            if subject.1 == .series {
                self.subject = ("",ViewType.series)
                fetchSeries(newValue)
                
                
            }else{
                self.subject = ("",ViewType.movie)
                fetchMovies(newValue)
                
                
            }
            
        })
        .fullScreenCover(isPresented: $isSelectItem) {
            if movies != nil {
                
                ShowContainerView(series: .constant(nil), movies: $movies, selectItem: $selectItem, subject: subject)
                
            }else {
                
                ShowContainerView(series: $series, movies: .constant(nil), selectItem: $selectItem, subject: subject)
            }
           
            
            

        }
        .onReceive(NotificationCenter.Publisher.init(center: .default, name: .init("refe"))) { out in
            if let inf = out.userInfo?["isUp"] as? Bool, inf == true {
                isRefresh = true
            }
            if subject.1 == .series {
                self.subject = ("",ViewType.series)
                fetchSeries(selectItem)
                
                
            }else{
                self.subject = ("",ViewType.movie)
                fetchMovies(selectItem)
                
                
            }
        }
    }
}

struct ShowContainerView:View{
    @Binding var series : [SeriesModel]?
    @Binding var movies : [MovieModel]?
    @State private var filterSeries : [SeriesModel]?
    @State private var filterMovies : [MovieModel]?
    @Binding var selectItem : MovieCategoriesModel?
    var subject : (String,ViewType)
    @State private var isSort = false
    //var action: (()->Void)?
    var body: some View{
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                

                NavigationHeaderView(title: selectItem?.categoryName ?? "ALL") { text in
                    if movies != nil {
                        let filters = movies?.filter {
                            $0.name!.range(of: text,options: .caseInsensitive) != nil
                            
                        }
                        
                        
                        filterMovies = filters?.count ?? 0 > 0 ? filters : nil
                    }else{
                        let filters = series?.filter {
                            $0.name.range(of: text,options: .caseInsensitive) != nil
                            
                        }
                        
                        filterSeries = filters?.count ?? 0 > 0 ? filters : nil
                    }
                    
                } moreAction: { issort in
                    if issort {
                        isSort.toggle()
                    }
                    else{
                        if series != nil {
                            self.filterSeries = nil
                            
                            self.series = []
                            NotificationCenter.default.post(name: .init("refe"), object: self,userInfo: ["isUp":true])
                        }else{
                            self.filterMovies = nil
                            self.movies = []
                            NotificationCenter.default.post(name: .init("refe"), object: self,userInfo: ["isUp":true])
                            
                            
                        }
                    }
                    
                }
        
                if series != nil {
                    CollectionGridView(movies: nil, series:filterSeries != nil ? $filterSeries: $series,width: .infinity,view: subject.1)
                }else{
                    CollectionGridView(movies:filterMovies != nil ? $filterMovies : $movies, series: nil,width: .infinity,view: subject.1)
                    
                }
               
            }
            if isSort{
                VStack(spacing:10){
                    
                    Button("Default", action: {
                        //selectSortText = "Default"
                        isSort.toggle()
                        if series != nil {
                            self.series = []
                            NotificationCenter.default.post(name: .init("refe"), object: self,userInfo: ["isUp":true])
                        }else{
                            self.movies = []
                            NotificationCenter.default.post(name: .init("refe"), object: self,userInfo: ["isUp":true])
                        }
                        
                        
                    })
                    .foregroundColor(.black)
                    
                    Button("Recently Added", action: {
//                        selectSortText = "Recently Added"
//                        self.fetchCategories()
                        isSort.toggle()
                        if series != nil {
                            self.series = []
                            NotificationCenter.default.post(name: .init("refe"), object: self,userInfo: ["isUp":true])
                        }else{
                            self.movies = []
                            NotificationCenter.default.post(name: .init("refe"), object: self,userInfo: ["isUp":true])
                        }
                    })
                    .foregroundColor(.black)
                    
                    Button("A-Z", action: {
                        isSort.toggle()
                        if series != nil {
                            self.series = series?.sorted { $0.name.lowercased() < $1.name.lowercased() }
                        }else{
                            movies  =  movies?.sorted { $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? "" }
                        }
                        
//                            subStreams = subStreams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                    })
                    .foregroundColor(.black)
                    
                    Button("Z-A", action: {
                        isSort.toggle()
                        if series != nil {
                            self.series = series?.sorted { $0.name.lowercased() > $1.name.lowercased() }
                        }else{
                            movies  =  movies?.sorted { $0.name?.lowercased() ?? "" > $1.name?.lowercased() ?? "" }
                        }
                    })
                    .foregroundColor(.black)
                    
                    Button {
                        isSort.toggle()
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
    }
}

struct RowCell:View{
    let data:MovieCategoriesModel
    let viewType:ViewType
    @EnvironmentObject private var vm:ClassicViewModel
    @EnvironmentObject var favMovies : MoviesFavourite
    @EnvironmentObject var favSeries : SeriesFavourite
    @State private var count:Int = 0
    var body: some View{
        HStack{
            // Logo
            Image("tv")
                .resizable()
                .frame(width:20,height: 20)
                .scaledToFill()
                .foregroundColor(.white)
            Spacer()
            
            Text(data.categoryName)
                .padding()
                .font(.carioBold)
                .minimumScaleFactor(0.7)
                .lineLimit(3)
                .frame(maxWidth:.infinity,alignment: .leading)
                .foregroundColor(.white)
            Spacer()
            
            
            
            Spacer()
            // Users Catalog
            Text(count > 0 ? "\(count)" : "")
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
        .onAppear(perform: countTotalData)
        .padding()
        .frame(maxWidth:.infinity,maxHeight: 60)
        .background(RoundedRectangle(cornerRadius: 2).fill(Color.secondaryColor))
        .onReceive(NotificationCenter.Publisher(center: .default, name: .init("reloa_d"))) { _ in
            if data.categoryName == "ALL", viewType == .movie {
                if let value: Int  = LocalStorgage.store.getSingleObject(key: LocalStorageKeys.allMoviesCategories.rawValue) {
                    self.count = value
                }else{
                    let responseType : AnyPublisher<[MovieModel], APIError>  = vm.fetchAllData(type: viewType)
                    responseType.sink { result in
                        switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            debugPrint(error.localizedDescription)
                        }
                    } receiveValue: { movies in
                        DispatchQueue.main.async {
                            self.count = movies.count
                            LocalStorgage.store.storeSingleObject(array: movies.count, key: LocalStorageKeys.allMoviesCategories.rawValue)
                            //RealmManager.shared.writeObject(object: re)
                        }
                    }.store(in: &vm.subscriptions)
                }
                
                
            }else if data.categoryName == "ALL", viewType == .series {
                if let value: Int  = LocalStorgage.store.getSingleObject(key: LocalStorageKeys.allSeriesCategories.rawValue) {
                    self.count = value
                }else{
                    let responseType : AnyPublisher<[SeriesModel], APIError>  = vm.fetchAllData(type: viewType)
                    responseType.sink { result in
                        switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            debugPrint(error.localizedDescription)
                        }
                    } receiveValue: { movies in
                        DispatchQueue.main.async {
                            self.count = movies.count
                            LocalStorgage.store.storeSingleObject(array: movies.count, key: LocalStorageKeys.allSeriesCategories.rawValue)
                            //RealmManager.shared.writeObject(object: re)
                        }
                    }.store(in: &vm.subscriptions)
                }
                
            }
        }
    }
    
    
    func countTotalData(){
        let re = CategoriesRealmModel()
        re.categoryID = data.categoryID
        re.categoryName = data.categoryName
        re.parentID = data.parentID
        re.totalCount = 0
        if let storeValue:Int = LocalStorgage.store.getSingleObject(key: data.categoryName) {
            debugPrint("Fetch From Local")
            DispatchQueue.main.async {
                self.count = storeValue
                
            }
        }else{
            if data.categoryName == "Favourites", viewType == .movie {
                self.count = favMovies.getMovies().count
            }
            else if data.categoryName == "Favourites", viewType == .series {
                self.count = favSeries.getSeries().count
            }else{
                if data.categoryName == "ALL", viewType == .movie {
                    if let value: Int  = LocalStorgage.store.getSingleObject(key: LocalStorageKeys.allMoviesCategories.rawValue) {
                        self.count = value
                    }else{
                        let responseType : AnyPublisher<[MovieModel], APIError>  = vm.fetchAllData(type: viewType)
                        responseType.sink { result in
                            switch result {
                            case .finished:
                                break
                            case .failure(let error):
                                debugPrint(error.localizedDescription)
                            }
                        } receiveValue: { movies in
                            DispatchQueue.main.async {
                                self.count = movies.count
                                LocalStorgage.store.storeSingleObject(array: movies.count, key: LocalStorageKeys.allMoviesCategories.rawValue)
                                //RealmManager.shared.writeObject(object: re)
                            }
                        }.store(in: &vm.subscriptions)
                    }
                    
                    
                }else if data.categoryName == "ALL", viewType == .series {
                    if let value: Int  = LocalStorgage.store.getSingleObject(key: LocalStorageKeys.allSeriesCategories.rawValue) {
                        self.count = value
                    }else{
                        let responseType : AnyPublisher<[SeriesModel], APIError>  = vm.fetchAllData(type: viewType)
                        responseType.sink { result in
                            switch result {
                            case .finished:
                                break
                            case .failure(let error):
                                debugPrint(error.localizedDescription)
                            }
                        } receiveValue: { movies in
                            DispatchQueue.main.async {
                                self.count = movies.count
                                LocalStorgage.store.storeSingleObject(array: movies.count, key: LocalStorageKeys.allSeriesCategories.rawValue)
                                //RealmManager.shared.writeObject(object: re)
                            }
                        }.store(in: &vm.subscriptions)
                    }
                    
                }
                else if viewType == .movie {
                    let responseType : AnyPublisher<[MovieModel], APIError>  = vm.fetchAllMoviesById(id: data.categoryID, type:viewType)
                    responseType.sink { result in
                        switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            debugPrint(error.localizedDescription)
                        }
                    } receiveValue: { movies in
                        DispatchQueue.main.async {
                            self.count = movies.count
                            LocalStorgage.store.storeSingleObject(array: movies.count, key: data.categoryName)
                            //RealmManager.shared.writeObject(object: re)
                        }
                    }.store(in: &vm.subscriptions)
                }else if viewType == .series{
                    let responseType : AnyPublisher<[SeriesModel], APIError>  = vm.fetchAllMoviesById(id: data.categoryID, type:viewType)
                    responseType.sink { result in
                        switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            debugPrint(error.localizedDescription)
                        }
                    } receiveValue: { series in
                        DispatchQueue.main.async {
                            self.count = series.count
                            LocalStorgage.store.storeSingleObject(array: series.count, key: data.categoryName)
                            //RealmManager.shared.writeObject(object: re)
                        }
                    }.store(in: &vm.subscriptions)
                }
            }
            
            
        }
        
        
    }
    
    
    
}

