//
//  WatchView.swift
//  One Store Player
//
//  Created by MacBook Pro on 19/11/2022.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI
import _AVKit_SwiftUI
struct WatchView<T:Codable>: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var rating = 5
    var data : T
    @State var cancelable = [AnyCancellable]()
    @State var customObject : MovieModelWatchResponse?
    @State var seriesObject : SeriesResponse?
    @State var isWatch = false
    @State var id = 0
    @State var duration = ""
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
                            //
                        } label: {
                            Image("icon")
                                .resizable()
                                .frame(width:40,height: 40)
                                .scaledToFill()
                                .foregroundColor(.white)
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
                                WebImage(url: .init(string: data is MovieModel ? customObject?.info.movieImage ?? "" : seriesObject?.info?.cover ?? ""))
                                    .resizable()
                                    .frame(width:140,height: 240)
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                
                                RatingView(rating: data is MovieModel ? Int(customObject?.info.rating ?? "0.0") ?? 5 : Int(seriesObject?.info?.rating ?? "0.0") ?? 5)
                            }
                            
                            VStack(alignment: .leading, spacing:20){
                                SubscriptionCell(title: "Directed By:", description: data is MovieModel ? customObject?.info.director ?? "" : seriesObject?.info?.director ?? "")
                                SubscriptionCell(title: "Release Date:", description: data is MovieModel ? customObject?.info.releasedate ?? "" : seriesObject?.info?.releaseDate ?? "")
                                SubscriptionCell(title: "Duration:", description: data is MovieModel ? customObject?.info.duration ?? "" : seriesObject?.info?.episodeRunTime ?? "")
                                SubscriptionCell(title: "Genre:", description: data is MovieModel ? customObject?.info.genre ?? "" : seriesObject?.info?.genre ?? "")
                                SubscriptionCell(title: "Cast:", description: data is MovieModel ? customObject?.info.cast ?? "" : seriesObject?.info?.cast ?? "")
                            }
                        }
                        
                        Button {
                            // watch
                            id = data is MovieModel ? (data as! MovieModel).streamID : (data as! SeriesModel).seriesID
                            duration =  data is MovieModel ? customObject?.info.duration ?? "" : seriesObject?.info?.episodeRunTime ?? ""
                            
                            
                        } label: {
                            Text("WATCH")
                                .font(.carioRegular)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 140,height: 46)
                        }.background(Rectangle().fill(Color.blue))

                        
                        Text((data is MovieModel ? customObject?.info.infoDescription ?? "" : seriesObject?.info?.plot) ?? "")
                            .font(.carioRegular)
                            .foregroundColor(.white)
                            .padding()
                        
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
        .sheet(isPresented: $isWatch) {
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
                NavigationView{
                    VLCView(link: Networking.shared.getStreamingLink(id: id, type: ViewType.series.rawValue), isOvarLayHide: false)
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
    
    func fetchDataRequest<T:Codable>(baseURL:String) -> AnyPublisher<T, APIError>{
        
        return Networking.shared.fetch(uri: baseURL)
    }
}


struct RatingView:View{
    
    var rating: Int

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View{
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            if Double(rating) > 5.0 {
                ForEach(1..<maximumRating + 1, id: \.self) { number in
                    onImage.foregroundColor(onColor)
                }
            }else{
                ForEach(1..<maximumRating + 1, id: \.self) { number in
                    image(for: number)
                        .foregroundColor(number > rating ? offColor : onColor)
    //                    .onTapGesture {
    //                        rating = number
    //                    }
                }
            }
            
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}


