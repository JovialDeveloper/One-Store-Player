//
//  SeriesView.swift
//  One Store Player
//
//  Created by MacBook Pro on 30/11/2022.
//

import SwiftUI
import Combine
import AlertToast
import SDWebImageSwiftUI
struct SeriesView: View {
    @AppStorage(AppStorageKeys.layout.rawValue) var layout: AppKeys.RawValue = AppKeys.modern.rawValue
    @Environment(\.presentationMode) var presentationMode
    var title : String
    var type:ViewType
    @State var selectMoview = 0
    //    init(){
    //        UITableView.appearance().backgroundColor = .red
    //        UITableView.appearance().ce
    //    }
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            
            if layout == AppKeys.modern.rawValue {
                // Modern View
                ModernLayoutView(subject: (title,type))
            }
            else {
                ClassicLayoutView(subject: (title,type))
            }
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        
        
    }
}


extension SeriesView{
    struct ModernLayoutView:View{
        @Environment(\.presentationMode) var presentationMode
        var subject : (String,ViewType)
        @StateObject private var vm = SeriesModernLayoutViewModel()
        @State private var categories = [MovieCategoriesModel]()
        @State private var series = [SeriesModel]()
        var body: some View {
            ZStack{
                HStack{
                    ScrollView{
                        LazyVStack{
                            ForEach(categories,id: \.categoryID) { category in
                                VStack{
                                    Text(category.categoryName)
                                        .font(.carioRegular)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth:.infinity,alignment: .leading)
                                    
                                    Divider().frame(height:1)
                                        .overlay(Color.white)
                                    
                                }.onTapGesture {
                                    vm.fetchAllSeriesById(id: category.categoryID, type: subject.1)
                                        .sink { subError in
                                            
                                            switch subError {
                                            case .failure(let error):
                                                vm.isLoading = false
                                                debugPrint(error)
                                            case .finished:
                                                vm.isLoading = false
                                                break
                                            }
                                        } receiveValue: { series in
                                            vm.isLoading = false
                                            self.series = series
                                        }.store(in: &vm.subscriptions)

                                }
                                
                                
                            }
                            
                        }
                    }
                    .padding(.top,30)
                    .frame(width:UIScreen.main.bounds.width/3.5,height: UIScreen.main.bounds.height)
                    Spacer()
                    
                    VStack{
                        NavigationHeaderView(title: subject.0)
                        SeriesGridView(data: $series)
                    }
                    
                    
                }
                .frame(maxWidth:.infinity,maxHeight: .infinity)
                .toast(isPresenting: $vm.isLoading) {
                    AlertToast(displayMode: .alert, type: .loading)
                }
            }.onAppear {
                vm.fetchAllSeriesCategories(type: .series)
                    .sink { subError in
                        //
                    } receiveValue: { categories in
                        self.categories = categories
                    }.store(in: &vm.subscriptions)

            }
        }
    }
    class SeriesModernLayoutViewModel:ObservableObject{
        @Published var isLoading = false
        @Published var isfetched = false
        @Published var isError = (false,"")
        var subscriptions = [AnyCancellable]()
        func fetchAllSeriesCategories(baseURL:String = "http://1player.cc:80",type:ViewType) -> AnyPublisher<[MovieCategoriesModel], APIError>
        {
            guard let userInfo =  Networking.shared.getUserDetails()
            else {
                return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
            }
            
            let uri = "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series_categories"
            
            return Networking.shared.fetch(uri: uri)
        }
        
        func fetchAllSeriesById(baseURL:String = "http://1player.cc:80",id:String,type:ViewType) -> AnyPublisher<[SeriesModel], APIError>
        {
            guard let userInfo =  Networking.shared.getUserDetails()
            else {
                return Fail(error: APIError.apiError(reason: "user Info is wrong")).eraseToAnyPublisher()
            }
            isLoading.toggle()
            let uri = "\(baseURL)/player_api.php?username=\(userInfo.username)&password=\(userInfo.password)&action=get_series&category_id=\(id)"
            return Networking.shared.fetch(uri: uri)
        }
    }
    
    
    struct SeriesGridView:View{
        @Binding var data : [SeriesModel]
        
        let columns : [GridItem] = Array(repeating: .init(.flexible(),spacing: 10), count: 4)
        //        @ObservedObject fileprivate var viewModel = MediaViewModel()
        @State private var isShowWatch = false
        @State private var selectItem : SeriesModel?
        var body: some View{
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(data, id: \.num) { item in
                        Button {
                            selectItem = item
                        } label: {
                            SeriesCell(serie: item)
                                
                        }.padding(.all,5)
                    }
                }
            }
            .onChange(of: selectItem, perform: { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    self.isShowWatch.toggle()
                }
            })
            .fullScreenCover(isPresented: $isShowWatch) {
                WatchView(data: selectItem)
            }
        }
        
    }
    
    struct SeriesCell:View{
        var width : CGFloat = 120
        var height : CGFloat = 180
        var serie : SeriesModel
        var body: some View{
#if os(tvOS)
            return  ZStack{
                WebImage(url: .init(string:serie.cover))
                    .resizable()
                    .frame(minWidth: width,minHeight: height)
                //.frame(width:width,height: height)
                    .scaledToFill()
                //.clipped()
                    .overlay(imageOverLayView,alignment: .bottom)
                    .overlay(ratingView,alignment: .topLeading)
                
                //.frame(height: 130)
            }.cornerRadius(5)
#else
            return ZStack{
                WebImage(url: .init(string:serie.cover))
                    .resizable()
                    .frame(width:width,height: height)
                    .scaledToFill()
                //.clipped()
                    .overlay(imageOverLayView,alignment: .bottom)
                    .overlay(ratingView,alignment: .topLeading)
                
                //.frame(height: 130)
            }.cornerRadius(5)
#endif
        }
        
        var ratingView:some View{
            ZStack{
                Text("\(String(format: "%.2f",serie.rating5Based))")
                    .font(.carioLight)
                    .foregroundColor(.white)
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
            }
            .frame(width: 40,height: 20)
            .background(Color.purple.cornerRadius(5))
            //.opacity(0.4)
        }
        
        var imageOverLayView:some View{
            VStack{
                Text(serie.name)
                    .font(.carioBold)
                    .foregroundColor(.white)
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
            }
            .padding()
            .frame(maxWidth:.infinity,maxHeight: 65)
            .background(Color.black.opacity(0.4))
        }
    }
    
}
