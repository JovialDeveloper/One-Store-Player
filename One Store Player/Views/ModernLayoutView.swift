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
    var body: some View {
        GeometryReader{ proxy in
            ScrollView{
                HStack{
                    ScrollView{
                        Button("ALL") {
                            vm.isLoading.toggle()
                            vm.fetchAllMovies()
                                .sink { subError in
                                    vm.isLoading = false
                            } receiveValue: { movies in
                                vm.isLoading = false
                                
                                self.movies = movies.sorted(by: {$0.added?.getDateWithTimeInterval().compare($1.added?.getDateWithTimeInterval() ?? Date()) == .orderedDescending })
                                
                            }.store(in: &vm.subscriptions)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth:.infinity,alignment: .leading)
                        .background(selectTitle == "ALL" ? Color.yellow : nil)
                        
                        Divider().frame(height:1)
                            .overlay(Color.white)
                        
                        Button("Favourites") {
                            self.selectTitle = "Favourites"
                            self.movies = favMovies.getMovies()
                            self.subject = ("Favourites",.favourite)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth:.infinity,alignment: .leading)
                        .background(selectTitle == "Favourites" ? Color.yellow : nil)
                        Divider().frame(height:1)
                            .overlay(Color.white)
                        Button("Recently Watch") {
                            debugPrint(recentlyWatchMovies)
                            self.selectTitle = "Recently Watch"
                            self.movies = recentlyWatchMovies
                        }
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth:.infinity,alignment: .leading)
                        .background(selectTitle == "Recently Watch" ? Color.yellow : nil)
                        Divider().frame(height:1)
                            .overlay(Color.white)
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
                                            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
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
                                        
                                        Divider().frame(height:1)
                                            .overlay(Color.white)
                                        
                                    }
                                }
                                .background(selectTitle == category.categoryName ? Color.yellow : nil)

                                    
                                    
                            }
                                
                        }
                    }
                    .padding(.top,30)
                    .frame(width:proxy.size.width * 0.3,height: UIScreen.main.bounds.height,alignment: .leading)
                    Spacer()
                    // Moviews List
                    VStack{
                        NavigationHeaderView(title: subject.0) { text in
                            debugPrint(text)
                            
                            let filters = movies?.filter { $0.name!.localizedCaseInsensitiveContains(text)}
                            
                            self.movies = filters?.count ?? 0 > 0 ? filters : movies
                        } moreAction: {
                            vm.isLoading.toggle()
                            vm.fetchAllMovies()
                                .sink { subError in
                                    vm.isLoading = false
                                } receiveValue: { movies in
                                    vm.isLoading = false
                                    self.movies = movies
                                    
                                }.store(in: &vm.subscriptions)
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
            
            //.ignoresSafeArea(.keyboard,edges: .all)
        }
        .onAppear {
            
            vm.fetchAllMoviewCategories(type: subject.1)
                .sink { subError in
                //
            } receiveValue: { categories in
               
                self.categories = categories
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
                self.movies = movies
                
            }.store(in: &vm.subscriptions)
        }
        
        
    }
}


