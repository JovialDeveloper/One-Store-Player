//
//  ClassicLayoutView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI
import AlertToast

struct ClassicLayoutView: View {
    var subject : (String,ViewType)
    @StateObject private var vm = ClassicViewModel()
    @State private var categories = [MovieCategoriesModel]()
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title: subject.0)
                
                ClassicListGridView(data: $categories, subject: subject)
                    .environmentObject(vm)
                
            }
        }.onAppear {
            vm.fetchAllMoviewCategories(type: subject.1).sink { subError in
                //
            } receiveValue: { categories in
                self.categories = categories
            }.store(in: &vm.subscriptions)
            
            
            
            
        }
    }
}

struct ClassicListGridView:View{
    @State private var isSelectItem = false
    @Binding var data : [MovieCategoriesModel]
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var selectItem : MovieCategoriesModel?
    @EnvironmentObject private var vm:ClassicViewModel
    @State private var movies = [MovieModel]()
    var subject : (String,ViewType)
    var body: some View{
        ScrollView {
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
            if newValue != nil {
                vm.fetchAllMoviesById(id: newValue!.categoryID, type:subject.1)
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
                        
                        self.movies = movies
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            self.isSelectItem.toggle()
                        }
                        
                    }.store(in: &vm.subscriptions)

            }
            
        })
        .toast(isPresenting: $vm.isLoading) {
            AlertToast(displayMode: .alert, type: .loading)
        }
        .fullScreenCover(isPresented: $isSelectItem) {
            //
            ZStack{
                Color.primaryColor.ignoresSafeArea()
                VStack{
                    NavigationHeaderView(title: subject.0)
                    
                    CollectionGridView(data: $movies)
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

