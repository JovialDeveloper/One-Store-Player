//
//  WatchView.swift
//  One Store Player
//
//  Created by MacBook Pro on 19/11/2022.
//

import SwiftUI

struct WatchView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var rating = 5
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
                    
                    Text("title")
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
                .padding(.top,30)
                .padding(.horizontal)
                
                ScrollView{
                    VStack{
                        HStack{
                            
                            VStack{
                                Image("Icon")
                                    .resizable()
                                    .frame(width:130,height: 180)
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                
                                RatingView(rating: $rating)
                            }
                            
                            VStack(alignment: .leading, spacing:20){
                                SubscriptionCell(title: "Directed By:", description: "N/A")
                                SubscriptionCell(title: "Release Date:", description: "N/A")
                                SubscriptionCell(title: "Duration:", description: "N/A")
                                SubscriptionCell(title: "Genre:", description: "N/A")
                                SubscriptionCell(title: "Cast:", description: "N/A")
                            }
                        }
                        
                        Button {
                            // watch
                        } label: {
                            Text("WATCH")
                                .font(.carioRegular)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 140,height: 46)
                        }.background(Rectangle().fill(Color.blue))

                        
                        Text("BLA BLA BLA BLA BAL ABLAB BBLLABBA")
                            .font(.carioRegular)
                            .foregroundColor(.white)
                            .padding()
                        
                    }
                    
                }
            }
        }
    }
}

struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        WatchView()
    }
}

struct RatingView:View{
    
    @Binding var rating: Int

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

            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
//                    .onTapGesture {
//                        rating = number
//                    }
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
