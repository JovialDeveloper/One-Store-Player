//
//  LIveTVView.swift
//  One Store Player
//
//  Created by MacBook Pro on 25/11/2022.
//

import SwiftUI
import AVKit
struct LIveTVView: View {
    @State private var isRemoveOverLay = false
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        ZStack{
            if #available(tvOS 16.0, *) {
                AVPlayerControllerRepresented(player: .init())
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .onTapGesture {
                        isRemoveOverLay.toggle()
                    }
            } else {
                // Fallback on earlier versions
            }
//                .overlay(overLayView)
            if !isRemoveOverLay {
                overLayView
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
            }
            
        }
    }
    
    var overLayView:some View{
        HStack{
            HStack{
                List(0..<8){_ in
                    Text("Movie Name")
                        .font(.carioRegular)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth:.infinity,alignment: .leading)
                        .listRowBackground(Color.secondaryColor)
                }
                .listStyle(PlainListStyle())
                
                List(0..<8){_ in
                    Text("Movie Name")
                        .font(.carioRegular)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth:.infinity,alignment: .leading)
                        .listRowBackground(Color.secondaryColor)
                }
                .listStyle(PlainListStyle())
            }
            .frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height)
            .background(Color.gray)
            VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("arrow_back")
                            .resizable()
                            .frame(width: 30,height: 30)
                    }
                    Button {
                        // Search
                    } label: {
                        Image("search")
                            .resizable()
                            .frame(width: 30,height: 30)
                    }
                    Button {
                        // Search
                    } label: {
                        Image("icon_sort")
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
        .ignoresSafeArea()
        
    }
}

struct LIveTVView_Previews: PreviewProvider {
    static var previews: some View {
        LIveTVView()
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
        
    }
}
