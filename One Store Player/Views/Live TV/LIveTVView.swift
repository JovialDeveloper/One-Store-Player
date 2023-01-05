//
//  LIveTVView.swift
//  One Store Player
//
//  Created by MacBook Pro on 25/11/2022.
//

import SwiftUI
import AVKit
class LiveStreamsFavourite:ObservableObject
{
    func saveMovies(model:LiveStreams){
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favLiveStreams.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favLiveStreams = try decoder.decode([LiveStreams].self, from: data)
                
                if favLiveStreams.contains(where: {$0.streamID == model.streamID}) {
                    return
                }else{
                    favLiveStreams.append(model)
                    
                    let encoder = JSONEncoder()
                    // Encode Note
                    let modelData = try encoder.encode(favLiveStreams)
                    
                    UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favLiveStreams.rawValue)
                    
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
                UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favLiveStreams.rawValue)
            }
            catch {
                debugPrint(error)
            }
            
            //return model
        }
    }
    
    func getLiveStreams()->[LiveStreams]{
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favLiveStreams.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favLiveStreams = try decoder.decode([LiveStreams].self, from: data)
                
                return favLiveStreams
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }
            
        }
        return []
    }
}
struct LIveTVView: View {
    @State private var isRemoveOverLay = false
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var vm = LiveStreamingViewModel()
    @State private var streams = [LiveStreams]()
    @State private var subStreams = [LiveStreams]()
    @State private var selectId = 0
    @State private var searchText = ""
    @State private var isSearch = false
    @State private var selection  : Int?
    @State private var tvOSOptions = ["Default","Recently Added","A-Z","Z-A"]
    @StateObject private var favLiveStreams = LiveStreamsFavourite()
    fileprivate func fetchAllStreaming() {
        // Networking.shared.streamingURL()
        
        vm.fetchAllLiveStreaming().sink { SubscriberError in
            switch SubscriberError {
            case .failure(let error):
                debugPrint(error)
                break
            case .finished:
                break
            }
        } receiveValue: { livestreams in
            self.streams = livestreams
            self.fetchSubStreams(stream: livestreams[0])
        }.store(in: &vm.subscriptions)
    }
    
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            if #available(tvOS 16.0, *) {
//                AVPlayerControllerRepresented(player: .init(url: .init(string: "http://1player.cc:80/live/ec1RxLkPaWiHVy/ULaH9AmLRXDmBy7/27130")!))
                if selectId > 0 {
                   OneStorePlayer(id: $selectId)
                        .onTapGesture {
                            isRemoveOverLay.toggle()
                        }
                }
                
                
                if !isRemoveOverLay {
                    ScrollView{
                        HStack{
                            //            Spacer(minLength: 80)
                            HStack{
                                //MARK:- Streams List
                                ScrollView {
                                    LazyVStack {
                                        VStack{
                                            Button {
                                                selectId = 0
                                                self.streams.removeAll()
                                                fetchAllStreaming()
                                            } label: {
                                                Text("ALL")
                                                    .frame(maxWidth:.infinity,alignment: .leading)
                                            }
                                            .padding()
                                            .foregroundColor(.white)
                                            //.background(selectId == 0 ? Color.yellow : Color.secondaryColor)
                                            .frame(maxWidth:.infinity,alignment: .leading)
                                            
                                            Divider()
                                                .overlay(Color.white)
                                                .frame(maxWidth:.infinity,alignment: .leading)
                                        }
                                        
                                        VStack{
                                            Button {
                                                selectId = -0
                                                //                            self.streams.removeAll()
                                                //                            fetchAllStreaming()
                                                self.subStreams = favLiveStreams.getLiveStreams()
                                            } label: {
                                                Text("Favourites")
                                                    .frame(maxWidth:.infinity,alignment: .leading)
                                            }
                                            .padding()
                                            .foregroundColor(.white)
                                            //.background(selectId == -0 ? Color.yellow : Color.secondaryColor)
                                            .frame(maxWidth:.infinity,alignment: .leading)
                                            
                                            Divider()
                                                .overlay(Color.white)
                                                .frame(maxWidth:.infinity,alignment: .leading)
                                        }
                                        
                                        ForEach(streams) { stream in
                                            Button {
                                                //selectId = stream.categoryID
                                                fetchSubStreams(stream: stream)
                                            } label: {
                                                VStack{
                                                    Text(stream.name)
                                                        .font(.carioRegular)
                                                        .foregroundColor(.white)
                                                        .padding()
                                                        .frame(maxWidth:.infinity,alignment: .leading)
                                                        .lineLimit(0)
                                                        .minimumScaleFactor(0.5)
                                                    Divider().frame(height:1)
                                                        .overlay(Color.white)
                                                }
                                            }
                                            
                                            
                                        }
                                    }
                                    .background(Color.secondaryColor)
                                }
                                
                                //MARK:- SubStreams List
                                
                                ScrollView {
                                    LazyVStack {
                                        ForEach(subStreams) { stream in
                                            
                                            if selectId == stream.streamID {
                                                Button {
                                                    self.selectId = stream.streamID
                                                } label: {
                                                    VStack{
                                                        HStack(spacing: 10){
                                                            Image("play")
                                                                .resizable()
                                                                .frame(width: 20,height: 20)
                                                                .scaledToFit()
                                                                .clipped()
                                                                .foregroundColor(.green)
                                                            Text(stream.name)
                                                                .font(.carioRegular)
                                                                .foregroundColor(.white)
                                                
                                                                .frame(maxWidth:.infinity,alignment: .leading)
                                                                .lineLimit(0)
                                                                .minimumScaleFactor(0.5)
                                                        }
                                                        
                                                        Divider().frame(height:1)
                                                            .overlay(Color.white)
                                                    }
                                                    
                                                }
                                                .contextMenu {
                                                    Button {
                                                        favLiveStreams.saveMovies(model: stream)
                                                    } label: {
                                                        Label("Add to Favourite", systemImage: "suit.heart")
                                                    }
                                                    
                                                }
                                                
                                            }
                                            else{
                                                Button {
                                                    self.selectId = stream.streamID
                                                } label: {
                                                    VStack{
                                                        Text(stream.name)
                                                            .font(.carioRegular)
                                                            .foregroundColor(.white)
                                                            .padding()
                                                            .frame(maxWidth:.infinity,alignment: .leading)
                                                            .lineLimit(0)
                                                            .minimumScaleFactor(0.5)
                                                        Divider().frame(height:1)
                                                            .overlay(Color.white)
                                                    }
                                                    
                                                }
                                                .contextMenu {
                                                    Button {
                                                        favLiveStreams.saveMovies(model: stream)
                                                    } label: {
                                                        Label("Add to Favourite", systemImage: "suit.heart")
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                    .background(Color.secondaryColor)
                                }
                            }
                            .frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height)
                            .background(Color.secondaryColor)
                            
                            videoLayer
                            
                            
                            
                            
                            //                            VStack{
                            //                                HStack{
                            //                                    Button {
                            //                                        presentationMode.wrappedValue.dismiss()
                            //                                    } label: {
                            //                                        Image("arrow_back")
                            //                                            .resizable()
                            //                                            .frame(width: 30,height: 30)
                            //                                    }
                            //                                    if isSearch {
                            //                                        TextField("", text: $searchText,onCommit: {
                            //                                         let filterStreams = streams.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                            //                                            streams = filterStreams.count > 0 ? filterStreams : streams
                            //
                            //
                            //                                            let filterSubStreams = subStreams.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                            //                                               subStreams = filterSubStreams.count > 0 ? filterSubStreams : subStreams
                            //                                        })
                            //                                            .foregroundColor(.white)
                            //
                            //
                            //                                    }
                            //                                    Button {
                            //                                        isSearch.toggle()
                            //                                    } label: {
                            //                                        Image("search")
                            //                                            .resizable()
                            //                                            .frame(width: 30,height: 30)
                            //                                    }
                            //                                    Text("A-Z")
                            //                                        .font(.carioRegular)
                            //                                        .ContextMenu {
                            //                                        Button("Default", action: {})
                            //                                        Button("Recently Added", action: {})
                            //                                        Button("A-Z", action: {
                            //                                          streams  =  streams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                            //                                            subStreams = subStreams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                            //                                        })
                            //                                        Button("Z-A", action: {
                            //                                            streams  =  streams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                            //                                              subStreams = subStreams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                            //                                        })
                            //                                    }
                            //
                            //
                            ////                                    Menu("A-Z") {
                            ////                                        Button("Default", action: {})
                            ////                                        Button("Recently Added", action: {})
                            ////                                        Button("A-Z", action: {
                            ////                                          streams  =  streams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                            ////                                            subStreams = subStreams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                            ////                                        })
                            ////                                        Button("Z-A", action: {
                            ////                                            streams  =  streams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                            ////                                              subStreams = subStreams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                            ////                                        })
                            ////                                    }
                            //
                            //                                    Button {
                            //                                        fetchAllStreaming()
                            //                                    } label: {
                            //                                        Image("ic_update")
                            //                                            .resizable()
                            //                                            .frame(width: 30,height: 30)
                            //                                    }
                            //
                            //
                            //                                    Spacer()
                            //
                            //                                }
                            //                                .padding()
                            //
                            //                                Button {
                            //                                    isRemoveOverLay.toggle()
                            //                                } label: {
                            //                                    Text("")
                            //                                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                            //                                }
                            //                                //.frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height)
                            //                            }
                            //                            .foregroundColor(.white)
                            //                            .frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height)
                            
                        }
                    }
                }
                
            } else {
                // Fallback on earlier versions
            }
            
            
            
            
            
            
            
            //            if #available(tvOS 16.0, *) {
            //                //https://onair7.xdevel.com/proxy/xautocloud_kpoh_1792?mp=/;1/
            //                //http://1player.cc:80/ec1RxLkPaWiHVy/ULaH9AmLRXDmBy7/27130.mp4
            //                AVPlayerControllerRepresented(player: .init(url: .init(string: "http://1player.cc:80/live/ec1RxLkPaWiHVy/ULaH9AmLRXDmBy7/27130")!))
            //
            ////                VLCAgent(id: $selectId)
            ////                    .frame(maxWidth: .infinity,maxHeight: .infinity)
            ////                    .onTapGesture {
            ////                        isRemoveOverLay.toggle()
            ////                    }
            //
            ////                AVPlayerControllerRepresented(player: .init(playerItem: .init(url: .init(string: "http://1player.cc:80/ec1RxLkPaWiHVy/ULaH9AmLRXDmBy7/27131")!)))
            ////                    .frame(maxWidth: .infinity,maxHeight: .infinity)
            ////                    .onTapGesture {
            ////                        isRemoveOverLay.toggle()
            ////                    }
            //
            //
            //            } else {
            //
            //            }
            //                .overlay(overLayView)
            
            
        }.onAppear {
            fetchAllStreaming()
            
        }
    }
    
    fileprivate func fetchSubStreams(stream:LiveStreams) {
        vm.fetchAllSubStreamsInCategory(category: stream.categoryID).sink { SubscriberError in
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
                self.selectId = livestreams[0].streamID
            }
            
        }.store(in: &vm.subscriptions)
    }
    
    //    var overLayView:some View{
    //        return HStack{
    ////            Spacer(minLength: 80)
    //            HStack{
    //                //MARK:- Streams List
    //                ScrollView {
    //                    LazyVStack {
    //                        Button {
    //                            selectId = 0
    //                            self.streams.removeAll()
    //                            fetchAllStreaming()
    //                        } label: {
    //                            Text("ALL")
    //                                .frame(maxWidth:.infinity,alignment: .leading)
    //                        }
    //                        .padding()
    //                        .foregroundColor(.white)
    //                        //.background(selectId == 0 ? Color.yellow : Color.secondaryColor)
    //                        .frame(maxWidth:.infinity,alignment: .leading)
    //
    //
    //                        Button {
    //                            selectId = -0
    ////                            self.streams.removeAll()
    ////                            fetchAllStreaming()
    //                            self.subStreams = favLiveStreams.getLiveStreams()
    //                        } label: {
    //                            Text("Favourites")
    //                                .frame(maxWidth:.infinity,alignment: .leading)
    //                        }
    //                        .padding()
    //                        .foregroundColor(.white)
    //                        //.background(selectId == -0 ? Color.yellow : Color.secondaryColor)
    //                        .frame(maxWidth:.infinity,alignment: .leading)
    //                        ForEach(streams) { stream in
    //                            Button {
    //                                //selectId = stream.categoryID
    //                                fetchSubStreams(stream: stream)
    //                            } label: {
    //                                HStack(spacing: 10){
    //                                    //                                    Image("play")
    //                                    //                                        .resizable()
    //                                    //                                        .frame(width: 30,height: 30)
    //                                    //                                        .scaledToFit()
    //                                    //                                        .clipped()
    //                                    //                                        .foregroundColor(.green)
    //                                    Text(stream.name)
    //                                        .font(.carioRegular)
    //                                        .foregroundColor(.white)
    //                                        .padding()
    //                                        .frame(maxWidth:.infinity,alignment: .leading)
    //                                }
    //                            }
    //
    //
    //                        }
    //                    }
    //                    .background(Color.secondaryColor)
    //                }
    //
    //                //MARK:- SubStreams List
    //
    //                ScrollView {
    //                    LazyVStack {
    //                        ForEach(subStreams) { stream in
    //
    //                            if selectId == stream.streamID {
    //                                HStack(spacing: 10){
    //                                    Image("play")
    //                                        .resizable()
    //                                        .frame(width: 20,height: 20)
    //                                        .scaledToFit()
    //                                        .clipped()
    //                                        .foregroundColor(.green)
    //                                    Text(stream.name)
    //                                        .font(.carioRegular)
    //                                        .foregroundColor(.white)
    //                                        .padding()
    //                                        .frame(maxWidth:.infinity,alignment: .leading)
    //                                }
    //                                .padding()
    //                                .onTapGesture {
    //                                    self.selectId = stream.streamID
    //                                }
    //                                .contextMenu {
    //                                    Button {
    //                                        favLiveStreams.saveMovies(model: stream)
    //                                    } label: {
    //                                        Label("Add to Favourite", systemImage: "suit.heart")
    //                                    }
    //
    //                                }
    //                            }
    //                            else{
    //                                Text(stream.name)
    //                                    .font(.carioRegular)
    //                                    .foregroundColor(.white)
    //                                    .padding()
    //                                    .frame(maxWidth:.infinity,alignment: .leading)
    //                                    .onTapGesture {
    //                                        self.selectId = stream.streamID
    //                                    }
    //                                    .contextMenu {
    //                                        Button {
    //                                            favLiveStreams.saveMovies(model: stream)
    //                                        } label: {
    //                                            Label("Add to Favourite", systemImage: "suit.heart")
    //                                        }
    //
    //                                    }
    //                            }
    //
    //                        }
    //                    }
    //                    .background(Color.secondaryColor)
    //                }
    //            }
    //            .frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height)
    //            .background(Color.secondaryColor)
    //
    //
    //            VStack{
    //                HStack{
    //                    Button {
    //                        presentationMode.wrappedValue.dismiss()
    //                    } label: {
    //                        Image("arrow_back")
    //                            .resizable()
    //                            .frame(width: 30,height: 30)
    //                    }
    //                    if isSearch {
    //                        TextField("", text: $searchText,onCommit: {
    //                         let filterStreams = streams.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    //                            streams = filterStreams.count > 0 ? filterStreams : streams
    //
    //
    //                            let filterSubStreams = subStreams.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    //                               subStreams = filterSubStreams.count > 0 ? filterSubStreams : subStreams
    //                        })
    //                            .foregroundColor(.white)
    //
    //
    //                    }
    //                    Button {
    //                        isSearch.toggle()
    //                    } label: {
    //                        Image("search")
    //                            .resizable()
    //                            .frame(width: 30,height: 30)
    //                    }
    //                    Menu("A-Z") {
    //                        Button("Default", action: {})
    //                        Button("Recently Added", action: {})
    //                        Button("A-Z", action: {
    //                          streams  =  streams.sorted { $0.name.lowercased() < $1.name.lowercased() }
    //                            subStreams = subStreams.sorted { $0.name.lowercased() < $1.name.lowercased() }
    //                        })
    //                        Button("Z-A", action: {
    //                            streams  =  streams.sorted { $0.name.lowercased() > $1.name.lowercased() }
    //                              subStreams = subStreams.sorted { $0.name.lowercased() > $1.name.lowercased() }
    //                        })
    //                    }
    //
    //                    Button {
    //                        fetchAllStreaming()
    //                    } label: {
    //                        Image("ic_update")
    //                            .resizable()
    //                            .frame(width: 30,height: 30)
    //                    }
    //
    //
    //                    Spacer()
    //
    //                }
    //                .padding()
    //
    //                Button {
    //                    isRemoveOverLay.toggle()
    //                } label: {
    //                    Text("")
    //                        .frame(maxWidth: .infinity,maxHeight: .infinity)
    //                }
    //                //.frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height)
    //            }
    //
    //            .foregroundColor(.white)
    //            .frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height)
    //
    //        }
    //    }
    
    
    var videoLayer:some View{
        VStack{
            HStack{
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 30,height: 30)
                }
                if isSearch {
                    TextField("", text: $searchText,onCommit: {
                        let filterStreams = streams.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                        streams = filterStreams.count > 0 ? filterStreams : streams
                        
                        
                        let filterSubStreams = subStreams.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                        subStreams = filterSubStreams.count > 0 ? filterSubStreams : subStreams
                    })
                    .foregroundColor(.white)
                    
                    
                }
                Button {
                    isSearch.toggle()
                } label: {
                    Image("search")
                        .resizable()
                        .frame(width: 30,height: 30)
                }
                
                #if os(tvOS)
//                Picker("A-Z", selection: $selection) {
//                    ForEach(tvOSOptions, id: \.self) { item in
//                        Button {
//                            //
//                        } label: {
//                            Text(item)
//                                .font(.carioRegular)
//                        }
//
//                    }
//                }
//                .pickerStyle(.inline)
                
                #else
                Text("A-Z")
                    .font(.carioRegular)
                    .contextMenu {
                        Button("Default", action: {})
                        Button("Recently Added", action: {})
                        Button("A-Z", action: {
                            streams  =  streams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                            subStreams = subStreams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                        })
                        Button("Z-A", action: {
                            streams  =  streams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                            subStreams = subStreams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                        })
                    }
                #endif
                
                
                //                                    Menu("A-Z") {
                //                                        Button("Default", action: {})
                //                                        Button("Recently Added", action: {})
                //                                        Button("A-Z", action: {
                //                                          streams  =  streams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                //                                            subStreams = subStreams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                //                                        })
                //                                        Button("Z-A", action: {
                //                                            streams  =  streams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                //                                              subStreams = subStreams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                //                                        })
                //                                    }
                
                Button {
                    fetchAllStreaming()
                } label: {
                    Image("ic_update")
                        .resizable()
                        .frame(width: 30,height: 30)
                }
                
                
                Spacer()
                
            }
            .padding()
            
            Button {
                isRemoveOverLay.toggle()
            } label: {
                Text("")
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
            }
            //.frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height)
            
        }
        .foregroundColor(.white)
        .frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height)
    }
}

struct LIveTVView_Previews: PreviewProvider {
    static var previews: some View {
        LIveTVView()
    }
}


import IJKMediaFramework
//struct LivePlayerController:UIViewControllerRepresentable{
//    @Binding var id : Int
//    var type = "live"
//    func makeUIViewController(context: Context) -> IJKController {
//        let vc = IJKController(nibName: "IJKController", bundle: nil)
//        vc.id = id
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: IJKController, context: Context) {
//        uiViewController.id = id
//        uiViewController.updatePlayerId()
//    }
//
//    typealias UIViewControllerType = IJKController
//
//
//}

struct OneStorePlayer:UIViewRepresentable{

    @Binding var id : Int
    var type = "live"
    @State var playerView  =  UIView()
    func makeUIView(context: Context) -> UIView {
        //private var player : TinyVideoPlayer
        let view = UIView()
        guard let url = URL(string:Networking.shared.getStreamingLink(id: id, type: type))
        else {
            return view
        }
        let player = IJKFFMoviePlayerController(contentURL: url, with: IJKFFOptions.byDefault())!

        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        DispatchQueue.main.async {
            view.frame = player.view.bounds
            view.addSubview(player.view)
        }

        //player?.shouldAutoplay = true
        player.prepareToPlay()
        player.play()
        return view
    }

    func updateUIView(_ uiView:UIView, context: Context) {
        guard let url = URL(string:Networking.shared.getStreamingLink(id: id, type: type))
        else {
            return //UIView() as! TinyVideoProjectionView
        }
        let player = IJKFFMoviePlayerController(contentURL: url, with: IJKFFOptions.byDefault())!
        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        DispatchQueue.main.async {
            uiView.frame = player.view.bounds
            uiView.addSubview(player.view)
        }

        //player?.shouldAutoplay = true
        player.prepareToPlay()
        player.play()
        player.playbackVolume = 1
    }

    typealias UIViewType = UIView


}



struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    //var player : AVPlayer
    
    @Binding var id : Int
    var type = "live"
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        guard let url = URL(string:Networking.shared.getStreamingLink(id: id, type: type))
        else {
            return controller
        }
        controller.player = AVPlayer(url: url)
        
        //controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player?.play()
    }
}
