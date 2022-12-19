//
//  NavigationHeaderView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI

struct NavigationHeaderView: View {
    var title:String
    @State private var isSeachFieldHide = true
    @State private var searchText = ""
    var searchAction : ((String)->Void)? = nil
    var moreAction : (()->Void)? = nil
    var isHideOptions = false
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(AppStorageKeys.language.rawValue) var lang = ""
    var body: some View {
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
            if !isSeachFieldHide {
                
                
                TextField("Search", text: $searchText) {
                    isSeachFieldHide.toggle()
                    searchAction?(searchText)
                }
                .foregroundColor(.white)

                
//                .toolbar {
////                    if #available(iOS 15.0, *) {
////                        ToolbarItemGroup(placement: .keyboard) {
////                            HStack{}
////                        }
////                    } else {
////                        // Fallback on earlier versions
////
////
////                    }
//                }

            }
            Text(title.localized(lang))
                .font(.carioBold)
                .foregroundColor(.white)
            
            Spacer()
            // Users Catalog
            if !isHideOptions {
                HStack{
                    Button {
                        
                        isSeachFieldHide.toggle()
                    } label: {
                        Image("search")
                            .resizable()
                            .frame(width:30,height: 30)
                            .scaledToFill()
                            .foregroundColor(.white)
                    }
                    .frame(width:40,height: 40)
                    
                    // Users Button
                    Image("more")
                        .resizable()
                        .frame(width:40,height: 40)
                        .scaledToFill()
                        .foregroundColor(.white)
                        .contextMenu {
                            Button {
                                moreAction?()
                            } label: {
                                Label("Reload", image: "ic_update")
                            }

                        }
                    
                }
                .ignoresSafeArea(.container,edges: .bottom)
            }
            
            //Spacer()
            
        }
        .padding(.top,30)
        .padding(.horizontal)
        .ignoresSafeArea(.container,edges: .bottom)
    }
}

struct NavigationHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationHeaderView(title: "")
    }
}


struct InputAccessory: UIViewRepresentable  {

    func makeUIView(context: Context) -> UITextField {

        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        customView.backgroundColor = UIColor.red
        let sampleTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        sampleTextField.inputAccessoryView = customView
        sampleTextField.placeholder = "placeholder"

        return sampleTextField
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
    }
}
