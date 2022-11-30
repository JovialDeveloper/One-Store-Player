//
//  ModernLayoutView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import Foundation
import SwiftUI
import AlertToast

struct ModernLayoutView:View{
    @Environment(\.presentationMode) var presentationMode
    var subject : (String,ViewType)
    @StateObject private var vm = ModernLayoutViewModel()
    @State private var categories = [MovieCategoriesModel]()
    @State private var movies = [MovieModel]()
    var body: some View {
        ZStack{
            HStack{
                ScrollView{
                    LazyVStack{
                        ForEach(categories,id: \.categoryID) { category in
                            VStack{
                                Text(category.categoryName)
                                    .font(.carioRegular)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                
                                Divider().frame(height:1)
                                    .overlay(Color.white)
                                
                            }.onTapGesture {
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
                                            self.movies.removeAll()
                                            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                                                self.movies = movies
                                            }
                                            
                                        }.store(in: &vm.subscriptions)

                                }
                                
                                
                        }
                            
                    }
                }
                .padding(.top,30)
                .frame(width:UIScreen.main.bounds.width/3.5,height: UIScreen.main.bounds.height)
                Spacer()
                
                VStack{
                    NavigationHeaderView(title: subject.0)
                    CollectionGridView(data: $movies)
                }
            
                // Moviews List
                
                
            }
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .toast(isPresenting: $vm.isLoading) {
                AlertToast(displayMode: .alert, type: .loading)
            }
        }.onAppear {
            
            vm.fetchAllMoviewCategories(type: subject.1).sink { subError in
                //
            } receiveValue: { categories in
                self.categories = categories
                vm.fetchAllMoviesById(id: self.categories[0].categoryID, type: subject.1)
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
                        self.movies.removeAll()
                        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                            self.movies = movies
                        }
                        
                    }.store(in: &vm.subscriptions)
            }.store(in: &vm.subscriptions)
            
            


        }
    }
}


