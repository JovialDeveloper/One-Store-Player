//
//  LiveClassicView.swift
//  One Store Player
//
//  Created by MacBook Pro on 14/03/2023.
//

import SwiftUI
import MobileVLCKit
import Kingfisher
struct LiveClassicView: View {
    var subject : (String,ViewType)
    @StateObject private var vm = LiveStreamingViewModel()
    @State private var streams = [LiveStreams]()
    @State private var categories = [MovieCategoriesModel]()
    @State private var favStreams = [LiveStreams]()
    @State private var filterStreams : [LiveStreams]?
    @StateObject private var favLiveStreams = LiveStreamsFavourite()
    @State private var isSelectItem = false
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    fileprivate func fetchLiveStreams() {
        vm.fetchAllLiveStreaming().sink { SubscriberError in
            switch SubscriberError {
            case .failure(let error):
                debugPrint(error)
                break
            case .finished:
                break
            }
        } receiveValue: { livestreams in
            self.filterStreams = nil
            let live : [LiveStreams] = LocalStorgage.store.getObject(key: LocalStorageKeys.liveStreams.rawValue)
            if live.isEmpty {
                LocalStorgage.store.storeObject(array: livestreams, key: LocalStorageKeys.liveStreams.rawValue)
            }
            
            self.streams = livestreams
        }.store(in: &vm.subscriptions)
    }
    
    fileprivate func fetchCategories()
    {
        vm.fetchAllCategories().sink { result in
            switch result {
            case .failure:
                break
            case .finished: break
            }
        } receiveValue: { categories in
            DispatchQueue.main.async {
                
                self.categories = categories
                    //.sorted { $0.categoryName.lowercased() < $1.categoryName.lowercased() }
                LocalStorgage.store.storeObject(array: categories, key: LocalStorageKeys.liveCategories.rawValue)
            }
        }.store(in: &vm.subscriptions)
        
    }
    
    var body: some View {
        ZStack {
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title: subject.0,isHideOptions: true) { text in
                    
                    filterStreams = streams.filter { $0.name.localizedCaseInsensitiveContains(text)
                        
                    }
                } moreAction: {
                    LocalStorgage.store.deleteObject(key: LocalStorageKeys.liveCategories.rawValue)
                    
                    self.fetchCategories()
                }
                
                if !categories.isEmpty {
                    ScrollView{
                        HStack{
                            HStack{
                                // Logo
                                Image("tv")
                                    .resizable()
                                    .frame(width:40,height: 40)
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                Spacer()
                                
                                Text("ALL")
                                    .font(.carioBold)
                                    .padding()
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                    .foregroundColor(.white)
                                Spacer()
                                
                                
                                
                                Spacer()
                                // Users Catalog
                                Text("\(streams.count)")
                                    .font(.carioBold)
                                    .foregroundColor(.white)
                                
                                HStack{
                                    Button {
                                        //                                        vm.selectCategory = streams[0]
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                            self.isSelectItem.toggle()
                                        }
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
                            .onAppear(perform: {
                                self.fetchLiveStreams()
                            })
                            .padding()
                            .frame(maxWidth:.infinity,maxHeight: 60)
                            .background(RoundedRectangle(cornerRadius: 2).fill(Color.secondaryColor))
                            .onTapGesture {
                                vm.selectStream = streams[0]
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                    self.isSelectItem.toggle()
                                }
                                
                                
                            }
                            
                            
                            HStack{
                                // Logo
                                Image("tv")
                                    .resizable()
                                    .frame(width:40,height: 40)
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                Spacer()
                                
                                Text("Favourites")
                                    .font(.carioBold)
                                    .padding()
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                    .foregroundColor(.white)
                                Spacer()
                                
                                
                                
                                Spacer()
                                // Users Catalog
                                Text("\(favLiveStreams.getLiveStreams().count)")
                                    .font(.carioBold)
                                    .foregroundColor(.white)
                                
                                HStack{
                                    Button {
                                        if favLiveStreams.getLiveStreams().count > 0 {
                                            favStreams = favLiveStreams.getLiveStreams()
                                            if !favStreams.isEmpty {
                                                vm.selectStream = favStreams[0]
                                                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                                    self.isSelectItem.toggle()
                                                }
                                            }
                                        }
                                        
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
                            .onTapGesture {
                                if favLiveStreams.getLiveStreams().count > 0 {
                                    
                                    favStreams = favLiveStreams.getLiveStreams()
                                    debugPrint("Items",favStreams.count,favStreams)
                                    
                                    if !favStreams.isEmpty {
                                        vm.selectStream = favStreams[0]
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                            self.isSelectItem.toggle()
                                        }
                                    }
                                }
                            }
                            
                        }
                        LazyVGrid(columns: columns, spacing: 10) {
                            
                            ForEach(categories,id: \.categoryID) { item in
                                LiveRowCell(data: item, model: vm)
                                    .onTapGesture {
                                        
                                        filterStreams = streams.filter({$0.categoryID == item.categoryID})
                                        favStreams.removeAll()
                                        vm.selectStream = filterStreams?[0]
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                            self.isSelectItem.toggle()
                                        }
                                        
                                        
                                    }
                            }
                            
                        }
                    }
                }else{
                    Spacer()
                }
                
                
                
                
            }
            
            
        }
        .onAppear {
            let live : [MovieCategoriesModel] = LocalStorgage.store.getObject(key: LocalStorageKeys.liveCategories.rawValue)
            if live.count > 0 {
                categories = live
                    //.sorted { $0.categoryName.lowercased() < $1.categoryName.lowercased() }
            }else {
                fetchCategories()
            }
            
            
        }
        
        .fullScreenCover(isPresented: $isSelectItem) {
            if let item = vm.selectStream {
                if favStreams.count > 0 {
                    LiveTVDetailView(selectedStream: item, streams: favStreams, model: vm,isFavourite: true)
                }else{
                    if !(filterStreams?.isEmpty ?? false) {
                        LiveTVDetailView(selectedStream: item, streams: filterStreams!, model: vm,isFavourite: false)
                    }
                    
                }
                
            }
            
        }
        
    }
}




fileprivate struct LiveRowCell:View{
    let data:MovieCategoriesModel
    @StateObject var model:LiveStreamingViewModel
    @State private var totalCount = 0
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
            Text("\(totalCount)")
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
        .onAppear(perform: {
            getTotalCount()
        })
        .padding()
        .frame(maxWidth:.infinity,maxHeight: 60)
        .background(RoundedRectangle(cornerRadius: 2).fill(Color.secondaryColor))
    }
    
    private func getTotalCount(){
        if let value : Int = LocalStorgage.store.getSingleObject(key: data.categoryName) {
            self.totalCount = value
        }else{
            fetchSubStreams(stream: data)
        }
    }
    fileprivate func fetchSubStreams(stream:MovieCategoriesModel) {
        model.fetchAllSubStreamsInCategory(category: stream.categoryID).sink { SubscriberError in
            switch SubscriberError {
            case .failure(let error):
                debugPrint(error)
                break
            case .finished:
                break
            }
        } receiveValue: { livestreams in
            DispatchQueue.main.async {
                self.totalCount = livestreams.count
                LocalStorgage.store.storeSingleObject(array: livestreams.count, key: data.categoryName)
            }
            
        }.store(in: &model.subscriptions)
        
    }
}


