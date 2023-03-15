//
//  SeasonsView.swift
//  One Store Player
//
//  Created by MacBook Pro on 15/03/2023.
//

import SwiftUI
import Kingfisher
struct SeasonsView: View {
    let episode:Episodes
    @Binding var id:Int
    @Binding var selectedEpisode:The1?
    @AppStorage(AppStorageKeys.language.rawValue) private var lang = ""
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            LazyVStack(alignment:.leading){
                ForEach(episode.the1 ?? [],id: \.id)
                { item in
                    // Season Row View
                    HStack{
                        ZStack{
                            if let url = URL.init(string: item.info?.movieImage ?? "") {
                                KFImage(url)
                                    .resizable()
                                    .frame(width:250)
                                    .background(Rectangle()
                                        .foregroundColor(Color.black)
                                        .frame(width:250))
                            }else {
                                Rectangle()
                                    .foregroundColor(Color.black)
                                    .frame(width:250)
                            }
                            
                           
                            
                            Image("play")
                                .resizable()
                                .frame(width: 30,height: 30)
                                .scaledToFit()
                        }
                        
                        VStack(alignment:.leading){
                            Text(item.title ?? "")
                                .font(.carioBold)
                                .frame(maxWidth:.infinity,alignment: .leading)
                            if let ra = item.info?.rating {
                                RatingView(rating: ra)
                            }else {
                                RatingView(rating: .integer(0.0))
                            }
                            HStack{
                                Text("dr".localized(lang))
                                    .font(.carioRegular)
                                Text(":\(item.info?.duration ?? "")")
                                    .font(.carioRegular)
                                Spacer()
                            }
                            Spacer()
                        }.foregroundColor(.white)
                        
                        Spacer()
                    }
                    .frame(maxWidth:.infinity,maxHeight: 250)
                    .background(Rectangle().foregroundColor(.secondaryColor))
                    .onTapGesture {
                        if let it = Int(item.id ?? "") {
                            selectedEpisode = item
                            id = it
                        }
                        
                    }
                }
            }
            
        }
        
    }
}
//
//struct SeasonsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeasonsView()
//    }
//}
