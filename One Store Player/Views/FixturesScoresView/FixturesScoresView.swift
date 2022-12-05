//
//  FixturesScoresView.swift
//  One Store Player
//
//  Created by MacBook Pro on 03/12/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct FixturesScoresView: View {
    @StateObject private var vm = FixturesScoresViewModel()
    @State private var data : Fixtures_ScoresModel?
    @State private var events : [Event]?
    @State private var datum : [Datum]?
    var body: some View {
        ZStack{
            GeometryReader {
                proxy in
                VStack{
                    // Header
                    
                    //
                    HStack {
                        ScrollView{
                            LazyVStack {
                                ForEach(datum ?? [],id: \.id) {
                                    item in
                                    ForEach(item.teams ?? [],id: \.id) {
                                        event in
                                        HStack{
                                            WebImage(url: .init(string:event.logo ?? ""))
                                                .resizable()
                                                .frame(width:40,height:40)
                                                .scaledToFill()
                                                .clipped()
                                            Text(event.name ?? "")
                                        }.frame(height:80)
                                    }
                                }
                                
                                
                                
                            }
                        }
                        .frame(width:proxy.size.width * 0.4,height:proxy.size.height)
                    }
                }
                
            }
            
        }
        .onAppear {
            DispatchQueue.global().async {
                vm.fetchData()
            }
            
            
            //            vm.fetchFixtures_Scores().sink { subError in
            //                switch subError {
            //                case .finished:
            //                    break
            //                case .failure(let error):
            //                    debugPrint(error)
            //                }
            //            } receiveValue: { fixturesModel in
            //                debugPrint(fixturesModel)
            //
            //            }.store(in: &vm.storeAble)
            
        }
        .onChange(of: vm.model) { newValue in
            debugPrint("Models",newValue)
            datum = newValue?.data
        }
        
    }
}

struct FixturesScoresView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            FixturesScoresView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
