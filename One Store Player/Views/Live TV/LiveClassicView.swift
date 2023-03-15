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
    @State private var filterStreams : [LiveStreams]?
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
            self.streams = livestreams
        }.store(in: &vm.subscriptions)
    }
    
    var body: some View {
        ZStack {
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title: subject.0) { text in
                      
                    filterStreams = streams.filter { $0.name.localizedCaseInsensitiveContains(text)
                        
                    }
                } moreAction: {
                    self.fetchLiveStreams()
                }
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(filterStreams != nil ? filterStreams! : streams) { item in
                            LiveRowCell(data: item)
                                .onTapGesture {
                                    vm.selectStream = item
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                        self.isSelectItem.toggle()
                                    }
                                }
                        }
                        
                    }
                }
                
               
            }
            
            
        }
        .onAppear {
            fetchLiveStreams()
                
        }
        .fullScreenCover(isPresented: $isSelectItem) {
            if let item = vm.selectStream {
                LiveTVDetailView(selectedStream: item, streams: streams, model: vm)
            }
            
        }
        
    }
}

struct LiveTVDetailView:View {
    @State var selectedStream : LiveStreams
    let streams:[LiveStreams]
    let model:LiveStreamingViewModel
    
    @State private var selectedSort = "AZ"
    @State private var subStreams = [LiveStreams]()
    @State private var subFilterStreams : [LiveStreams]?
    @State private var isSearch = false
    @State private var selectSearchText = ""
    @State private var isFullScreen = false
    @Environment(\.presentationMode) private var mode
    private let playerModel = VLCMediaPlayer()
    private let playerFullModel = VLCMediaPlayer()
    var body: some View{
        NavigationView{
            ZStack{
                Color.primaryColor.ignoresSafeArea()
                GeometryReader {
                    proxy in
                    HStack{
                        // Live Stream List
                        VStack{
                            // Stream Live Header
                            HStack{
                                Button(action: {
                                    let index = Int.random(in: 0..<streams.count)
                                    self.fetchSubStreams(stream: streams[index])
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
                                    let index = Int.random(in: 0..<streams.count)
                                    self.fetchSubStreams(stream: streams[index])
                                }) {
                                    Image("arrow_right")
        //                                        .resizable()
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height:46)
                            
                            // Streams List
                            ScrollView {
                                ForEach(subFilterStreams != nil ? subFilterStreams! : subStreams) { stream in
                                    HStack(spacing:10){
                                        Image("pause_exo")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.green)
                                        Spacer()
                                        
                                        Text(stream.streamType.rawValue)
                                            .font(.carioRegular)
                                        Spacer()
                                        if let url = URL.init(string: stream.streamIcon) {
                                            KFImage(url)
                                                .placeholder {
                                                    Image("Icon")
                                                        .resizable()
                                                        .scaledToFit()
                                                }
                                                .resizable()
                                                .frame(width:50,height: 50)
                                                .scaledToFill()
                                        }
                                        
                                            //.clipped()
                                        Text(stream.name)
                                            .font(.carioRegular)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(width:proxy.size.width * 0.4,height:70)
                                    .background(Color.secondaryColor)
                                    .onTapGesture {
                                        selectedStream = stream
                                    }
                                }
                            }
                            
                        }
                        .frame(width: proxy.size.width * 0.5)
                        .onAppear {
                            fetchSubStreams(stream: selectedStream)
                        }
                        
                        MyDemoView(link: Networking.shared.getStreamingLink(id: selectedStream.streamID, type: "live"), player: playerModel)
                            .frame(height: 200)
                            .onTapGesture {
                                playerModel.pause()
                                isFullScreen.toggle()
                            }
                            .onReceive(NotificationCenter.Publisher(center: .default, name: .resumePlaying)) { _ in
                                playerModel.play()
                            }

                        
                    }
                    .fullScreenCover(isPresented: $isFullScreen) {
                        NavigationView{
                            ZStack{
                                Color.primaryColor.ignoresSafeArea()
                                MyDemoView(link: Networking.shared.getStreamingLink(id: selectedStream.streamID, type: "live"), player: playerFullModel)
                                    .ignoresSafeArea()
                                   
                            }
                            .toolbar {
                                ToolbarItem(placement:.navigationBarLeading) {
                                    Button(action: {
                                        NotificationCenter.default.post(name: .resumePlaying, object: self)
                                        playerFullModel.stop()
                                        isFullScreen.toggle()
                                    }) {
                                        Image("arrow_back")
                                            .resizable()
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            
                        }

                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading) {
                    Button(action: {
                        playerModel.stop()
                        mode.wrappedValue.dismiss()
                    }) {
                        Image("arrow_back")
                            .resizable()
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement:.navigationBarTrailing) {
                    if #available(iOS 15.0, *) {
                        HStack{
                            Text(Date().formatted(date: .numeric, time: .shortened))
                                .foregroundColor(.white)
                            if isSearch {
                                TextField("", text: $selectSearchText,onCommit: {
                                    let filterStreams = subStreams.filter { $0.name.localizedCaseInsensitiveContains(selectSearchText) }
                                    subStreams = filterStreams.count > 0 ? filterStreams : subStreams
                                    isSearch.toggle()
                                })
                                .foregroundColor(.white)
                                
                                
                            }
                            Button(action: {
                                isSearch.toggle()
                            }) {
                                Image("search")
                                    .resizable()
                                    .foregroundColor(.white)
                            }
                            
                            Menu(selectedSort) {
                                Button("Default", action: {
                                    selectedSort = "Default"
                                    self.fetchSubStreams(stream: selectedStream)
                                })
                                Button("Recently Added", action: {
                                    selectedSort = "Recently Added"
                                   self.fetchSubStreams(stream: selectedStream)
                                })
                                Button("A-Z", action: {
                                    selectedSort = "A-Z"

                                    subFilterStreams = subStreams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                                })
                                Button("Z-A", action: {
                                    selectedSort = "Z-A"

                                    subFilterStreams = subStreams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                                })
                                
                            }.foregroundColor(.white)
                        }
                        
                    } else {
                        // Fallback on earlier versions
                        Text("")
                    }
                    
    //                    Button(action: {}) {
    //                        Image("arrow_back")
    //                            .resizable()
    //                            .foregroundColor(.white)
    //                    }
                }
                
            }
            
        }
       
        
    }
    
    
    fileprivate func fetchSubStreams(stream:LiveStreams) {
        model.fetchAllSubStreamsInCategory(category: stream.categoryID).sink { SubscriberError in
            switch SubscriberError {
            case .failure(let error):
                debugPrint(error)
                break
            case .finished:
                break
            }
        } receiveValue: { livestreams in
            self.subStreams.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.subStreams = livestreams
                selectedStream = livestreams[0]
                //self.selectId = livestreams[0].streamID
            }
            
        }.store(in: &model.subscriptions)
    }
}

//struct LiveClassicView_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(iOS 15.0, *) {
//            LiveTVDetailView(selectedStream: .init(num: 1, name: "New Link", streamType: .live, streamID: 1, streamIcon: "", epgChannelID: "", added: "", categoryID: "", customSid: "", tvArchive: 1, directSource: "", tvArchiveDuration: 1), streams: [])
//                .previewInterfaceOrientation(.landscapeLeft)
////            LiveClassicView(subject: ("Live TV",ViewType.liveTV))
////                .previewInterfaceOrientation(.landscapeLeft)
//        } else {
//            // Fallback on earlier versions
//            //LiveClassicView(subject: ("Live TV",ViewType.liveTV))
//        }
//    }
//}


fileprivate struct LiveRowCell:View{
    let data:LiveStreams
    var body: some View{
        HStack{
            // Logo
            Image("tv")
                .resizable()
                .frame(width:40,height: 40)
                .scaledToFill()
                .foregroundColor(.white)
            Spacer()
            
            Text(data.name)
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
