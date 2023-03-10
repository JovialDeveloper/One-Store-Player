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
    @Environment(\.presentationMode) var presentationMode
    @State private var selectDatum : Datum?
    @State private var selectedDate = "Today"
    var body: some View {
        GeometryReader {
            proxy in
            VStack{
                // Header
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .frame(width:46,height: 46)
                    
                    Spacer()
                    Text("Matches")
                        .font(.carioBold)
                    HStack{
                        Text(selectedDate)
                            .font(.carioRegular)
                        
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .frame(width: 200,height: 56)
                    .background(Capsule().stroke(lineWidth: 2).fill(Color.white))
                    .contextMenu {
                        Button {
                            selectedDate = "Now"
                        } label: {
                            Label("Now", image: "")
                        }
                        
                        Button {
                            selectedDate = "Yesterday"
                        } label: {
                            Label("Yesterday", image: "")
                        }
                        
                        Button {
                            selectedDate = "Tomorrow"
                        } label: {
                            Label("Tomorrow", image: "")
                        }

                    }
                    Spacer()
                    
                }
                .padding()
                .foregroundColor(.white)
                //
                HStack {
                    ScrollView{
                        LazyVStack(spacing:10) {
                            
                           ForEach(datum ?? []) {
                                itm in
                               if #available(tvOS 16.0, *) {
                                   HStack{
                                       WebImage(url: .init(string:itm.league?.logo ?? ""))
                                           .resizable()
                                           .frame(width:40,height:40)
                                           .scaledToFill()
                                           .clipped()
                                       Spacer()
                                       Text(itm.league?.name?.rawValue ?? "")
                                           .frame(maxWidth: .infinity,alignment: .leading)
                                       
                                   }
                                   .foregroundColor(.white)
                                   .frame(width:proxy.size.width * 0.4,height:80)
                                   .background(Rectangle().fill(Color.secondaryColor))
                                   .onTapGesture {
                                       selectDatum = itm
                                   }
                               } else {
                                   // Fallback on earlier versions
                               }
                                
                                
                            }
                            
                            
                            
                        }
                    }
                    .frame(width:proxy.size.width * 0.4,height:proxy.size.height)
                    .onChange(of: datum ?? []) { newValue in
                        selectDatum = newValue[0]
                    }
                    
                    ScrollView{
                        if selectDatum != nil {
                            Fixtures_SocroesCell(data: selectDatum!)
                                .padding(.top,30)
                        }
                        
                    }
                    //.padding(.top,80)
                    .frame(width:proxy.size.width * 0.6,height:proxy.size.height)
                }
            }
            
        }
        .background(Color.primaryColor.ignoresSafeArea())
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
            if #available(tvOS 15.0, *) {
                FixturesScoresView()
                    .previewInterfaceOrientation(.landscapeLeft)
            } else {
                // Fallback on earlier versions
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

fileprivate struct Fixtures_SocroesCell:View{
    var data : Datum
    
    var body: some View{
        HStack(spacing:10){
            VStack(spacing:20){
                Text(data.updatedAt ?? "")
                    .font(.carioRegular)
                WebImage(url: .init(string: data.teams?[0].logo ?? ""))
                    .resizable()
                    .frame(width: 60,height: 60)
                
                Text(data.teams?[0].name ?? "")
                    .font(.carioRegular)
            }
            HStack{
                Text(data.penaltyScore?.numGoalsAway ?? "0")
                    .font(.carioBold)
                Text("-")
                Text(data.penaltyScore?.numGoalsHome ?? "0")
                    .font(.carioBold)
            }
            
            VStack(spacing:20){
                Text(data.updatedAt ?? "")
                    .font(.carioRegular)
                WebImage(url: .init(string: data.teams?[1].logo ?? ""))
                    .resizable()
                    .frame(width: 60,height: 60)
                
                Text(data.teams?[1].name ?? "")
                    .font(.carioRegular)
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(Rectangle().fill(Color.secondaryColor))
        .frame(height: 100)
        
    }
    
    
}

struct TeamCell:View{
    var data : Datum
    var body: some View{
        HStack(spacing:20){
            Text(data.updatedAt ?? "")
                .font(.carioRegular)
            WebImage(url: .init(string: data.teams?[0].logo ?? ""))
                .resizable()
                .frame(width: 30,height: 30)
            
            Text("12-22-2022")
                .font(.carioRegular)
        }
    }
}

/*
 ForEach(item. ?? [],id: \.id) {
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
 */
