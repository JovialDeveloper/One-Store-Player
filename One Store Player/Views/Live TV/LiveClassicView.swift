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
    
    var body: some View {
        ZStack {
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title: subject.0,isHideOptions: true) { text in
                      
                    filterStreams = streams.filter { $0.name.localizedCaseInsensitiveContains(text)
                        
                    }
                } moreAction: {
                    LocalStorgage.store.deleteObject(key: LocalStorageKeys.liveStreams.rawValue)
                    
                    self.fetchLiveStreams()
                }
                
                if !streams.isEmpty {
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
                                Text("")
                                    .font(.carioBold)
                                    .foregroundColor(.white)
                                
                                HStack{
                                    Button {
                                        vm.selectStream = streams[0]
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
                                Text("")
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
                            
                            ForEach(filterStreams != nil ? filterStreams! : streams) { item in
                                LiveRowCell(data: item)
                                    .onTapGesture {
                                        favStreams.removeAll()
                                        vm.selectStream = item
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
            let live : [LiveStreams] = LocalStorgage.store.getObject(key: LocalStorageKeys.liveStreams.rawValue)
            if live.count > 0 {
                streams = live
            }else {
                fetchLiveStreams()
            }
            
                
        }
        .fullScreenCover(isPresented: $isSelectItem) {
            if let item = vm.selectStream {
                if favStreams.count > 0 {
                    LiveTVDetailView(selectedStream: item, streams: favStreams, model: vm,isFavourite: true)
                }else{
                    
                    LiveTVDetailView(selectedStream: item, streams: streams, model: vm,isFavourite: false)
                }
                
            }
            
        }
        
    }
}

struct LiveTVDetailView:View {
    @State var selectedStream : LiveStreams
    let streams:[LiveStreams]
    let model:LiveStreamingViewModel
    var isFavourite = false
    @State private var selectedSort = "AZ"
    @State private var subStreams = [LiveStreams]()
    @State private var subFilterStreams : [LiveStreams]?
    @State private var isSearch = false
    @State private var selectSearchText = ""
    @State private var isFullScreen = false
    @Environment(\.presentationMode) private var mode
    private let playerModel = VLCMediaPlayer()
    private let playerFullModel = VLCMediaPlayer()
    @StateObject private var favLiveStreams = LiveStreamsFavourite()
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
                            if !isFavourite {
                                fetchSubStreams(stream: selectedStream)
                            }
                            
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
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading) {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image("arrow_back")
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .leading)
                            .foregroundColor(.white)
                    }
                    

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
