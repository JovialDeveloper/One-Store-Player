//
//  WatchView.swift
//  One Store Player
//
//  Created by MacBook Pro on 19/11/2022.
//

import SwiftUI
import Combine
import Kingfisher
import _AVKit_SwiftUI
struct WatchView<T:Codable>: View {
    @Environment(\.presentationMode) private var presentationMode
    @AppStorage(AppStorageKeys.language.rawValue) private var lang = ""
    @State var rating = 5
    var data : T
    @State var cancelable = [AnyCancellable]()
    @State var customObject : MovieModelWatchResponse?
    @State var seriesObject : SeriesResponse?
    @State var selectedEpisode:The1?
    @State var isWatch = false
    @State var id = 0
    @State var duration = ""
    @State private var currentSeason = "SEASON-1"
    @State private var selectedIndex = 0
    @EnvironmentObject var favMovies : MoviesFavourite
    @EnvironmentObject var favSeries : SeriesFavourite
    @State private var isFavourite = false
    @State private var moreText = false
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                HStack{
                    // Logo
                    if #available(iOS 13.0,tvOS 16.0, *) {
                        Image("arrow_back")
                            .resizable()
                            .frame(width:40,height: 40)
                            .scaledToFill()
                            .foregroundColor(.white)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                    Spacer()
                    
                    Text(data is MovieModel ? (data as! MovieModel).name ?? "" : (data as! SeriesModel).name)
                        .font(.carioBold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    // Users Catalog
                    HStack{
                        Button {
                            if data is MovieModel {
                                isFavourite = true
                                favMovies.saveMovies(model: data as! MovieModel)
                            }else{
                                isFavourite = true
                                favSeries.saveMovies(model: data as! SeriesModel)
                            }
                        } label: {
                            Image("heart")
                                .resizable()
                                .frame(width:40,height: 40)
                                .scaledToFill()
                                .foregroundColor(isFavourite ? Color.red : Color.white)
                        }
                        .frame(width:40,height: 40)
                        
                    }
                    
                }
                .frame(height: 46)
                .padding(.horizontal)
                
                ScrollView{
                    VStack{
                        HStack{
                            
                            VStack{
                                KFImage(.init(string: data is MovieModel ? customObject?.info.movieImage ?? "" : seriesObject?.info?.cover ?? ""))
                                    .resizable()
                                    .placeholder({
                                        Image("NoImage")
                                            .frame(minWidth: 140,minHeight: 240)
                                            .scaledToFill()
                                        
                                    })
                                    .frame(width:140,height: 240)
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                
                                RatingView(rating: data is MovieModel ? customObject?.info.rating ?? RatingsEnum.integer(5.0) : seriesObject?.info?.rating ?? RatingsEnum.integer(5.0))
                            }
                            
                            VStack(alignment: .leading, spacing:20){
                                SubscriptionCell(title: "Directed By:", description: data is MovieModel ? customObject?.info.director ?? "" : seriesObject?.info?.director ?? "")
                                
                                SubscriptionCell(title: "Release Date:", description: data is MovieModel ? customObject?.info.releasedate ?? "" : seriesObject?.info?.releaseDate ?? "")
                                
                                SubscriptionCell(title: "Duration:", description: data is MovieModel ? customObject?.info.duration ?? "" : seriesObject?.info?.episodeRunTime ?? "")
                                SubscriptionCell(title: "Genre:", description: data is MovieModel ? customObject?.info.genre ?? "" : seriesObject?.info?.genre ?? "")
                                if data is SeriesModel {
//                                    SubscriptionCell(title: "Plot:", description:seriesObject?.info?.plot ?? "")
                                    
                                    ZStack{
                                        HStack(spacing: 20){
                                            Text("Plot:".localized(lang))
                                                .font(.carioBold)
                                                .foregroundColor(.white)
                                                //.frame(maxWidth: .infinity,alignment: .leading)
                                            
                                            Group {
                                                VStack{
                                                    Text(seriesObject?.info?.plot?.localized(lang) ?? "")
                                                        .font(.carioRegular)
                                                        .foregroundColor(.white)
                                                        .frame(width: 300)
                                                        .lineLimit(moreText ? 15: 2)
                                                    
                                                    Button(action: {
                                                        self.moreText.toggle()
                                                        
                                                    } ) {
                                                        Text(moreText ? "Read less" : "Read more")
                                                            .foregroundColor(.red)
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                }else {
                                    SubscriptionCell(title: "Cast:", description: data is MovieModel ? customObject?.info.cast ?? "" : seriesObject?.info?.cast ?? "")
                                }

                            }
                        }
                    
                        if data is SeriesModel, let episodes = seriesObject?.episodes{
                            HStack {
                                Button {
                                    // watch
                                    duration =  episodes.the1?[0].info?.duration ?? ""
                                    selectedEpisode = episodes.the1?[0]
                                    id = Int(episodes.the1?[0].id ?? "") ?? 0
                                    

                                } label: {
                                    HStack{
                                        Text("pl_ay".localized(lang))
                                            .font(.carioRegular)
                                            .foregroundColor(.white)
                                            .padding()
                                            //.frame(width: 140,height: 46)

                                        Text("\(episodes.the1?[0].episodeNum ?? 0)")
                                            .font(.carioRegular)
                                            .foregroundColor(.white)
                                            .padding()
                                            //.frame(width: 140,height: 46)
                                    }.frame(width: 140,height: 46)

//
                                }.background(Rectangle().fill(Color.blue))


                                Menu {
                                    ForEach(seriesObject?.seasons ?? [],id:\.id) {
                                        item in
                                        Button {
                                            currentSeason = item.name ?? ""
                                        } label: {
                                            Text(item.name ?? "")
                                        }

                                    
                                    }
                                } label: {
                                    Button {
    //                                    // watch
    //                                    id = data is MovieModel ? (data as! MovieModel).streamID : (data as! SeriesModel).seriesID
    //                                    duration =  data is MovieModel ? customObject?.info.duration ?? "" : seriesObject?.info?.episodeRunTime ?? ""


                                    } label: {
                                        Text(currentSeason)
                                            .font(.carioRegular)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 140,height: 46)
                                    }.background(Rectangle().fill(Color.secondaryColor))
                                }

                            }
                            
                            // Tab Section
                            HStack{
                                HStack{
                                    VStack{
                                        Text("epi".localized(lang))
                                        Rectangle()
                                            .foregroundColor(selectedIndex == 0 ? Color.blue : Color.clear)
                                            .frame(height:1)
                                    }
                                    .onTapGesture {
                                        selectedIndex = 0
                                    }
                                    
                                    VStack{
                                        Text("cast".localized(lang))
                                        Rectangle()
                                            .foregroundColor(selectedIndex == 1 ? Color.blue : Color.clear)
                                            .frame(height:1)
                                    }.onTapGesture {
                                        selectedIndex = 1
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(width:UIScreen.main.bounds.width * 0.3,height: 46)
                                .background(Rectangle().foregroundColor(Color.secondaryColor))
                                
                                Spacer()
                            
                            }
                            if selectedIndex == 0 {
                                SeasonsView(episode: episodes, id: $id,selectedEpisode: $selectedEpisode)
                                    .frame(maxHeight:.infinity)
                                    
                            }
                            else {
                                Text(seriesObject?.info?.cast ?? "")
                                    .font(.carioRegular)
                                    .foregroundColor(.white)
                            }
                            
                        }else {
                            Button {
                                // watch
                                if data is MovieModel {
                                    if let movieModel : MovieModel = LocalStorgage.store.getSingleObject(key: String((data as! MovieModel).streamID)) {
                                        id = movieModel.streamID
                                    }else{
                                        id = data is MovieModel ? (data as! MovieModel).streamID : (data as! SeriesModel).seriesID
                                    }
                                    
                                }else if data is SeriesModel {
                                    if let movieModel : SeriesModel = LocalStorgage.store.getSingleObject(key: String((data as! SeriesModel).seriesID)) {
                                        id = movieModel.seriesID
                                    }else{
                                        id = data is MovieModel ? (data as! MovieModel).streamID : (data as! SeriesModel).seriesID
                                    }
                                }
                                
                            } label: {
                                if data is MovieModel {
                                    if let mod : MovieModel =  LocalStorgage.store.getSingleObject(key: String((data as! MovieModel).streamID)) {
                                        Text("RESUME")
                                            .font(.carioRegular)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 140,height: 46)
                                    }else{
                                        Text("WATCH")
                                            .font(.carioRegular)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 140,height: 46)
                                    }
                                    
                                }else if data is SeriesModel {
                                    if let mod : SeriesModel =  LocalStorgage.store.getSingleObject(key: String((data as! SeriesModel).seriesID)) {
                                        Text("RESUME")
                                            .font(.carioRegular)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 140,height: 46)
                                    }else{
                                        Text("WATCH")
                                            .font(.carioRegular)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 140,height: 46)
                                    }
                                }
                                
                            }.background(Rectangle().fill(Color.blue))

                            
                            Text((data is MovieModel ? customObject?.info.infoDescription ?? "" : seriesObject?.info?.plot) ?? "")
                                .font(.carioRegular)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    
                }
          
            }
            .padding()
        }
        .onAppear {
            if data is MovieModel {
                
                guard let userInfo =  Networking.shared.getUserDetails()
                else {
                    return 
                }
                if userInfo.port.last == "/" {
                    let uri = "\(userInfo.port)player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_vod_info&vod_id=\((data as! MovieModel).streamID)"
                    
                    let data : AnyPublisher<MovieModelWatchResponse, APIError> = fetchDataRequest(baseURL: uri)
                    data.sink { subError in
                        switch subError {
                        case .finished:
                            break
                        case .failure(let error):
                            debugPrint(error)
                            break
                        }
                    } receiveValue: { response in
                        debugPrint(response)
                        customObject = response
                    }.store(in: &cancelable)
                }else{
                    let uri = "\(userInfo.port)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_vod_info&vod_id=\((data as! MovieModel).streamID)"
                    
                    let data : AnyPublisher<MovieModelWatchResponse, APIError> = fetchDataRequest(baseURL: uri)
                    
                    data.sink { subError in
                        switch subError {
                        case .finished:
                            break
                        case .failure(let error):
                            debugPrint(error)
                            break
                        }
                    } receiveValue: { response in
                        debugPrint(response)
                        customObject = response
                    }.store(in: &cancelable)
                }
                

            }else{
                guard let userInfo =  Networking.shared.getUserDetails()
                else {
                    return
                }
                if userInfo.port.last == "/" {
                    let uri = "\(userInfo.port)player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series_info&series_id=\((data as! SeriesModel).seriesID)"
                    
                    let data : AnyPublisher<SeriesResponse, APIError> = fetchDataRequest(baseURL: uri)
                    data.sink { subError in
                        switch subError {
                        case .finished:
                            break
                        case .failure(let error):
                            debugPrint(error)
                            break
                        }
                    } receiveValue: { response in
                        debugPrint(response)
                        seriesObject = response
                    }.store(in: &cancelable)
                }else{
                    let uri = "\(userInfo.port)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series_info&series_id=\((data as! SeriesModel).seriesID)"
                    
                    let data : AnyPublisher<SeriesResponse, APIError> = fetchDataRequest(baseURL: uri)
                    
                    data.sink { subError in
                        switch subError {
                        case .finished:
                            break
                        case .failure(let error):
                            debugPrint(error)
                            break
                        }
                    } receiveValue: { response in
                        debugPrint(response)
                        seriesObject = response
                    }.store(in: &cancelable)
                }
            }
            
        }
        .onChange(of: id, perform: { new in
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.isWatch.toggle()
            }
        })
        .fullScreenCover(isPresented: $isWatch) {
            
            if data is MovieModel {
                NavigationView{
                    VLCView(link:Networking.shared.getStreamingLink(id: id, type: ViewType.movie.rawValue), isOvarLayHide: false)
                        .ignoresSafeArea()
                        .toolbar {
                            ToolbarItem(placement:.navigationBarLeading) {
                                Button {
                                    isWatch.toggle()
                                } label: {
                                    Image("arrow_back")
                                        .resizable()
                                        .frame(width:46,height:46)
                                        
                                }
                                .frame(width:46,height:46)
                                .foregroundColor(Color.white)

                            }
                        }
                }
            }else{
                if let epi = selectedEpisode {
                    NavigationView{
                        VLCView(link: Networking.shared.getStreamingLink(id: id, type: ViewType.series.rawValue,format: epi.containerExtension ?? .mp4), isOvarLayHide: false)
                            .ignoresSafeArea()
                            .toolbar {
                                ToolbarItem(placement:.navigationBarLeading) {
                                    Button {
                                        isWatch.toggle()
                                    } label: {
                                        Image("arrow_back")
                                            .resizable()
                                            .frame(width:46,height:46)
                                    }
                                    .frame(width:46,height:46)
                                    .foregroundColor(Color.white)

                                }
                            }
            
                    }
                }
               
            }
            

            
            
        }
    }
    
    func fetchDataRequest<T:Codable>(baseURL:String) -> AnyPublisher<T, APIError>{
        
        return Networking.shared.fetch(uri: baseURL)
    }
}


struct RatingView:View{
    
    var rating: RatingsEnum

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.white
    var onColor = Color.selectedColor
    
    var body: some View{
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            switch rating{
            case .integer(let value):
                
                if value > 5.0 {
                    ForEach(1..<maximumRating + 1, id: \.self) { number in
                        onImage.foregroundColor(onColor)
                    }
                }else{
                    ForEach(1..<maximumRating + 1, id: \.self) { number in
                        image(for: number)
                            .foregroundColor(Double(number) > Double(value) ? offColor : onColor)
                    }
                }
                ///
            case .string(let value):
                if Double(value) ?? 0.0 > 5.0 {
                    ForEach(1..<maximumRating + 1, id: \.self) { number in
                        onImage.foregroundColor(onColor)
                    }
                }else{
                    ForEach(1..<maximumRating + 1, id: \.self) { number in
                        image(for: number)
                            .foregroundColor(Double(number) > Double(value) ?? 0.0 ? offColor : onColor)
                    }
                }
            }
            
            
        }
    }
    
    func image(for number: Int) -> Image {
        switch rating {
        case .integer(let value):
            if Double(number) > value {
                return offImage ?? onImage
            } else {
                return onImage
            }
        case .string(let value):
            if Double(number) > Double(value) ?? 0.0 {
                return offImage ?? onImage
            } else {
                return onImage
            }
        }
        
    }
}


