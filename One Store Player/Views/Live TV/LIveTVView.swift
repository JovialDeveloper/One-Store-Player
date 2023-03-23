//
//  LIveTVView.swift
//  One Store Player
//
//  Created by MacBook Pro on 25/11/2022.
//

import SwiftUI
import ToastUI
import MobileVLCKit
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
    
    @State private var filterStreams : [LiveStreams]?
    @State private var filterSubStreams : [LiveStreams]?
    
    @State private var selectId = 0
    @State private var searchText = ""
    @State private var selectSortText = "A-Z"
    @State private var isSearch = false
    @State private var selection  : Int?
    @State private var tvOSOptions = ["Default","Recently Added","A-Z","Z-A"]
    @StateObject private var favLiveStreams = LiveStreamsFavourite()
    @State private var selectTitle = ""
    @State private var sLink : String?
    private var playerViewModel = VLCMediaPlayer()
    @AppStorage(AppStorageKeys.layout.rawValue) var layout: AppKeys.RawValue = AppKeys.classic.rawValue
    fileprivate func fetchAllStreaming() {
        vm.isLoading.toggle()
        vm.fetchAllLiveStreaming().sink { SubscriberError in
            switch SubscriberError {
            case .failure(let error):
                debugPrint(error)
                vm.isLoading = false
                break
            case .finished:
                vm.isLoading = false
                break
            }
        } receiveValue: { livestreams in
            self.filterStreams = nil
            self.streams = livestreams
            selectTitle = "ALL"
            self.fetchSubStreams(stream: livestreams[0])
            vm.isLoading = false
        }.store(in: &vm.subscriptions)
    }
    
    var body: some View {
        if layout == AppKeys.modern.rawValue {
            ZStack{
                Color.primaryColor.ignoresSafeArea()
                if selectId > 0, let link = sLink{
                    MyDemoView(link:link, player:playerViewModel)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isRemoveOverLay.toggle()
                        }
                }
                

                if !isRemoveOverLay {
                    GeometryReader {
                        proxy in
                        HStack{
                            //            Spacer(minLength: 80)
                            HStack(spacing:5){
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

                                            .frame(maxWidth:.infinity,alignment: .leading)
                                            .background(selectTitle == "ALL" ? Color.selectedColor : nil)

                                            Divider()
                                                .overlay(Color.white)
                                                .frame(maxWidth:.infinity,alignment: .leading)
                                        }

                                        VStack{
                                            Button {
                                                self.selectTitle = "Favourites"
                                                selectId = -0
                                                self.subStreams = favLiveStreams.getLiveStreams()
                                            } label: {
                                                Text("Favourites")
                                                    .frame(maxWidth:.infinity,alignment: .leading)
                                            }
                                            .padding()
                                            .foregroundColor(.white)

                                            .frame(maxWidth:.infinity,alignment: .leading)
                                            .background(selectTitle == "Favourites" ? Color.selectedColor : nil)

                                            Divider()
                                                .overlay(Color.white)
                                                .frame(maxWidth:.infinity,alignment: .leading)
                                        }

                                        ForEach(streams) { stream in
                                            Button {
                                                //selectId = stream.categoryID
                                                self.selectTitle = stream.name
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
                                            .background(selectTitle == stream.name ? Color.selectedColor : nil)


                                        }
                                    }
                                    .background(Color.black.opacity(0.5))
                                }

                                //MARK:- SubStreams List
                                ScrollView {
                                    LazyVStack {
                                        ForEach(subStreams) { stream in

                                            if selectId == stream.streamID {
                                                Button {
                                                    self.selectTitle = stream.name
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
                                                .padding()
                                                .background(selectTitle == stream.name ? Color.selectedColor : nil)
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
                                                    self.selectTitle = stream.name
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
                                                .background(selectTitle == stream.name ? Color.selectedColor : nil)
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
                                    .background(Color.black.opacity(0.5))
                                }
                            }
                            .frame(width:proxy.size.width * 0.5,height: proxy.size.height)
                            .background(Color.black.opacity(0.5))
                            .onChange(of: selectId) { newValue in
                                sLink = linkLive(id: selectId, type: "live")
                                
                            }

                            videoLayer
                        }
                    }
                    .toast(isPresented: $vm.isLoading) {
                        ToastView("Loading...")
                                .toastViewStyle(.indeterminate)
                    }
                }
     
                
            }
            .onAppear {
                fetchAllStreaming()
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
           
        }
        else {
            LiveClassicView(subject: ("Live TV", ViewType.liveTV))
        }
   
        
    }
    
    func linkLive(id:Int,type:String) -> String {
        return Networking.shared.getStreamingLink(id: id, type: type)
    }
    
    var ovarlayView:some View
    {
        GeometryReader {
            proxy in
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
                                    
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                    .background(selectTitle == "ALL" ? Color.selectedColor : nil)
                                    
                                    Divider()
                                        .overlay(Color.white)
                                        .frame(maxWidth:.infinity,alignment: .leading)
                                }
                                
                                VStack{
                                    Button {
                                        self.selectTitle = "Favourites"
                                        selectId = -0
                                        self.subStreams = favLiveStreams.getLiveStreams()
                                    } label: {
                                        Text("Favourites")
                                            .frame(maxWidth:.infinity,alignment: .leading)
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                 
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                    .background(selectTitle == "Favourites" ? Color.selectedColor : nil)
                                    
                                    Divider()
                                        .overlay(Color.white)
                                        .frame(maxWidth:.infinity,alignment: .leading)
                                }
                                
                                ForEach(filterStreams != nil ? filterStreams! : streams) { stream in
                                    Button {
                                        //selectId = stream.categoryID
                                        self.selectTitle = stream.name
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
                                    .background(selectTitle == stream.name ? Color.selectedColor : nil)
                                    
                                    
                                }
                            }
                            .background(Color.black.opacity(0.5))
                        }
                        
                        //MARK:- SubStreams List
                        
                        ScrollView {
                            LazyVStack {
                                ForEach(filterSubStreams != nil ? filterSubStreams! : subStreams) { stream in
                                    
                                    if selectId == stream.streamID {
                                        Button {
                                            self.selectTitle = stream.name
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
                                        .padding()
                                        .background(selectTitle == stream.name ? Color.selectedColor : nil)
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
                                            self.selectTitle = stream.name
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
                                        .background(selectTitle == stream.name ? Color.selectedColor : nil)
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
                            .background(Color.black.opacity(0.5))
                        }
                    }
                    .frame(width:proxy.size.width * 0.5,height: proxy.size.height)
                    .background(Color.black.opacity(0.5))
                    .onChange(of: selectId) { newValue in
                        sLink = linkLive(id: selectId, type: "live")
                        debugPrint("Live Link",sLink)
                    }
                    
                    videoLayer
                }
            }
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
            self.filterSubStreams = nil
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.subStreams = livestreams
                self.selectId = livestreams[0].streamID
            }
            
        }.store(in: &vm.subscriptions)
    }
    
    var videoLayer:some View{
        VStack{
            HStack{
                Button {
                    playerViewModel.stop()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 30,height: 30)
                }
                if isSearch {
                    CustomTextField(searchText: $searchText, isSeachFieldHide: $isSearch) { text in
                
                        self.filterStreams = streams.filter {
                            $0.name.contains(text)
//                            $0.name.lowercased().range(of: text.lowercased(),options: .caseInsensitive) != nil
//
                        }
                        
                        
                       
                        self.filterSubStreams = subStreams.filter {
                            $0.name.contains(text)
//                            $0.name.lowercased().range(of: text.lowercased(),options: .caseInsensitive) != nil
                            
                        }
                        
                        
                    }
                    
                }
                Button {
                    isSearch.toggle()
                } label: {
                    Image("search")
                        .resizable()
                        .frame(width: 30,height: 30)
                }
                
                #if os(tvOS)
                
                // TV OS
                
                #else
                Menu(selectSortText) {
                    Button("Default", action: {
                        selectSortText = "Default"
                        self.fetchAllStreaming()
                    })
                    Button("Recently Added", action: {
                        selectSortText = "Recently Added"
                        self.fetchAllStreaming()
                    })
                    Button("A-Z", action: {
                        selectSortText = "A-Z"
                        streams  =  streams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                        subStreams = subStreams.sorted { $0.name.lowercased() < $1.name.lowercased() }
                    })
                    Button("Z-A", action: {
                        selectSortText = "Z-A"
                        streams  =  streams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                        subStreams = subStreams.sorted { $0.name.lowercased() > $1.name.lowercased() }
                    })
                    
                }.foregroundColor(.white)
                #endif
                
                
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



struct MyDemoView:UIViewRepresentable {
    var link:String
   var player : VLCMediaPlayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
//        player.drawable = view
//        player.media = VLCMedia(url: .init(string: link)!)
        player.delegate = context.coordinator
        //player.play()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        player.stop()
        player.drawable = uiView
        player.media = VLCMedia(url: .init(string: link)!)
        player.play()
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    class Coordinator:NSObject,VLCMediaPlayerDelegate {
        
        func mediaPlayerStateChanged(_ aNotification: Notification) {
            guard let videoPlayer = aNotification.object as? VLCMediaPlayer else {return}
            switch videoPlayer.state{
            case .playing:
                print("VLCMediaPlayerDelegate: PLAYING")
                
            case .opening:
                print("VLCMediaPlayerDelegate: OPENING")
                
            case .error:
                print("VLCMediaPlayerDelegate: ERROR")

            case .buffering:
                print("VLCMediaPlayerDelegate: BUFFERING")
                
            case .stopped:
                print("VLCMediaPlayerDelegate: STOPPED")
                
            case .paused:
                print("VLCMediaPlayerDelegate: PAUSED")
                
            case .ended:
                print("VLCMediaPlayerDelegate: ENDED")
                
            case .esAdded:
                print("VLCMediaPlayerDelegate: ELEMENTARY STREAM ADDED")
            default:
                break
            }
        }
    }
    
}
