//
//  CatchUpView.swift
//  One Store Player
//
//  Created by MacBook Pro on 19/12/2022.
//

import SwiftUI
import AlertToast

struct CatchUpView: View {
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title: "Catch Up",isHideOptions: true)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<1, id: \.self) { item in
                           CatchUpRowCell(data: "ALL")
                        }
                    }
                }
                
            }
            
        }
    }
}

struct CatchUpView_Previews: PreviewProvider {
    static var previews: some View {
        CatchUpView()
    }
}
extension CatchUpView{
    struct CatchUpRowCell:View{
        let data:String
        @State var isToastToggle = false
        var body: some View{
            HStack{
                // Logo
                Image("tv")
                    .resizable()
                    .frame(width:40,height: 40)
                    .scaledToFill()
                    .foregroundColor(.white)
                Spacer()
                
                Text(data)
                    .font(.carioBold)
                    .padding()
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .foregroundColor(.white)
                Spacer()
                
                
                
                Spacer()
                // Users Catalog
                Text("")
                    .font(.carioBold)
                    .foregroundColor(.white)
                
                HStack{
                    Button {
                        isToastToggle.toggle()
                    } label: {
                        Image("arrow_right")
                            .resizable()
                            .frame(width:30,height: 30)
                            .scaledToFill()
                            .foregroundColor(.white)
                    }
                    .frame(width:40,height: 40)
                }
                
            }
            .padding()
            .frame(maxWidth:.infinity,maxHeight: 60)
            .background(RoundedRectangle(cornerRadius: 2).fill(Color.secondaryColor))
            .toast(isPresenting: $isToastToggle) {
                AlertToast(type: .regular, title: "No Program Available")
            }
        }
    }
}
