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
    fileprivate func fetchCategories() {
        vm.fetchAllMoviewCategories(type: subject.1).sink { subError in
            //
        } receiveValue: { categories in
            self.categories.removeAll()
            self.categories = categories
        }.store(in: &vm.subscriptions)
    }
    
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title: subject.0) { text in
                    let filters = categories.filter { $0.categoryName.localizedCaseInsensitiveContains(text)}
                    
                    self.categories = filters.count > 0 ? filters : categories
                } moreAction: {
                    self.fetchCategories()
                }
                ClassicListGridView(data: $categories, subject: subject)
                    .environmentObject(vm)
                
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
   
    @EnvironmentObject private var vm:ClassicViewModel
    @State private var series : [SeriesModel]?
    @State private var movies : [MovieModel]?
    @State private var filterSeries : [SeriesModel]?
    @State private var filterMovies : [MovieModel]?
    var subject : (String,ViewType)
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
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.isSelectItem.toggle()
                    }
                    
                }.store(in: &vm.subscriptions)
                
            }else if newValue!.categoryName == "Favourites" {
                // Favourites
                self.filterSeries?.removeAll()
                self.filterSeries = nil
                self.series = favSeries.getSeries()
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.isSelectItem.toggle()
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
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.isSelectItem.toggle()
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
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.isSelectItem.toggle()
                    }
                    
                    
                }.store(in: &vm.subscriptions)
                
            }
            else if newValue!.categoryName == "Favourites" {
                // Favourites
                self.filterMovies?.removeAll()
                self.filterMovies = nil
                self.movies = favMovies.getMovies()
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.isSelectItem.toggle()
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
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.isSelectItem.toggle()
                    }
                    
                }.store(in: &vm.subscriptions)
            }
            
            
        }
    }
    
    var body: some View{
        ScrollView {
            HStack{
                if #available(tvOS 16.0, *) {
                    RowCell(data: .init(categoryID: "", categoryName: "ALL", parentID: 0))
                        .onTapGesture {
                            selectItem = .init(categoryID: "", categoryName: "ALL", parentID: 0)

                        }
                } else {
                    // Fallback on earlier versions
                }
                
                if #available(tvOS 16.0, *) {
                    RowCell(data: .init(categoryID: "", categoryName: "Favourites", parentID: 0))
                        .onTapGesture {
                            selectItem = .init(categoryID: "", categoryName: "Favourites", parentID: 0)
                        }
                } else {
                    // Fallback on earlier versions
                }
            }
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(data, id: \.categoryID) { item in
                    if #available(iOS 13.0,tvOS 16.0, *) {
                        RowCell(data: item)
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
            selectItem = nil
            if subject.1 == .series {
                fetchSeries(newValue)
                
            }else{
                fetchMovies(newValue)
                
            }
            
        })
//        .toast(isPresented: $vm.isLoading) {
//            ToastView("Loading...")
//                .toastViewStyle(.indeterminate)
//        }
        .fullScreenCover(isPresented: $isSelectItem) {
            if movies != nil {
                
                ShowContainerView(series: .constant(nil), movies: $movies, selectItem: $selectItem, subject: subject)
                
            }else {
                
                ShowContainerView(series: $series, movies: .constant(nil), selectItem: $selectItem, subject: subject)
            }
           
            
            
//            ZStack{
//                Color.primaryColor.ignoresSafeArea()
//                VStack{
//
//
//                    NavigationHeaderView(title: subject.0) { text in
//                        if movies != nil {
//                            let filters = movies?.filter { $0.name!.localizedCaseInsensitiveContains(text)}
//
//                            self.movies = filters?.count ?? 0 > 0 ? filters : movies
//                        }else{
//                            let filters = series?.filter { $0.name.localizedCaseInsensitiveContains(text)}
//
//                            self.series = filters?.count ?? 0 > 0 ? filters : series
//                        }
//
//                    } moreAction: {
//                        isLoadedTapped = true
//                        if movies != nil {
//                            fetchMovies(.init(categoryID: "", categoryName: "ALL", parentID: 0))
////                            self.filterMovies?.removeAll()
////                            self.filterMovies = nil
////                            self.filterMovies = movies
//                        }else{
//                            //self.filterSeries = nil
//                            fetchSeries(.init(categoryID: "", categoryName: "ALL", parentID: 0))
////                            self.filterSeries?.removeAll()
////                            self.filterSeries = nil
////                            self.filterSeries = series
//                        }
//                    }
//
//                    if series != nil {
//                        CollectionGridView(movies: nil, series:filterSeries != nil ? $filterSeries: $series,width: .infinity)
//                    }else{
//                        CollectionGridView(movies:filterMovies != nil ? $filterMovies : $movies, series: nil,width: .infinity)
//
//                    }
//
//                }
//            }
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
    //var action: (()->Void)?
    var body: some View{
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                

                NavigationHeaderView(title: subject.0) { text in
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
                    
                } moreAction: {
                    if series != nil {
                        self.filterSeries = nil
                        self.series = series
                        
                    }else{
                        self.filterMovies = nil
                        self.movies = movies
                        
                    }
                }
        
                if series != nil {
                    CollectionGridView(movies: nil, series:filterSeries != nil ? $filterSeries: $series,width: .infinity)
                }else{
                    CollectionGridView(movies:filterMovies != nil ? $filterMovies : $movies, series: nil,width: .infinity)
                    
                }
               
            }
        }
    }
}

struct RowCell:View{
    let data:MovieCategoriesModel
    var body: some View{
        HStack{
            // Logo
            Image("tv")
                .resizable()
                .frame(width:40,height: 40)
                .scaledToFill()
                .foregroundColor(.white)
            Spacer()
            
            Text(data.categoryName)
                .font(.carioBold)
                .padding()
                .frame(maxWidth:.infinity,alignment: .leading)
                .foregroundColor(.white)
            Spacer()
            
            
            
            Spacer()
            // Users Catalog
            Text(data.categoryID)
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

