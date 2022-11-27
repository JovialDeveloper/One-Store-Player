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
    @StateObject private var vm = LiveStreamingViewModel()
    @State private var streams = [LiveStreams]()
    @State private var subStreams = [LiveStreams]()
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            if #available(tvOS 16.0, *) {
                AVPlayerControllerRepresented(player: .init())
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
                    //.frame(maxWidth: .infinity,maxHeight: .infinity)
            }
            
        }.onAppear {
            vm.fetchAllLiveStreaming().sink { SubscriberError in
                switch SubscriberError {
                case .failure(let error):
                    break
                case .finished:
                    break
                }
            } receiveValue: { livestreams in
                self.streams = livestreams
            }.store(in: &vm.subscriptions)

        }
    }
    
    var overLayView:some View{
        HStack{
            Spacer(minLength: 80)
            HStack{
                ScrollView {
                    LazyVStack {
                        ForEach(streams) { stream in
                            Text(stream.name)
                                .font(.carioRegular)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth:.infinity,alignment: .leading)
                                .onTapGesture {
                                    vm.fetchAllSubStreamsInCategory(category: stream.categoryID).sink { SubscriberError in
                                        switch SubscriberError {
                                        case .failure(let error):
                                            break
                                        case .finished:
                                            break
                                        }
                                    } receiveValue: { livestreams in
                                        self.subStreams.removeAll()
                                        self.subStreams = livestreams
                                    }.store(in: &vm.subscriptions)
                                }
                        }
                    }
                    .background(Color.secondaryColor)
                }
                
                ScrollView {
                    LazyVStack {
                        ForEach(subStreams) { stream in
                            Text(stream.name)
                                .font(.carioRegular)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth:.infinity,alignment: .leading)
                        }
                    }
                    .background(Color.secondaryColor)
                }
            }
            .frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.height)
            .background(Color.secondaryColor)
            
            
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
