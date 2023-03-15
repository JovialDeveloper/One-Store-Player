//
//  NavigationHeaderView.swift
//  One Store Player
//
//  Created by MacBook Pro on 09/11/2022.
//

import SwiftUI
import MbSwiftUIFirstResponder
struct NavigationHeaderView: View {
    var title:String
    var isHideOptions = false
    @State private var isSeachFieldHide = true
    @State private var searchText = ""
    var searchAction : ((String)->Void)? = nil
    var moreAction : (()->Void)? = nil
    
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
                
                VStack{
                    
                    
                    CustomTextField(searchText: $searchText, isSeachFieldHide: $isSeachFieldHide,searchAction: searchAction)
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(height:1.5)
                }
                

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
                }
                .ignoresSafeArea(.container,edges: .bottom)
            }
            // Users Button
            Menu {
                Button {
                    moreAction?()
                } label: {
                    Label("Reload", image: "ic_update")
                }
            } label: {
                Image("more")
                    .resizable()
                    .frame(width:40,height: 40)
                    .scaledToFill()
                    .foregroundColor(.white)
            }

//            
//            Image("more")
//                .resizable()
//                .frame(width:40,height: 40)
//                .scaledToFill()
//                .foregroundColor(.white)
//                .contextMenu {
//                    Button {
//                        moreAction?()
//                    } label: {
//                        Label("Reload", image: "ic_update")
//                    }
//
//                }
            
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

struct CustomTextField:View{
    @Binding var searchText:String
    @Binding var isSeachFieldHide : Bool
    var searchAction : ((String)->Void)? = nil
    enum FirstResponders: Int {
        case name
        case email
        case notes
    }
    @State var firstResponder: FirstResponders? = nil
    var body: some View {
        TextField("", text: $searchText) {
            isSeachFieldHide.toggle()
            searchAction?(searchText)
        }
        .firstResponder(id: FirstResponders.name, firstResponder: $firstResponder, resignableUserOperations: .all)
        .placeholder(when: searchText.isEmpty) {
                Text("Search").foregroundColor(.gray)
        }
        .foregroundColor(.white)
    }
    
}
