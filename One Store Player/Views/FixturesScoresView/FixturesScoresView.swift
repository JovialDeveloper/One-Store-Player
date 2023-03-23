//
//  FixturesScoresView.swift
//  One Store Player
//
//  Created by MacBook Pro on 03/12/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import ToastUI
struct FixturesScoresView: View {
    @StateObject private var vm = FixturesScoresViewModel()
    @State private var data : Fixtures_ScoresModel?
    @State private var events : [Event]?
    @State private var datum : [Datum]?
    @State private var groupData : [String:[Datum]]?
    @Environment(\.presentationMode) var presentationMode
    @State private var selectDatum : Datum?
    @State private var selectedDate = "today"
    
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
                    
                    Menu {
                        Button {
                            selectedDate = "now"
                            DispatchQueue.global().async {
                                vm.fetchData(time: selectedDate)
                            }
                        } label: {
                            Label("Now", image: "")
                        }
                        
                        Button {
                            selectedDate = "today"
                            DispatchQueue.global().async {
                                vm.fetchData(time: "today".getFormattedDates(value: 0))
                            }
                        } label: {
                            Label("today", image: "")
                        }
                        
                        Button {
                            selectedDate = "Yesterday"
                            DispatchQueue.global().async {
                                vm.fetchData(time: "Yesterday".getFormattedDates(value: -1))
                            }
                            
                        } label: {
                            Label("Yesterday", image: "")
                        }
                        
                        Button {
                            selectedDate = "Tomorrow"
                            DispatchQueue.global().async {
                                vm.fetchData(time: "Tomorrow".getFormattedDates(value: 1))
                            }
                        } label: {
                            Label("Tomorrow", image: "")
                        }
                    } label: {
                        HStack{
                            Text(selectedDate)
                                .font(.carioRegular)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .frame(width: 200,height: 56)
                        .background(Capsule().stroke(lineWidth: 2).fill(Color.white))
                    }
                    Spacer()
                    
                }
                .padding()
                .foregroundColor(.white)
                //
                if vm.isLoading {
                    ProgressView()
                        .frame(maxWidth:.infinity,maxHeight:.infinity)
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    
                }else {
                    HStack {
                        ScrollView{
                            LazyVStack(spacing:10) {
                                
                                if let groupings = groupData,
                                   let dataValues = groupings.map{$0.value}
                                {
                                    HStack{
                                        Image("ic_football")
                                            .resizable()
                                            .frame(width:40,height:40)
                                            .scaledToFill()
                                            .clipped()
                                        Spacer()
                                        Text("ALL")
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity,alignment: .leading)
                                        
                                    }
                                    .padding()
                                    .frame(width:proxy.size.width * 0.4,height:80)
                                    .background(Rectangle().fill(Color.secondaryColor))
                                    .onTapGesture {
                                        DispatchQueue.global().async {
                                            vm.fetchData(time: selectedDate.getFormattedDates(value: 0))
                                        }
                                        
                                    }
                                    
                                    ForEach(groupings.map{$0.key},id:\.self) {
                                        key in
                                        if let itm = groupings[key]?[0] {
                                            HStack{
                                                WebImage(url: .init(string:itm.league?.logo ?? ""))
                                                    .resizable()
                                                    .frame(width:40,height:40)
                                                    .scaledToFill()
                                                    .clipped()
                                                Spacer()
                                                Text(itm.league?.name ?? "")
                                                    .frame(maxWidth: .infinity,alignment: .leading)
                                                
                                            }
                                            .padding()
                                            .foregroundColor(.white)
                                            .frame(width:proxy.size.width * 0.4,height:80)
                                            .background(Rectangle().fill(Color.secondaryColor))
                                            .onTapGesture {
                                                datum = groupings[key]
                                            }
                                        }
    
                                    }
                                }
                                
                                
 
                                
                                
                            }
                        }
                        .frame(width:proxy.size.width * 0.4)
    //                    .onChange(of: datum ?? []) { newValue in
    //                        if newValue.count > 0 {
    //                            selectDatum = newValue[0]
    //                        }
    //
    //                    }
                        
                        ScrollView{
                            LazyVStack(spacing:10){
                                ForEach(datum ?? []) {
                                    data in
                                    Fixtures_SocroesCell(data: data)
                                        .frame(width:proxy.size.width * 0.7)
    //                                    .padding(.top,20)
                                }
                            }
                            

                        }
                    }
                }
                
                
                
            }
           
            
            
        }
        .background(Color.primaryColor.ignoresSafeArea())
        .onAppear {
            DispatchQueue.global().async {
                vm.fetchData(time: selectedDate.getFormattedDates(value: 0))
            }
            
            
           
        }
        .onChange(of: vm.model) { newValue in
            
            //datum = newValue?.data
            groupData = Dictionary(grouping: newValue?.data ?? [], by: { (teams) -> String  in
                return teams.league?.uniqueID ?? ""
            })
            
            datum = newValue?.data
//            if let grou = groupData {
//                grou.enumerated().forEach { index,item in
//                    datum = item.value
//                }
//
////                grou.keys.forEach { key in
////                    if let matches = grou[key] {
////                        datum = matches
////                    }
////
////                }
//            }

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
        VStack(spacing:20){
            HStack(spacing:10){
                Spacer()
                VStack(spacing:20){
                    Text(data.updatedAt?.getDateFormatted(givenFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", format: "yyyy-MM-dd") ?? "")
                        .font(.carioRegular)
                    WebImage(url: .init(string: data.teams?[0].logo ?? ""))
                        .resizable()
                        .frame(width: 60,height: 60)
                    Text(data.teams?[0].name ?? "")
                        .font(.carioRegular)
                    
                }
                Spacer()
                HStack{
                    Text(data.numGoalsAway ?? "0")
                        .font(.carioBold)
                    Text("-")
                    Text(data.numGoalsHome ?? "0")
                        .font(.carioBold)
                }
                Spacer()
                VStack(spacing:20){
                    Text(data.updatedAt?.getDateFormatted(givenFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", format: "yyyy-MM-dd") ?? "")
                        .font(.carioRegular)
                    WebImage(url: .init(string: data.teams?[1].logo ?? ""))
                        .resizable()
                        .frame(width: 60,height: 60)
                    
                    Text(data.teams?[1].name ?? "")
                        .font(.carioRegular)
                }
                Spacer()
                
            }
            
            Text(data.status?.longName ?? "")
                .font(.carioRegular)
        }
        .padding()
        .foregroundColor(.white)
//        .frame(width:UIScreen.main.bounds.width,height: 210)
        .background(Rectangle().fill(Color.secondaryColor))
        
        
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
