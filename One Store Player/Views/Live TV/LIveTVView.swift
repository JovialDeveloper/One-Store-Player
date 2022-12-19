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
                //https://onair7.xdevel.com/proxy/xautocloud_kpoh_1792?mp=/;1/
                //http://1player.cc:80/ec1RxLkPaWiHVy/ULaH9AmLRXDmBy7/27130.mp4
//                AVPlayerControllerRepresented(player: .init(url: .init(string: "http://1player.cc:80/ec1RxLkPaWiHVy/ULaH9AmLRXDmBy7/27130")!))
                
                VLCAgent(id: $selectId)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .onTapGesture {
                        isRemoveOverLay.toggle()
                    }
                
//                AVPlayerControllerRepresented(player: .init(playerItem: .init(url: .init(string: "http://1player.cc:80/ec1RxLkPaWiHVy/ULaH9AmLRXDmBy7/27131")!)))
//                    .frame(maxWidth: .infinity,maxHeight: .infinity)
//                    .onTapGesture {
//                        isRemoveOverLay.toggle()
//                    }
                    
                
            } else {
                // Fallback on earlier versions
            }
//                .overlay(overLayView)
            if !isRemoveOverLay {
                ScrollView{
                    overLayView
                }
                
                    //.frame(maxWidth: .infinity,maxHeight: .infinity)
            }
            
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
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.subStreams = livestreams
                self.selectId = livestreams[0].streamID
            }
            
        }.store(in: &vm.subscriptions)
    }
    
    var overLayView:some View{
        HStack{
//            Spacer(minLength: 80)
            HStack{
                //MARK:- Streams List
                ScrollView {
                    LazyVStack {
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
                        ForEach(streams) { stream in
                            Button {
                                //selectId = stream.categoryID
                                fetchSubStreams(stream: stream)
                            } label: {
                                HStack(spacing: 10){
                                    //                                    Image("play")
                                    //                                        .resizable()
                                    //                                        .frame(width: 30,height: 30)
                                    //                                        .scaledToFit()
                                    //                                        .clipped()
                                    //                                        .foregroundColor(.green)
                                    Text(stream.name)
                                        .font(.carioRegular)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth:.infinity,alignment: .leading)
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
                                        .padding()
                                        .frame(maxWidth:.infinity,alignment: .leading)
                                }
                                .padding()
                                .onTapGesture {
                                    self.selectId = stream.streamID
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
                                Text(stream.name)
                                    .font(.carioRegular)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                    .onTapGesture {
                                        self.selectId = stream.streamID
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
                    Menu("A-Z") {
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
}

struct LIveTVView_Previews: PreviewProvider {
    static var previews: some View {
        LIveTVView()
    }
}

import MobileVLCKit

struct VLCAgent:UIViewRepresentable{
    
    
    typealias UIViewType = UIView
    
    
    let player = VLCMediaPlayer()
    
    @Binding var id : Int
    var type = "live"
    func makeUIView(context: Context) -> UIView {
        let vlcView =  UIView()
        guard let url = URL(string:Networking.shared.getStreamingLink(id: id, type: type))
        else {
            return UIView()
        }
        
        player.media = VLCMedia(url: url)
        player.drawable = vlcView
        player.media?.addOption("-VV")
        player.media?.addOption("--networking-caching==1000")
        //player.media?.
        return vlcView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let url = URL(string: Networking.shared.getStreamingLink(id: id, type: "live"))
        else {
            return
        }
        player.media = VLCMedia(url: url)
        player.drawable = uiView
        //player.media?.addOption("-VV")
        player.media?.addOption("--networking-caching==1000")
        player.play()
    }
    
}

fileprivate struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
      
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player?.play()
    }
}
