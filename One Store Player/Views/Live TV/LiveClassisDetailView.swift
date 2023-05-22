//
//  LiveClassisDetailView.swift
//  One Store Player
//
//  Created by MacBook Pro on 22/05/2023.
//

import Foundation
import SwiftUI
import Kingfisher
import MobileVLCKit
struct LiveTVDetailView:View {
    @State var selectedStream : LiveStreams
    @State var streams:[LiveStreams]
    let model:LiveStreamingViewModel
    var isFavourite = false
    @State private var selectedSort = "AZ"
    @State private var subStreams = [LiveStreams]()
    @State private var subFilterStreams : [LiveStreams]?
    @State private var isSearch = false
    @State private var selectSearchText = ""
    @State private var isFullScreen = false
    @State private var currentIndex = 0
    @Environment(\.presentationMode) private var mode
    private let playerModel = VLCMediaPlayer()
    @AppStorage(AppStorageKeys.timeFormatt.rawValue) var formatte = hour_12
    private let playerFullModel = VLCMediaPlayer()
    @StateObject private var favLiveStreams = LiveStreamsFavourite()
    var body: some View{
        
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            GeometryReader {
                proxy in
                VStack{
                    HStack{
                        Button {
                            mode.wrappedValue.dismiss()
                        } label: {
                            Image("arrow_back")
                                .resizable()
                                .frame(width: 24, height: 24, alignment: .leading)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        if #available(iOS 15.0, *) {
                            
                            Text("\(Date().description.getDateFormatted(format:defualtDateFormatte)) \(Date().getTime(format: formatte))")
                                .font(.carioRegular)
                                .foregroundColor(.white)
                        } else {
                            // Fallback on earlier versions
                            Text("\(Date().description) \(Date().getTime(format: formatte))")
                                .font(.carioRegular)
                                .foregroundColor(.white)
                        }
                        
                        if isSearch {
                            VStack{
                                TextField("Search", text: $selectSearchText)
                                    
                                    .foregroundColor(.white)
                                Divider().overlay(Color.white)
                            }
                        }
                        
                        Button {
                            isSearch.toggle()
                        } label: {
                            Image("search")
                        }
                        .foregroundColor(.white)
                        
                        Menu(selectedSort) {
                            Button("Default", action: {
                                selectedSort = "Default"
                                subFilterStreams = nil
                                //self.fetchCategories()
                            })
                            Button("Recently Added", action: {
                                selectedSort = "Recently Added"
                                subFilterStreams = nil
                                //self.fetchCategories()
                            })
                            Button("A-Z", action: {
                                selectedSort = "A-Z"
                                subFilterStreams  =  streams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                                
                            })
                            Button("Z-A", action: {
                                selectedSort = "Z-A"
                                subFilterStreams  =  streams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                                
                            })
                            
                        }.foregroundColor(.white)
                        
                        
                    }
                    .onChange(of: selectSearchText) { newValue in
                        if streams.filter({$0.name == newValue}).count > 0
                        {
                            subFilterStreams = streams.filter({$0.name == newValue})
                        }
                        else {
                            subFilterStreams = nil
                        }
                        
                    }
                    
                    HStack{
                        // Live Stream List
                        VStack{
                            // Stream Live Header
                            HStack{
                                Button(action: {
                                    if currentIndex <= 0 {
                                        currentIndex = 0
                                        selectedStream = streams[currentIndex]
                                    }else {
                                        currentIndex -= 1
                                        selectedStream = streams[currentIndex]
                                    }
                                    //let index = Int.random(in: 0..<streams.count)
                                    
                                    //self.fetchSubStreams(stream: streams[index])
                                }) {
                                    Image("arrow_back")
                                    //                                        .resizable()
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                
                                Text(selectedStream.name)
                                    .font(.carioRegular)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    if currentIndex <= streams.count - 1 {
                                        currentIndex += 1
                                        selectedStream = streams[currentIndex]
                                        
                                    }else {
                                        currentIndex = 0
                                        selectedStream = streams[currentIndex]
                                    }
                                }) {
                                    Image("arrow_right")
                                    //                                        .resizable()
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height:46)
                            if isFavourite {
                                ScrollView {
                                    ForEach(subFilterStreams != nil ? subFilterStreams! : streams) { stream in
                                        HStack{
                                            if selectedStream.id == stream.id {
                                                Image("pause_exo")
                                                    .resizable()
                                                    .frame(width:40)
                                                    .scaledToFill()
                                                    .foregroundColor(.green)
                                                
                                            }
                                            else{
                                                Spacer().frame(width:40)
                                            }
                                            
                                            Text("\(stream.streamID)".replacingOccurrences(of: ",", with: ""))
                                                .frame(width:80)
                                                .font(.carioRegular)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                            
                                            Spacer().frame(width:20)
                                            
                                            KFImage(URL.init(string: stream.streamIcon))
                                                .placeholder {
                                                    Image("Icon")
                                                        .resizable()
                                                        .frame(width:80,height: 50)
                                                        .scaledToFit()
                                                }
                                                .resizable()
                                                .frame(width:80,height: 50)
                                                .scaledToFit()
                                            //.clipShape(Rectangle().fill())
                                            
                                            Spacer().frame(width:20)
                                            
                                            Text(stream.name)
                                            //.frame(width:80)
                                                .font(.carioRegular)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                            
                                            Spacer()
                                        }
                                        .frame(width:proxy.size.width * 0.5,height:70)
                                        .background(selectedStream.streamID == stream.streamID ? Color.selectedColor : Color.secondaryColor)
                                        .onTapGesture {
                                            selectedStream = stream
                                        }
                                        .contextMenu {
                                            Button {
                                                                                                if favLiveStreams.findItem(model: stream) {
                                                                                                    // remove from fav
                                                                                                    favLiveStreams.deleteObject(model: stream)
                                                                                                }
                                                                                                else {
                                                                                                    favLiveStreams.saveMovies(model: stream)
                                                                                                }
                                                
                                            } label: {
                                                if favLiveStreams.findItem(model: stream) {
                                                    Text("Remove from Favourite")
                                                }else{
                                                    Text("Add to Favourite")
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }else{
                                ScrollView {
                                    ForEach(subFilterStreams != nil ? subFilterStreams! : subStreams) { stream in
                                        HStack{
                                            if selectedStream.id == stream.id {
                                                Image("pause_exo")
                                                    .resizable()
                                                    .frame(width:40)
                                                    .scaledToFill()
                                                    .foregroundColor(.green)
                                                
                                            }
                                            else{
                                                Spacer().frame(width:40)
                                            }
                                            
                                            Text("\(stream.streamID)".replacingOccurrences(of: ",", with: ""))
                                            //                                                .frame(width:40)
                                                .font(.carioRegular)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                            
                                            Spacer().frame(width:20)
                                            
                                            KFImage(URL.init(string: stream.streamIcon))
                                                .placeholder {
                                                    Image("Icon")
                                                        .resizable()
                                                        .frame(width:80,height: 50)
                                                        .scaledToFit()
                                                }
                                                .resizable()
                                                .frame(width:80,height: 50)
                                                .scaledToFit()
                                            //.clipShape(Rectangle().fill())
                                            
                                            Spacer().frame(width:20)
                                            
                                            Text(stream.name)
                                            //.frame(width:80)
                                                .font(.carioRegular)
                                            //                                                .lineLimit(1)
                                            //                                                .minimumScaleFactor(0.5)
                                            
                                            Spacer()
                                        }
                                        .frame(width:proxy.size.width * 0.5,height:70)
                                        .background(selectedStream.streamID == stream.streamID ? Color.selectedColor : Color.secondaryColor)
                                        .onTapGesture {
                                            let index = streams.firstIndex(where: {$0.categoryID == stream.categoryID})
                                            currentIndex = index ?? 0
                                            selectedStream = stream
                                        }
                                        .contextMenu {
                                            Button {
                                                if favLiveStreams.findItem(model: stream) {
                                                    // remove from fav
                                                    favLiveStreams.deleteObject(model: stream)
                                                }
                                                else {
                                                    favLiveStreams.saveMovies(model: stream)
                                                }
                                                
                                            } label: {
                                                if favLiveStreams.findItem(model: stream) {
                                                    Text("Remove from Favourite")
                                                }else{
                                                    Text("Add to Favourite")
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            // Streams List
                            
                            
                        }
                        .frame(width: proxy.size.width * 0.5)
                        .onAppear {
                            self.subStreams = streams
                            //                            if !isFavourite {
                            //                                fetchSubStreams(stream: selectedStream)
                            //                            }
                            
                        }
                        
                        VStack{
                            
                            
                            if (UIDevice.current.userInterfaceIdiom == .pad)
                            {
                                MyDemoView(link: Networking.shared.getStreamingLink(id: selectedStream.streamID, type: "live"), player: playerModel)
                                    .frame(maxWidth: .infinity,maxHeight:.infinity)
                                    .onTapGesture {
                                        playerModel.pause()
                                        isFullScreen.toggle()
                                    }
                                    .onReceive(NotificationCenter.Publisher(center: .default, name: .resumePlaying)) { _ in
                                        playerModel.play()
                                    }
                                Spacer()
                                
                            } else {
                                MyDemoView(link: Networking.shared.getStreamingLink(id: selectedStream.streamID, type: "live"), player: playerModel)
                                    .frame(height: 200)
                                    .onTapGesture {
                                        playerModel.pause()
                                        isFullScreen.toggle()
                                    }
                                    .onReceive(NotificationCenter.Publisher(center: .default, name: .resumePlaying)) { _ in
                                        playerModel.play()
                                    }
                                Spacer()
                            }
                        }
                        
                        
                    }
                    .fullScreenCover(isPresented: $isFullScreen) {
                        ZStack{
                            Color.primaryColor.ignoresSafeArea()
                            VStack{
                                HStack{
                                    Button(action: {
                                        isFullScreen.toggle()
                                    }, label: {
                                        Image("arrow_back")
                                            .resizable()
                                            .frame(width: 24, height: 30, alignment: .leading)
                                            .clipped()
                                            .foregroundColor(.white)
                                    })
                                    
                                    Spacer()
                                }
                                
                                MyDemoView(link: Networking.shared.getStreamingLink(id: selectedStream.streamID, type: "live"), player: playerFullModel)
                                    .frame(maxWidth: .infinity,maxHeight:.infinity)
                                    .ignoresSafeArea()
                            }
                            
                            
                            
                        }
                        
                        
                    }
                }
                
            }
            
        }
        
        
        
    }
    
    
    //    fileprivate func fetchSubStreams(stream:LiveStreams) {
    //        model.fetchAllSubStreamsInCategory(category: stream.categoryID).sink { SubscriberError in
    //            switch SubscriberError {
    //            case .failure(let error):
    //                debugPrint(error)
    //                break
    //            case .finished:
    //                break
    //            }
    //        } receiveValue: { livestreams in
    //            self.subStreams.removeAll()
    //            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
    //                self.subStreams = livestreams
    //                selectedStream = livestreams[0]
    //                //self.selectId = livestreams[0].streamID
    //            }
    //
    //        }.store(in: &model.subscriptions)
    //    }
}



