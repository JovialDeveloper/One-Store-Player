//
//  ModernLayoutView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import Foundation
import SwiftUI
import ToastUI
class MoviesFavourite:ObservableObject
{
    func saveMovies(model:MovieModel){
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favMovies.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favMovies = try decoder.decode([MovieModel].self, from: data)
                
                if favMovies.contains(where: {$0.streamID == model.streamID}) {
                    return
                }else{
                    favMovies.append(model)
                    
                    let encoder = JSONEncoder()
                        // Encode Note
                    let modelData = try encoder.encode(favMovies)

                    UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favMovies.rawValue)
                    
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
                UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favMovies.rawValue)
            }
            catch {
                debugPrint(error)
            }
            
            //return model
        }
    }
    func findItem(model:MovieModel)->Bool{
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favMovies.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let favMovies = try decoder.decode([MovieModel].self, from: data)
                
                if favMovies.contains(where: {$0.streamID == model.streamID}) {
                    if let _ = favMovies.firstIndex(where: {$0.streamID == model.streamID}) {
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
    
    func deleteObject(model:MovieModel) {
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favMovies.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favMovies = try decoder.decode([MovieModel].self, from: data)
                
                if favMovies.contains(where: {$0.streamID == model.streamID}) {
                    if let inde = favMovies.firstIndex(where: {$0.streamID == model.streamID}) {
                        favMovies.remove(at: inde)
                        let encoder = JSONEncoder()
                            // Encode Note
                        let modelData = try encoder.encode(favMovies)

                        UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favMovies.rawValue)
                    }
                    
                    return
                }
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }

        }
    }
    
    func getMovies()->[MovieModel]{
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favMovies.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favMovies = try decoder.decode([MovieModel].self, from: data)
                
                return favMovies
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }

        }
        return []
    }
}
struct ModernLayoutView:View{
    @Environment(\.presentationMode) var presentationMode
    @State var subject : (String,ViewType)
    @StateObject private var vm = ModernLayoutViewModel()
    @State private var categories = [MovieCategoriesModel]()
    @State private var movies : [MovieModel]?
    @EnvironmentObject var favMovies : MoviesFavourite
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
                                vm.isLoading.toggle()
                                vm.fetchAllMovies()
                                    .sink { subError in
                                        vm.isLoading = false
                                } receiveValue: { movies in
                                    vm.isLoading = false
                                    
                                    self.movies = movies
//                                        .sorted(by: {$0.added?.getDateWithTimeInterval().compare($1.added?.getDateWithTimeInterval() ?? Date()) == .orderedDescending })
                                    
                                }.store(in: &vm.subscriptions)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .background(selectTitle == "ALL" ? Color.selectedColor : nil)
                            
    //                        Divider().frame(height:1)
    //                            .overlay(Color.white)
                            
                            Button("Favourites") {
                                self.selectTitle = "Favourites"
                                self.movies = favMovies.getMovies()
                                self.subject = ("Favourites",.favourite)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .background(selectTitle == "Favourites" ? Color.selectedColor : nil)
    //                        Divider().frame(height:1)
    //                            .overlay(Color.white)
                            Button("Recently Watch") {
                                debugPrint(recentlyWatchMovies)
                                self.selectTitle = "Recently Watch"
                                self.movies = recentlyWatchMovies
                            }
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .background(selectTitle == "Recently Watch" ? Color.selectedColor : nil)
    //                        Divider().frame(height:1)
    //                            .overlay(Color.white)
                            LazyVStack{
                                ForEach(categories,id: \.categoryID) { category in
                                    Button {
                                        self.selectTitle = category.categoryName
                                        vm.fetchAllMoviesById(id: category.categoryID, type: subject.1)
                                            .sink { subErrr in
                                                vm.isLoading.toggle()
                                                switch subErrr {
                                                case .failure(let err):
                                                    debugPrint(err)
                                                case .finished:
                                                    vm.isLoading.toggle()
                                                    break
                                                }
                                                debugPrint(subErrr)
                                            } receiveValue: { movies in
                                                debugPrint("M",movies)
                                                vm.isLoading.toggle()
                                                self.movies?.removeAll()
                                                self.subject = ("Movies",.movie)
                                                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                                    self.movies = movies
                                                }
                                                
                                            }.store(in: &vm.subscriptions)
                                    } label: {
                                        VStack{
                                            Text(category.categoryName)
                                                .font(.carioRegular)
                                                .foregroundColor(.white)
                                                .padding()
                                                .frame(maxWidth:.infinity,alignment: .leading)
                                            
    //                                        Divider().frame(height:1)
    //                                            .overlay(Color.white)
                                            
                                        }
                                    }
                                    .background(selectTitle == category.categoryName ? Color.selectedColor : nil)

                                        
                                        
                                }
                                    
                            }
                        }
                        .padding(.top,30)
                        .frame(width:proxy.size.width * 0.3,height: UIScreen.main.bounds.height,alignment: .leading)
                        Spacer()
                        // Moviews List
                        VStack{
                            NavigationHeaderView(title: selectTitle) { text in
                                debugPrint(text)
                                
                                let filters = movies?.filter { $0.name!.localizedCaseInsensitiveContains(text)}
                                
                                self.movies = filters?.count ?? 0 > 0 ? filters : movies
                            } moreAction: { isSort in
                                if isSort {
                                    isSortPress.toggle()
                                }else{
                                    vm.isLoading.toggle()
                                    vm.fetchAllMovies()
                                        .sink { subError in
                                            vm.isLoading = false
                                        } receiveValue: { movies in
                                            vm.isLoading = false
                                            self.movies = movies
                                            
                                        }.store(in: &vm.subscriptions)
                                }
                                
                            }

                            CollectionGridView(movies: $movies, series: nil, view: subject.1)
                                .environmentObject(favMovies)
                        }
                        .frame(width:proxy.size.width * 0.7,height: UIScreen.main.bounds.height)
                        
                    }
                    .frame(maxWidth:.infinity,maxHeight: .infinity)
    //                .toast(isPresented: $vm.isLoading) {
    //                    ToastView("Loading...")
    //                            .toastViewStyle(.indeterminate)
    //                }
                }
                if isSortPress{
                    VStack(spacing:10){
                        
                        Button("Default", action: {
                            //selectSortText = "Default"
                            isSortPress.toggle()
                            vm.fetchAllMovies()
                                .sink { subError in
                                    vm.isLoading = false
                            } receiveValue: { movies in
                                vm.isLoading = false
                                
                                self.movies = movies
//                                        .sorted(by: {$0.added?.getDateWithTimeInterval().compare($1.added?.getDateWithTimeInterval() ?? Date()) == .orderedDescending })
                                
                            }.store(in: &vm.subscriptions)
                            
                        })
                        .foregroundColor(.black)
                        
                        Button("Recently Added", action: {
    //                        selectSortText = "Recently Added"
    //                        self.fetchCategories()
                            isSortPress.toggle()
                            vm.fetchAllMovies()
                                .sink { subError in
                                    vm.isLoading = false
                            } receiveValue: { movies in
                                vm.isLoading = false
                                
                                self.movies = movies

                                
                            }.store(in: &vm.subscriptions)
                        })
                        .foregroundColor(.black)
                        
                        Button("A-Z", action: {
                            isSortPress.toggle()
                            movies  =  movies?.sorted { $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? "" }
//                            subStreams = subStreams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                        })
                        .foregroundColor(.black)
                        
                        Button("Z-A", action: {
                            isSortPress.toggle()
                            movies  =  movies?.sorted { $0.name?.lowercased() ?? "" > $1.name?.lowercased() ?? "" }
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
            
            
            //.ignoresSafeArea(.keyboard,edges: .all)
        }
        .onAppear {
            
            vm.fetchAllMoviewCategories(type: subject.1)
                .sink { subError in
                //
            } receiveValue: { categories in
               
                self.categories = categories
                LocalStorgage.store.storeObject(array: categories, key: LocalStorageKeys.moviesCategories.rawValue)
                self.selectTitle = "ALL"
            }.store(in: &vm.subscriptions)
            
            


        }
        
        .onChange(of: self.categories) { newValue in
            vm.isLoading.toggle()
            vm.fetchAllMovies()
                .sink { subError in
                    vm.isLoading = false
            } receiveValue: { movies in
                vm.isLoading = false
                LocalStorgage.store.storeObject(array: movies, key: LocalStorageKeys.movies.rawValue)
                self.movies = movies
                
            }.store(in: &vm.subscriptions)
        }
        
        
    }
}


